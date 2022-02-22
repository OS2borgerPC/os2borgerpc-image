#!/bin/bash

# You have entered the squashed system as root.

apt update
apt upgrade
# Ignore error about zsys daemon
apt install git

# Get code for OS2borgerPC

git clone  https://github.com/OS2borgerPC/image/
cd image
# TODO: Delete after merge
git checkout 48683_kill_clonezilla

# Run customization.

image/scripts/os2borgerpc_setup.sh
image/scripts/finalize.sh

# Cleanup

apt autoremove
apt clean
cd ..
rm -rf image/
rm /tmp/*


