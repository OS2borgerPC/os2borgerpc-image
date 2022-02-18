#!/bin/bash

DIR=$1; shift

if [ "$DIR" == "" ]; then
    echo "No directory specified"
    exit 1;
fi

DIR=${DIR%/}

if [ ! -d "DIR" ]; then
    echo "$DIR does not exist"
    exit 1
fi

echo "Mounting device filesystems"
sudo mount -v -t proc proc "$DIR/proc"
sudo mount -v -t sysfs sys "$DIR/sys"
sudo mount -v -o bind /dev "$DIR/dev"
sudo mount -v -t devpts pts "$DIR/dev/pts/"
echo "Setting up resolv.conf"
sudo mv "$DIR/etc/resolv.conf" "$DIR/etc/resolv.conf.chrooted"
sudo cp /etc/resolv.conf "$DIR/etc/resolv.conf"
echo "Chroot'ing"
sudo chroot "$DIR"

sudo umount -v "$DIR/dev/pts/"
sudo umount -v "$DIR/dev"
sudo umount -v "$DIR/sys"
sudo umount -v "$DIR/proc"
if [ -f "$DIR/etc/resolv.conf.chrooted" ]; then
    sudo mv "$DIR/etc/resolv.conf.chrooted" "$DIR/etc/resolv.conf"
fi
