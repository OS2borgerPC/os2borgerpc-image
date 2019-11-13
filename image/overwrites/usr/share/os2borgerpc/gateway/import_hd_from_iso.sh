#!/bin/bash

HDIMAGEDIR="/os2borgerpc-archive/archive/hd"

if [ "$1" == "" -o ! -f "$1" ]; then
    echo "You must specify an iso file"
    exit 1
fi



TARGETDIR=`basename "$1"`
TARGETDIR=${TARGETDIR%.iso}
TARGETDIR="${HDIMAGEDIR}/${TARGETDIR}"


if [ -e "$TARGETDIR" ]; then
    echo "$TARGETDIR already exists"
    exit 1
fi

# Exit on any error
set -e

TMPDIR=`mktemp -d "/tmp/os2borgerpc-hd-image-import.XXXXXXXXXX"`

mkdir "$TARGETDIR"

sudo mount -t iso9660 -o loop,ro "$1" "$TMPDIR"
cp $TMPDIR/os2borgerpc-images/os2borgerpc_default/* "${TARGETDIR}/"
sudo umount "$TMPDIR"

echo "Image from $1 copied to $TARGETDIR"

