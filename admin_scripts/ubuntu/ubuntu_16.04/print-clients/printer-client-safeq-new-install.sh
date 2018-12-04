#!/usr/bin/env bash


if [ $# -ne 2 ]
then
    echo "This script needs two parameters"
    exit -1
fi

pkg_ysoft=$1
pkg_libcrafter=$2

# Install the new safeq client
dpkg -i $pkg_ysoft
dpkg -i $pkg_libcrafter
apt-get -fy install
dpkg -i $pkg_ysoft

# There is a segmentation fault in the if-up-script
# As a workaround we remove it (only needed for dynamic ip's)
rm -fv /etc/network/if-up.d/safeq-client-dhcp-sync
