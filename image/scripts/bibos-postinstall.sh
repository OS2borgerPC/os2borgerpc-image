#!/usr/bin/env bash

# This file will finalize the BibOS installation by installing the things which
# could not be preinstalled on the BibOS image. 
# This includes:
#
# * Registration to admin system.
# 
# This script REQUIRES AN INTERNET CONNECTION!

# Get proxy-environment if needed
source /usr/share/bibos/env/proxy.sh

# Proprietary stuff 

# 1. Upgrade system

dpkg-reconfigure grub-pc

if [[  $? -eq 0 ]]
then 
    apt-get -y update
    apt-get -y upgrade
    apt-get -y dist-upgrade
    apt-get -y autoremove
    apt-get -y clean
fi 

# 2. Register in admin system

    register_new_bibos_client.sh

if [[ -f /etc/lightdm/lightdm.conf.bibos ]]
then
    # Modify /etc/lightdm/lightdm.conf to avoid automatic user login
    mv /etc/lightdm/lightdm.conf.bibos /etc/lightdm/lightdm.conf
fi

if [[ -f /etc/bibos/firstboot ]]
then
    # Add bibos started requirement to lightdm upstart script
    # TODO-CA: What is this? 
    grep "and started bibos" /etc/init/lightdm.conf > /dev/null
    if [ $? -ne 0 ]; then
        cat /etc/init/lightdm.conf | \
            perl -ne 's/and started dbus/and started dbus\n           and started bibos/;print' \
            > /tmp/lightdm.conf.tmp
        mv /tmp/lightdm.conf.tmp /etc/init/lightdm.conf
    fi
    rm /etc/bibos/firstboot
else
    echo "Dette er ikke en nyinstalleret BIBOS-maskine - opstarten ændres ikke.\n Lav en 'touch /etc/bibos/firstboot' og kør scriptet igen, hvis dette er en fejl."
fi

echo "Installationen er afsluttet."
    

