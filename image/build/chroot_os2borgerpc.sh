#!/bin/bash

DIR=$1; shift

if [ "$DIR" == "" ]; then
    echo "No directory specified"
    exit 1;
fi

DIR=${DIR%/}

FS_DIR="${DIR}/filesystem"

if [ ! -d "$FS_DIR" ]; then
    echo "$DIR does not exist or does not seem to be a BibOS image"
    exit 1
fi

echo "Mounting device filesystems"
sudo mount -v -t proc proc "$FS_DIR/proc"
sudo mount -v -t sysfs sys "$FS_DIR/sys"
sudo mount -v -o bind /dev "$FS_DIR/dev"
sudo mount -v -t devpts pts "$FS_DIR/dev/pts/"
echo "Setting up resolv.conf"
sudo cp "$FS_DIR/etc/resolv.conf" "$FS_DIR/etc/resolv.conf.chrooted"
sudo cp /etc/resolv.conf "$FS_DIR/etc/resolv.conf"
echo "Chroot'ing"
sudo chroot "$FS_DIR"

sudo umount -v "$FS_DIR/dev/pts/"
sudo umount -v "$FS_DIR/dev"
sudo umount -v "$FS_DIR/sys"
sudo umount -v "$FS_DIR/proc"
if [ -f "$FS_DIR/etc/resolv.conf.chrooted" ]; then
    sudo mv "$FS_DIR/etc/resolv.conf.chrooted" "$FS_DIR/etc/resolv.conf"
fi
