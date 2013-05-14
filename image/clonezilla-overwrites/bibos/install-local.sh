#!/bin/bash

mkdir /home/partimag/bibos
sudo mount --bind /live/image/bibos-image /home/partimag/bibos

DEV=`sudo /usr/bin/perl /live/image/bibos/find_disk.pl`
if [ "" == "$DEV" ]; then
    echo "Could not find a device, exiting";
    exit 1;
fi

SWAPSIZE=`sudo /usr/bin/perl /live/image/bibos/get_swap_size.pl`
if [ "" == "$SWAPSIZE" ]; then
    echo "Could not find swap size, exiting";
    exit 1;
fi


sudo /usr/bin/perl /live/image/bibos/partition_disk.pl $DEV $SWAPSIZE
if [ $? -ne 0 ]; then
    echo "Partitioning failed, exiting";
    exit 1;
fi

sudo /usr/bin/perl /live/image/bibos/clone_image.pl $DEV

sudo reboot
