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

# echo "Setting up resolv.conf"
sudo cp /etc/resolv.conf squashfs-root/run/systemd/resolve/stub-resolv.conf

echo "Mounting device filesystems"
sudo mount -v -t proc none "$DIR/proc"
sudo mount -v -t sysfs none "$DIR/sys"
sudo mount -v -t devpts none "$DIR/dev/pts/"
sudo mount --bind /dev/ "$DIR/dev"

echo "Chroot'ing"
sudo chroot "$DIR"

sudo umount -v "$DIR/dev/pts/"
sudo umount -v "$DIR/dev"
sudo umount -v "$DIR/sys"
sudo umount -v "$DIR/proc"
