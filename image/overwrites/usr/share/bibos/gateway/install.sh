#!/bin/bash
DIRNAME=$( dirname "${BASH_SOURCE[0]}" )
DIR="$( cd "$DIRNAME" && pwd )"

WHO=`whoami`
if [ "$WHO" != "root" ]; then
    echo "You must run this script as root"
    exit 1;
fi

INSTALL_PACKAGES=""

for pkg in openssh-server apache2 squid-deb-proxy; do
    dpkg -l "$pkg"  2>&1 | grep '^ii' > /dev/null
    if [ $? -ne 0 ]; then
        INSTALL_PACKAGES="${INSTALL_PACKAGES} $pkg"
    fi
done

# Install apache if it's not installed
if [ "$INSTALL_PACKAGES" != "" ]; then
    apt-get -y install $INSTALL_PACKAGES
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

if [ ! -f /etc/init.d/bibos-broadcast-server ]; then
    cp $DIR/etc/init.d/bibos-broadcast-server /etc/init.d/
    update-rc.d bibos-broadcast-server defaults 98 02
fi

# Overwrite squid configuration:
cp -r $DIR/etc/squid-deb-proxy/ /etc/squid-deb-proxy/
service squid-deb-proxy restart

# Don't run the normal squid (it's an open proxy)
grep "manual" /etc/init/squid3.override > /dev/null 2>&1 || \
    echo "manual" >> /etc/init/squid3.override
status squid3 | grep running && stop squid3

ADMIN_URL=$(get_bibos_config admin_url)
BIBOS_SITE=$(get_bibos_config site)
SHARED_CONFIGURATION=/var/www/bibos.conf

set_bibos_config admin_url "$ADMIN_URL" "$SHARED_CONFIGURATION"
set_bibos_config site "$BIBOS_SITE" "$SHARED_CONFIGURATION"
