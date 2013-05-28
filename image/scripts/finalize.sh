#!/usr/bin/env bash

if [ "$USER" == "root" ]; then
	echo "Please do not run this script as root, run it as the superuser instead."
	exit 1
fi

# Copy desktop file to /etc/xdg/autostart
sudo cp bibos-postinstall.desktop /etc/xdg/autostart
# Copy finalize script to /usr/share/bibos/bin
sudo cp bibos-postinstall.sh /usr/share/bibos/bin
# Modify /etc/lightdm/lightdm.conf to avoid automatic user login
if [ ! -f /etc/lightdm/lightdm.backup ]; then
	sudo cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.backup
fi
sudo sed -i "s/autologin-user=[a-zA-Z0-9]\+/autologin-user=$USER/" /etc/lightdm/lightdm.conf
# The PostInstall script should clean up, i.e. reverse all these changes.

