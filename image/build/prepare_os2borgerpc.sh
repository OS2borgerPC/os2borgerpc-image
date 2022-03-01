#!/bin/bash

printf "\n\n%s\n\n" "===== RUNNING: $0 ====="

# You have entered the squashed system as root.
export DEBIAN_FRONTEND=noninteractive

apt-get -y update
apt-get -y upgrade
# Ignore error about zsys daemon
apt-get -y install git

# Get code for OS2borgerPC
# NOTE: If testing changes to os2borgerpc_setup.sh or finalize.sh or something they call:
# Fork the project, push your changes to a branch and git checkout to it below
git clone https://github.com/OS2borgerPC/image
cd image
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
