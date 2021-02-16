#!/usr/bin/env bash

if [ $(which google-chrome) ]
then
    sed -i "s/firefox/google-chrome/" /etc/dconf/db/os2borgerpc.d/02-launcher-favorites
    dconf update
else 
    echo "Installér Google Chrome før du sætter ikonet i venstremenuen."
    exit 1
fi
