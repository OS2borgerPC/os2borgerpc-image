#!/bin/bash

 set -x

printf "\n\n%s\n\n" "===== RUNNING: $0 ====="

DIR=$1
COMMAND=$2

echo $COMMAND
if [ "$DIR" == "" ]; then
    echo "No directory specified"
    exit 1;
fi

DIR=${DIR%/}

if [ ! -d "$DIR" ]; then
    echo "$DIR does not exist or is not a directory"
    exit 1
fi

# Set up resolv.conf
sudo cp /etc/resolv.conf squashfs-root/run/systemd/resolve/stub-resolv.conf
# Mounting in our own tmp into the chroot so we retain access to the log files written from within it
sudo mount --bind /tmp squashfs-root/tmp

echo "Chroot'ing into what will be the filesystem on the OS2BorgerPC"
if [ -z $COMMAND ]
then
    sudo chroot "$DIR"
else
    EXE=$(basename $COMMAND)
    sudo cp $COMMAND $DIR
    sudo chmod +x $DIR/$EXE
    sudo chroot "$DIR" /"$EXE"
fi
