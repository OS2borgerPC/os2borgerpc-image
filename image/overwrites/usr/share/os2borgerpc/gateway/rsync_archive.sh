#!/bin/bash

if [ "`whoami`" != "root" ]; then
    echo "This script should be run as root"
    exit 1
fi

ARCHIVE_HOST=`get_os2borgerpc_config archive_hostname 2>/dev/null`
if [ "${ARCHIVE_HOST}" == "" ]; then
    ARCHIVE_HOST="os2borgerpc.magenta-aps.dk"
fi

mkdir /tmp/archive-mnt

sshfs ${ARCHIVE_HOST}:/archive/ /tmp/archive-mnt \
    -F /usr/share/os2borgerpc/gateway/ssh/config -o uid=0 -o gid=0

rsync --ignore-existing -va /tmp/archive-mnt/iso/ /os2borgerpc-archive/archive/iso/

for iso in /os2borgerpc-archive/archive/iso/*.iso; do
    TARGETDIR=`basename "$iso"`
    TARGETDIR=${TARGETDIR%.iso}
    TARGETDIR="/os2borgerpc-archive/archive/hd/${TARGETDIR}"

    if [ ! -e "$TARGETDIR" ]; then
        echo "Unpacking $iso"
	/usr/share/os2borgerpc/gateway/import_hd_from_iso.sh "$iso"
    fi
done

rsync --ignore-existing -va /tmp/archive-mnt/hd/ /os2borgerpc-archive/archive/hd/

umount /tmp/archive-mnt
rmdir /tmp/archive-mnt

# Ensure everybody can ready everything
chmod -R +r /os2borgerpc-archive/archive/
