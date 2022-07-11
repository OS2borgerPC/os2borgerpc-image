#!/bin/bash

set -x

printf "\n\n%s\n\n" "===== RUNNING: $0 (INSIDE SQUASHFS) ====="

# You have entered the squashed system as root.
export DEBIAN_FRONTEND=noninteractive

apt-get -y update

echo "Removing packages we don't need, before we upgrade all packages:"
# Things to get rid of. Factor out to file if many turn up.
# deja-dup because...?
# libfprint-2-2 because it fails during installation/updating because of an unmet interactive step, but we don't need finger print reading anyway so we can delete it
# gnome-todo, thunderbird and transmission because they likely aren't needed by users
apt-get -y remove --purge deja-dup libfprint-2-2 gnome-todo thunderbird transmission-gtk

echo "Now upgrading all packages:"
apt-get -y upgrade
# Ignore error about zsys daemon
apt-get -y install git

# Get code for OS2borgerPC
# NOTE: If testing changes to os2borgerpc_setup.sh, finalize.sh or something they call:
# Fork the project, push your changes to a branch and git checkout to it below
#git clone https://github.com/OS2borgerPC/image
git clone https://github.com/magenta-mfm/image

cd image
git checkout feature/48843_add_missing_language_support_packages

# Run customization.

image/scripts/os2borgerpc_setup.sh > /dev/null
image/scripts/finalize.sh

# Cleanup

apt-get -y autoremove --purge
apt-get -y clean
cd ..
rm -rf image/
