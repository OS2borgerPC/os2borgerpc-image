#!/bin/bash

# Find current directory

DIR=$(dirname ${BASH_SOURCE[0]})

# Install OS2bogerPC specific dependencies
#           
# The DEPENDENCIES file contains packages/programs
# required by OS2borgerPC AND extra packages which are free dependencies
# of Skype and MS Fonts - to shorten the postinstall process.
DEPENDENCIES=( $(cat "$DIR/DEPENDENCIES") )

PKGSTOINSTALL=""

dpkg -l | grep "^ii" > /tmp/installed-package-list.txt

grep -w "ii  deja-dup" /tmp/installed-package-list.txt > /dev/null
if [ $? -eq 0 ]; then
   # Things to get rid of. Factor out to file if many turn up.
   apt-get -y remove --purge deja-dup
fi

for  package in "${DEPENDENCIES[@]}"
do
    grep -w "ii  $package " /tmp/installed-package-list.txt > /dev/null
    if [[ $? -ne 0 ]]; then
        PKGSTOINSTALL=$PKGSTOINSTALL" "$package
    fi
done

if [ "$PKGSTOINSTALL" != "" ]; then
    echo  -n "Some dependencies are missing."
    echo " The following packages will be installed: $PKGSTOINSTALL" 
    
    # Step 1: Check for valid APT repositories.

    apt-get update &> /dev/null
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then
        echo "" 1>&2
        echo "ERROR: Apt repositories are not valid or cannot be reached from your network." 1>&2
        echo "Please fix and retry" 1>&2
        echo "" 1>&2
        exit -1
    else
        echo "Repositories OK: Installing packages"
    fi

    # Step 2: Do the actual installation. Abort if it fails.
    # and install
    apt-get -y install $PKGSTOINSTALL | tee /tmp/os2borgerpc_install_log.txt
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then
        echo "" 1>&2
        echo "ERROR: Installation of dependencies failed." 1>&2
        echo "Please note that \"universe\" repository MUST be enabled" 1>&2
        echo "" 1>&2
        exit -1
    fi

    # upgrade
    apt-get -y upgrade | tee /tmp/os2borgerpc_upgrade_log.txt
    apt-get -y dist-upgrade | tee /tmp/os2borgerpc_upgrade_log.txt

    # Clean .deb cache to save space
    apt-get -y autoremove
    apt-get -y clean
fi

# TODO: Find a more permanent way of handling this.
pip3 install http://bibos-admin.magenta-aps.dk/archive/client_packages/os2borgerpc_client-0.0.5.1.tar.gz

# Setup unattended upgrades
"$DIR/../../admin_scripts/image_core/apt_periodic_control.sh" security

# Install English language package
apt-get -y install language-pack-en language-pack-gnome-en
