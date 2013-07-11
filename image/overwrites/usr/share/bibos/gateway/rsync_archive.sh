#!/bin/bash

if [ "`whoami`" != "root" ]; then
    echo "This script should be run as root"
    exit 1
fi

ARCHIVE_HOST=`get_bibos_config archive_hostname 2>/dev/null`
if [ "${ARCHIVE_HOST}" == "" ]; then
    ARCHIVE_HOST="bibos-admin.magenta-aps.dk"
fi

mkdir /tmp/archive-mnt

sshfs ${ARCHIVE_HOST}:/archive/ /tmp/archive-mnt \
    -F /usr/share/bibos/gateway/ssh/config -o uid=0 -o gid=0

rsync --ignore-existing -va /tmp/archive-mnt/iso/ /bibos-archive/archive/iso/

for iso in /bibos-archive/archive/iso/*.iso; do
    TARGETDIR=`basename "$iso"`
    TARGETDIR=${TARGETDIR%.iso}
    TARGETDIR="/bibos-archive/archive/hd/${TARGETDIR}"

    if [ ! -e "$TARGETDIR" ]; then
        echo "Unpacking $iso"
	/usr/share/bibos/gateway/import_hd_from_iso.sh "$iso"
    fi
done

rsync --ignore-existing -va /tmp/archive-mnt/hd/ /bibos-archive/archive/hd/

umount /tmp/archive-mnt
rmdir /tmp/archive-mnt

# Ensure everybody can ready everything
chmod -R +r /bibos-archive/archive/
