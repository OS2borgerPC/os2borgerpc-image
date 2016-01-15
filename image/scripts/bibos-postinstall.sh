!/usr/bin/env bash

# This file will finalize the BibOS installation by installing the things which
# could not be preinstalled on the BibOS image. 
# This includes:
#
# * Printer and other hardware setup
# * Proprietary packages which we're not allowed to distribute
# * Registration to admin system.
# 
# This script REQUIRES AN INTERNET CONNECTION!

# Get proxy-environment if needed
source /usr/share/bibos/env/proxy.sh


# Proprietary stuff

# Ensure Internet connection 

zenity --info --text="Du har brug for en forbindelse til Internettet for at fortsætte"      

# 1. Codecs, Adobe Flash, etc.

zenity --question  --text="Installér Adobe Flash og Microsoft fonts?"

if [[  $? -eq 0 ]]
then 
    # User pressed "Yes"
    apt-get update
    apt-get -y install ubuntu-restricted-extras 
fi

# 4. Upgrade system

zenity --info --text="Systemet vil nu opdatere opstartsprogrammet."

dpkg-reconfigure grub-pc

zenity --question --text="Ønsker du at opgradere systemet og installere de nyeste sikkerhedsopdateringer?"

if [[  $? -eq 0 ]]
then 
    apt-get -y update
    apt-get -y upgrade
    apt-get -y dist-upgrade
    apt-get -y autoremove
    apt-get -y clean
fi 

# 5. Register in admin system

zenity --question  --text="Tilslut admin-systemet?"

if [[  $? -eq 0 ]]
then 
    # User pressed "Yes"
    register_new_bibos_client.sh
else
    zenity --info --text="Kør 'register_new_bibos_client.sh' hvis du vil tilslutte senere"
fi

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
    zenity --warning --text="Dette er ikke en nyinstalleret BIBOS-maskine - opstarten ændres ikke.\n Lav en 'touch /etc/bibos/firstboot' og kør scriptet igen, hvis dette er en fejl."
fi


zenity --info --text="Installationen er afsluttet."
    
# Delete desktop file

DESKTOP_FILE=/home/superuser/Skrivebord/bibos-postinstall.desktop
if [[ -f $DESKTOP_FILE ]]
then
    rm $DESKTOP_FILE
fi
