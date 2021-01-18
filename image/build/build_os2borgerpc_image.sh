#!/bin/bash

DIR=$1; shift

if [ "$DIR" == "" ]; then
    echo "No directory specified"
    exit 1;
fi

DIR=${DIR%/}

CD_DIR="${DIR}/cd-unified"
FS_IMG="${DIR}/hd_loopback_image.img"
TEST_FILE="${CD_DIR}/Clonezilla-Live-Version"

if [ ! -d "$CD_DIR" -o ! -f "$TEST_FILE" ]; then
    echo "No directory $CD_DIR or $CD_DIR not a clonezilla/os2borgerpc CD."
    exit 1;
fi

FS_DIR="${DIR}/filesystem"
TEST_DIR="${FS_DIR}/home/.skjult"

if [ ! -d "$FS_DIR" -o ! -d "$TEST_DIR" ]; then
    echo "No directory $FS_DIR or $FS_DIR not a os2borgerpc filesystem."
    exit 1;
fi

set -e

echo "Compressing filesystem"
partclone.ext4 -c -s "${FS_IMG}" -O - | gzip > \
    "${CD_DIR}/os2borgerpc-image/sda1.ext4-ptcl-img.gz.aa"

ISOFILE=$(mktemp -u "${DIR}/image-XXXXXXXXXX.iso")

echo "Creating ISO image $ISOFILE"
genisoimage \
    -V "BibOS install image" \
    -r -cache-inodes -J -l \
    -b isolinux/isolinux.bin \
    -c isolinux/boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -o "${ISOFILE}" \
    "$CD_DIR"

echo "ISO image $ISOFILE created"
