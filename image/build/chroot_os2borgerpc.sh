#!/bin/bash

DIR=$1; shift

if [ "$DIR" == "" ]; then
    echo "No directory specified"
    exit 1;
fi

DIR=${DIR%/}

if [ ! -d "$DIR" ]; then
    echo "$DIR does not exist"
    exit 1
fi

echo "Setting up resolv.conf"
sudo mv "$DIR/etc/resolv.conf" "$DIR/etc/resolv.conf.chrooted"
sudo cp /etc/resolv.conf "$DIR/etc/resolv.conf"

echo "Mounting device filesystems"
sudo mount --bind /dev/ "$DIR/dev"

echo "Chroot'ing"
sudo chroot "$DIR"

echo "Mounting proc, sys and pts"
sudo mount -v -t proc proc "/proc"
sudo mount -v -t sysfs sys "/sys"
sudo mount -v -t devpts pts "/dev/pts/"

