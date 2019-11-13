#!/bin/bash
DIRNAME=$( dirname "${BASH_SOURCE[0]}" )
DIR="$( cd "$DIRNAME" && pwd )"

WHO=`whoami`
if [ "$WHO" != "root" ]; then
    echo "You must run this script as root"
    exit 1;
fi

INSTALL_PACKAGES=""

for pkg in openssh-server apache2 squid-deb-proxy sshfs; do
    dpkg -l "$pkg"  2>&1 | grep '^ii' > /dev/null
    if [ $? -ne 0 ]; then
        INSTALL_PACKAGES="${INSTALL_PACKAGES} $pkg"
    fi
done

# Install apache if it's not installed
if [ "$INSTALL_PACKAGES" != "" ]; then
    apt-get -y install $INSTALL_PACKAGES
fi

# Create os2borgerpc-archive user if it doesn't exist
grep "^os2borgerpc-archive:" /etc/passwd > /dev/null
if [ $? -ne 0 ]; then
    echo "Creating os2borgerpc-archive user..."
    useradd -d /home/os2borgerpc-archive -m -s /bin/false -u 901 os2borgerpc-archive
    echo "Done"

    # Set up ssh stuff
    echo "Setting up sshkey for os2borgerpc-archive user..."
    if [ ! -d ~os2borgerpc-archive/.ssh ]; then
        mkdir -m 0700 ~os2borgerpc-archive/.ssh
        chown os2borgerpc-archive.os2borgerpc-archive ~os2borgerpc-archive/.ssh
    fi
    if [ ! -f ~os2borgerpc-archive/.ssh/authorized_keys ]; then
        touch ~os2borgerpc-archive/.ssh/authorized_keys
        chown os2borgerpc-archive.os2borgerpc-archive ~os2borgerpc-archive/.ssh/authorized_keys
        chmod 0600 ~os2borgerpc-archive/.ssh/authorized_keys
    fi

    cat ${DIR}/ssh/os2borgerpc-key.pub >> \
        ~os2borgerpc-archive/.ssh/authorized_keys
    echo "Done"
fi

if [ ! -d /os2borgerpc-archive ]; then
    echo "Creating /os2borgerpc-archive..."
    cp -r "$DIR/skel" "/os2borgerpc-archive"
    chown root:root /os2borgerpc-archive
    chmod og-w /os2borgerpc-archive
    echo "Done"
fi    

# Correct ssh config to chroot os2borgerpc-archive user
grep "ChrootDirectory /os2borgerpc-archive" /etc/ssh/sshd_config > /dev/null
if [ $? -ne 0 ]; then
    echo "Setting ssh chroot for os2borgerpc-archive..."
    TMPFILE=`mktemp /tmp/XXXXXXXXXXX.tmp`
    MATCH='Subsystem sftp \/usr\/lib\/openssh\/sftp-server'
    sed "s/${MATCH}/#${MATCH}/" /etc/ssh/sshd_config > $TMPFILE
    (cat <<EOT

### OS2borgerPC changes start ###
Subsystem sftp internal-sftp
Match User os2borgerpc-archive
    ChrootDirectory /os2borgerpc-archive
    ForceCommand internal-sftp
    X11Forwarding no
    AllowTCPForwarding no

### OS2borgerPC changes end ###

EOT

    ) >> $TMPFILE
    cat $TMPFILE > /etc/ssh/sshd_config
    rm $TMPFILE
    service ssh restart
    echo "Done"
fi

if [ ! -f /etc/init.d/os2borgerpc-broadcast-server ]; then
    cp $DIR/etc/init.d/os2borgerpc-broadcast-server /etc/init.d/
    update-rc.d os2borgerpc-broadcast-server defaults 98 02
fi

# Overwrite squid configuration:
python "$DIR/update_proxy_config.py"

# Don't run the normal squid (it's an open proxy)
grep "manual" /etc/init/squid3.override > /dev/null 2>&1 || \
    echo "manual" >> /etc/init/squid3.override
status squid3 | grep running && stop squid3

ADMIN_URL=$(get_os2borgerpc_config admin_url)
BIBOS_SITE=$(get_os2borgerpc_config site)
SHARED_CONFIGURATION=/var/www/os2borgerpc.conf

set_os2borgerpc_config admin_url "$ADMIN_URL" "$SHARED_CONFIGURATION"
set_os2borgerpc_config site "$BIBOS_SITE" "$SHARED_CONFIGURATION"

# Fix ssh permissions
chmod -R og-rw /usr/share/os2borgerpc/gateway/ssh/

echo "Do you want to synchronize the image/iso archive now? (J/n)?"
read a;
if [ "$a" == "y" -o "$a" == "j" -o "$a" == "" ]; then
    /usr/share/os2borgerpc/gateway/rsync_archive.sh
else
    echo "You can synchronize later by running the /usr/share/os2borgerpc/gateway/rsync_archive.sh script as root"
fi

# Start the broadcast server
etc/init.d/os2borgerpc-broadcast-server start

echo "Installation of gateway done"
