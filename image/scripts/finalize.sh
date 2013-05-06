#!/usr/bin/env bash

# This file will finalize the BibOS installation by installing the things which
# could not be preinstalled on the BibOS image. 
# This includes:
#
# * Printer and other hardware setup
# * Proprietary packages which we're not allowed to distribute
# * Registration to admin system.
# 
# This script REQUIRES AN INTERNET CONNECTION!

# The script should be run as a sudo-enabled user - not directly as root.


# Printer setup
#sudo system-config-printer


# Proprietary stuff


# 1. Codecs, Adobe Flash, etc.

zenity --question  --text="Installér codecs og proprietære udvidelser, bl.a.  Microsoft fonts?"

if [[  $? -eq 0 ]]
then 
    # User pressed "Yes"
    sudo apt-get install ubuntu-restricted-extras | \
        tee >(zenity --progress --pulsate)  > /tmp/install_log.txt


else
    zenity --info --text=" Mange film- og lydfiler vil ikke virke ordentligt uden denne udvidelse.
    Skriv selv 

        sudo apt-get install ubuntu-restricted-extras 

    i en terminal for at installere på et senere tidspunkt."
    
fi


# 2. Evil, despicable Microsofty Skype

zenity --question --text="Installér Skype?"

if [[ $? -eq 0 ]]
then
     sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
     sudo apt-get update  | zenity --progress --pulsate --text="Opdaterer pakker ..."
     sudo apt-get install skype  | zenity --progress --pulsate --text="Installerer Skype."
fi
