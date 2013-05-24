#!/bin/bash
DIRNAME=$( dirname "${BASH_SOURCE[0]}" )
DIR="$( cd "$DIRNAME" && pwd )"

WHO=`whoami`
if [ "$WHO" != "root" ]; then
    echo "You must run this script as root"
    exit 1;
fi

# Create bibos-archive user if it doesn't exist
grep "^bibos-archive:" /etc/passwd > /dev/null
if [ $? -ne 0 ]; then
    echo "Creating bibos-archive user..."
    useradd -d /home/bibos-archive -m -s /bin/false bibos-archive
    echo "Done"

    # Set up ssh stuff
    echo "Setting up sshkey for bibos-archive user..."
    if [ ! -d ~bibos-archive/.ssh ]; then
        mkdir -m 0700 ~bibos-archive/.ssh
        chown bibos-archive.bibos-archive ~bibos-archive/.ssh
    fi
    if [ ! -f ~bibos-archive/.ssh/authorized_keys ]; then
        touch ~bibos-archive/.ssh/authorized_keys
        chown bibos-archive.bibos-archive ~bibos-archive/.ssh/authorized_keys
        chmod 0600 ~bibos-archive/.ssh/authorized_keys
    fi

    cat ../image/clonezilla-overwrites/bibos/ssh/bibos-key.pub >> \
        ~bibos-archive/.ssh/authorized_keys
    echo "Done"
fi

if [ ! -d /bibos-archive ]; then
    echo "Creating /bibos-archive..."
    cp -r "$DIR/skel" "/bibos-archive"
    chown root:root /bibos-archive
    chmod og-w /bibos-archive
    echo "Done"
fi    

# Correct ssh config to chroot bibos-archive user
grep "ChrootDirectory /bibos-archive" /etc/ssh/sshd_config > /dev/null
if [ $? -ne 0 ]; then
    echo "Setting ssh chroot for bibos-archive..."
    TMPFILE=`mktemp /tmp/XXXXXXXXXXX.tmp`
    MATCH='Subsystem sftp \/usr\/lib\/openssh\/sftp-server'
    sed "s/${MATCH}/#${MATCH}/" /etc/ssh/sshd_config > $TMPFILE
    (cat <<EOT

### BibOS changes start ###
Subsystem sftp internal-sftp
Match User bibos-archive
    ChrootDirectory /bibos-archive
    ForceCommand internal-sftp
    X11Forwarding no
    AllowTCPForwarding no

### BibOS changes end ###

EOT

    ) >> $TMPFILE
    cat $TMPFILE > /etc/ssh/sshd_config
    rm $TMPFILE
    service ssh restart
    echo "Done"
fi

if [ ! -d /usr/share/bibos/local_server ]; then
    cp -r "$DIR/daemon/" "/usr/share/bibos/local_server/"
fi

if [ ! -f /etc/init.d/bibos-broadcast-server ]; then
    cp $DIR/etc/init.d/bibos-broadcast-server /etc/init.d/
    update-rc.d bibos-broadcast-server defaults 98 02
fi

# Install apache if it's not installed
if [ ! -f /usr/sbin/apache2 ]; then
    apt-get -y install apache2
fi

RESTART_APACHE="no"

for mod in proxy_connect proxy_http proxy_ftp disk_cache; do
    if [ ! -e "/etc/apache2/mods-enabled/${mod}.load" ]; then
        a2enmod "$mod"
        RESTART_APACHE="yes"
    fi
done

if [ ! -f /etc/apache2/conf.d/bibos-proxy.conf ]; then
    # Find proxy network and netmask
    IP=`/sbin/ifconfig eth0 | grep "inet addr:" | sed 's/.*addr:\([0-9.]\+\).*/\1/'`
    NETMASK=`/sbin/ifconfig eth0 | grep "inet addr:" | sed 's/.*Mask:\([0-9.]\+\).*/\1/'`
    IP_ARR=""
    IFS='.' read -ra IP_ARR <<< "$IP"
    SN_ARR=""
    IFS='.' read -ra SN_ARR <<< "$NETMASK"
    NETWORK="$((${IP_ARR[0]} & ${SN_ARR[0]}))"
    NETWORK="${NETWORK}.$((${IP_ARR[1]} & ${SN_ARR[1]}))"
    NETWORK="${NETWORK}.$((${IP_ARR[2]} & ${SN_ARR[2]}))"
    NETWORK="${NETWORK}.$((${IP_ARR[3]} & ${SN_ARR[3]}))"
    
    CONF_NETWORK=`get_bibos_config proxy_network 2>/dev/null`
    if [ "$CONF_NETWORK" != "" ]; then
        NETWORK="$CONF_NETWORK"
    else
        set_bibos_config proxy_network "$NETWORK"
    fi
    CONF_NETMASK=`get_bibos_config proxy_netmask 2>/dev/null`
    if [ "$CONF_NETMASK" != "" ]; then
        NETMASK="$CONF_NETMASK"
    else
        set_bibos_config proxy_netmask "$NETMASK"
    fi

    # Copy default configuration
    cp "$DIR/etc/apache2/conf.d/bibos-proxy.conf" \
        /etc/apache2/conf.d/bibos-proxy.conf

    # Add allowed hosts
    for host in \
        "http://*.ubuntu.com/ubuntu/*" \
        "http://pypi.python.org/*" \
        "http://dk.archive.ubuntu.com/*" \
        "http://bibos-admin.magenta-aps.dk/*" \
        "http://bibos.web06.magenta-aps.dk/*" \
    ; do
        cat >> /etc/apache2/conf.d/bibos-proxy.conf <<EOT
<Proxy ${host}>
    Order deny,allow
    Deny from all
    Allow from ${NETWORK}/${NETMASK}
</Proxy>

EOT
    RESTART_APACHE="yes"
    done
fi

if [ "$RESTART_APACHE" == "yes" ]; then
    /etc/init.d/apache2 restart
fi
