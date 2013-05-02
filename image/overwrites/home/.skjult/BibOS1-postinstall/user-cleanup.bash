#!/bin/bash

#this script cleans up the users home directory

USERNAME="EDITME"

rm -fr /tmp/* /tmp/.??*
rm -r /home/$USERNAME
cp -r /home/.skjult /home/$USERNAME
chown -r $USERNAME:$USERNAME /home/$USERNAME

