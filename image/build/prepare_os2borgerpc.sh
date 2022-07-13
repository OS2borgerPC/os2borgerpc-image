#!/bin/bash

set -x

printf "\n\n%s\n\n" "===== RUNNING: $0 (INSIDE SQUASHFS) ====="

MOUNT=$1

# You have entered the squashed system as root.
export DEBIAN_FRONTEND=noninteractive

# Step 1: Check for valid APT repositories.
apt-get update &> /dev/null
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
    echo "" 1>&2
    echo "ERROR: Apt repositories are not valid or cannot be reached from your network." 1>&2
    echo "Please fix and retry" 1>&2
    echo "" 1>&2
    exit 1
else
    echo "Repositories OK"
fi

echo "Removing packages we don't need, before we upgrade all packages:"
# Things to get rid of. Factor out to file if many turn up.
# deja-dup because...?
# libfprint-2-2 because it fails during installation/updating because of an unmet interactive step, but we don't need finger print reading anyway so we can delete it
# gnome-todo, thunderbird and transmission because they likely aren't needed by users
apt-get -y remove --purge deja-dup libfprint-2-2 gnome-todo thunderbird transmission-gtk

echo "Now upgrading all packages"
apt-get -y upgrade | tee /tmp/os2borgerpc_upgrade_log.txt
apt-get -y dist-upgrade | tee /tmp/os2borgerpc_upgrade_log.txt

# Get code for OS2borgerPC
if [ ! "$MOUNT" ];
then
    # Ignore error about zsys daemon
    apt-get -y install git

    git clone https://github.com/OS2borgerPC/image /mnt/
    cd /mnt/
    git checkout development
fi


# Run customization, from the image/image directory which is bind-mounted in
/mnt/image/scripts/os2borgerpc_setup.sh
/mnt/image/scripts/finalize.sh
