#!/bin/bash

mkdir /home/partimag/
sudo mount --bind /live/image/bibos-images /home/partimag/

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

IMAGE=`sudo /usr/bin/perl /live/image/bibos/select_image.pl`;
if [ $? -ne 0 ]; then
    echo "No image selected, exiting";
    exit 1;
fi

sudo /usr/bin/perl /live/image/bibos/clone_image.pl $DEV $IMAGE

sudo /usr/bin/perl /live/image/bibos/fix_swap.pl $DEV

sudo reboot
