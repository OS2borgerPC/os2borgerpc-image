#!/usr/bin/env bash

# Copy desktop file to /etc/xdg/autostart
sudo cp bibos-postinstall.desktop /etc/xdg/autostart
# Copy finalize script to /usr/share/bibos/bin
sudo cp bibos-postinstall.sh /usr/share/bibos/bin
# Modify /etc/lightdm/lightdm.conf to avoid automatic user login
sudo cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.backup
sudo sed -i "s/autologin-user=user/autologin-user=$USER/" /etc/lightdm/lightdm.conf
# The PostInstall script should clean up, i.e. reverse all these changes.

