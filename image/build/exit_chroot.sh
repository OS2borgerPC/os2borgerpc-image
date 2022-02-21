#!/bin/bash

apt clean
rm -rf ~/.bash_history

sudo umount -v "/dev/pts/"
sudo umount -v "/sys"
sudo umount -v "/proc"
sudo umount -v "/dev"

exit
if [ -f "$DIR/etc/resolv.conf.chrooted" ]; then
    sudo mv "$DIR/etc/resolv.conf.chrooted" "$DIR/etc/resolv.conf"
fi


