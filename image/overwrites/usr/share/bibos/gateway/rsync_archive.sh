#!/bin/bash

if [ "`whoami`" != "root" ]; then
    echo "This script should be run as root"
    exit 1
fi

ARCHIVE_HOST=`get_bibos_config archive_hostname 2>/dev/null`
if [ "${ARCHIVE_HOST}" == "" ]; then
    ARCHIVE_HOST="bibos.web06.magenta-aps.dk"
fi

mkdir /tmp/archive-mnt

sshfs ${ARCHIVE_HOST}:/archive/ /tmp/archive-mnt \
    -F /usr/share/bibos/gateway/ssh/config -o uid=0 -o gid=0

rsync -va /tmp/archive-mnt/ /archive/

umount /tmp/archive-mnt
rmdir /tmp/archive-mnt

