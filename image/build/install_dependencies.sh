#!/bin/bash

printf "\n\n%s\n\n" "===== RUNNING: $0 ====="

# Find current directory

export DEBIAN_FRONTEND=noninteractive
DEPENDENCIES=( squashfs-tools genisoimage p7zip-full xorriso figlet )

PKGSTOINSTALL=""

dpkg -l | grep "^ii" > /tmp/build_installed_packages_list.txt

for  package in "${DEPENDENCIES[@]}"
do
    grep -w "ii  $package " /tmp/build_installed_packages_list.txt > /dev/null
    if [[ $? -ne 0 ]]; then
        PKGSTOINSTALL=$PKGSTOINSTALL" "$package
    fi
done

if [ "$PKGSTOINSTALL" != "" ]; then
    echo  -n "Some build dependencies are missing on the host system."
    echo " The following packages will be installed: $PKGSTOINSTALL"
    sudo apt-get update > /dev/null
    sudo apt-get -y install $PKGSTOINSTALL
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then
        echo "" 1>&2
        echo "ERROR: Installation of dependencies failed." 1>&2
        echo "Please note that \"universe\" repository MUST be enabled" 1>&2
        echo "" 1>&2
        exit 1
    fi
fi
