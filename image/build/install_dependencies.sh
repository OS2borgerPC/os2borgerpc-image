#!/bin/bash

# Find current directory

export DEBIAN_FRONTEND=noninteractive
DEPENDENCIES=( squashfs-tools genisoimage p7zip-full xorriso isolinux )

PKGSTOINSTALL=""

dpkg -l | grep "^ii" > /tmp/installed-package-list.txt

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
    sudo apt-get update > /dev/null 
    sudo apt-get -y install $PKGSTOINSTALL 
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then
        echo "" 1>&2
        echo "ERROR: Installation of dependencies failed." 1>&2
        echo "Please note that \"universe\" repository MUST be enabled" 1>&2
        echo "" 1>&2
        exit -1
    fi

fi
