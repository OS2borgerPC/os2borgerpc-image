#!/bin/bash

DIR=$1; shift

if [ "$DIR" == "" ]; then
    echo "No directory specified"
    exit 1;
fi

DIR=${DIR%/}

CD_DIR="${DIR}/cd-unified"
TEST_FILE="${CD_DIR}/Clonezilla-Live-Version"

if [ ! -d "$CD_DIR" -o ! -f "$TEST_FILE" ]; then
    echo "No directory $CD_DIR or $CD_DIR not a clonezilla/bibos CD."
    exit 1;
fi

set -e

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
