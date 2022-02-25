#!/bin/bash

# You have entered the squashed system as root.
export DEBIAN_FRONTEND=noninteractive

apt-get -y update
apt-get -y upgrade
# Ignore error about zsys daemon
apt-get -y install git

# Get code for OS2borgerPC

git clone  https://github.com/OS2borgerPC/image/
cd image

# TODO: Delete after merge to master
git checkout development

# Run customization.

image/scripts/os2borgerpc_setup.sh > /dev/null
image/scripts/finalize.sh

# Cleanup

apt-get -y autoremove
apt-get -y clean
cd ..
rm -rf image/
rm /tmp/*


