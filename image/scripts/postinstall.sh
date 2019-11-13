#!/usr/bin/env bash

# This file will finalize the OS2borgerPC installation by installing the things which
# could not be preinstalled on the OS2borgerPC image.
# This includes:
#
# * Printer and other hardware setup
# * Proprietary packages which we're not allowed to distribute
# * Registration to admin system.
# 
# This script REQUIRES AN INTERNET CONNECTION!

# Get proxy-environment if needed
source /usr/share/os2borgerpc/env/proxy.sh


USERNAME=''

for USER in $(users)
do
	if [[ $USER != 'user' ]]
	then
		USERNAME=$USER
	fi
done

# We need to have access to the X server in order for zenity dialogs to be shown.
export XAUTHORITY=/home/$USERNAME/.Xauthority
# Proprietary stuff

# Ensure Internet connection 

zenity --info --text="Du har brug for en forbindelse til Internettet for at fortsætte"      

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
    register_new_os2borgerpc_client.sh
else
    zenity --info --text="Kør 'register_new_os2borgerpc_client.sh' hvis du vil tilslutte senere"
fi

if [[ -f /etc/lightdm/lightdm.conf.os2borgerpc ]]
then
    # Modify /etc/lightdm/lightdm.conf to avoid automatic user login
    mv /etc/lightdm/lightdm.conf.os2borgerpc /etc/lightdm/lightdm.conf
fi

if [[ -f /etc/os2borgerpc/firstboot ]]
then
    # Add os2borgerpc started requirement to lightdm upstart script
    # TODO-CA: What is this? 
    grep "and started os2borgerpc" /etc/init/lightdm.conf > /dev/null
    if [ $? -ne 0 ]; then
        cat /etc/init/lightdm.conf | \
            perl -ne 's/and started dbus/and started dbus\n           and started os2borgerpc/;print' \
            > /tmp/lightdm.conf.tmp
        mv /tmp/lightdm.conf.tmp /etc/init/lightdm.conf
    fi
    rm /etc/os2borgerpc/firstboot
else
    zenity --warning --text="Dette er ikke en nyinstalleret OS2borgerPC-maskine - opstarten ændres ikke.\n Lav en 'touch /etc/os2borgerpc/firstboot' og kør scriptet igen, hvis dette er en fejl."
fi


zenity --info --text="Installationen er afsluttet."
    
# Delete desktop file

DESKTOP_FILE=/home/$USERNAME/Skrivebord/postinstall.desktop
if [[ -f $DESKTOP_FILE ]]
then
    rm $DESKTOP_FILE
fi
