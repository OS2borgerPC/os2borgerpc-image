#!/usr/bin/env bash

# This file will finalize the BibOS installation by installing the things which
# could not be preinstalled on the BibOS image. 
# This currently includes:
#
# * System upgrade.
# * Grub configuration (may be necessary for some disk configurations).
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

zenity --info --text="Installationen er afsluttet."
    
# Delete desktop file

DESKTOP_FILE=/home/$USERNAME/Skrivebord/os2borgerpc-postinstall.desktop
if [[ -f $DESKTOP_FILE ]]
then
    rm $DESKTOP_FILE
fi
