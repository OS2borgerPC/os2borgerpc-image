#!/usr/bin/env bash

if [ "$USER" == "root" ]; then
	echo "Please do not run this script as root, run it as the superuser instead."
	exit 1
fi

if [ -f ~/.config/user-dirs.dirs ]; then
    source ~/.config/user-dirs.dirs
fi
if [ "$XDG_DESKTOP_DIR" == "" ]; then
    XDG_DESKTOP_DIR="$HOME/Skrivebord"
fi

# Copy desktop file to /etc/xdg/autostart
sudo cp bibos-postinstall.desktop "${XDG_DESKTOP_DIR}/"
sudo chown $USER "${XDG_DESKTOP_DIR}/bibos-postinstall.desktop"
# Copy finalize script to /usr/share/bibos/bin
sudo cp bibos-postinstall.sh /usr/share/bibos/bin
# Modify /etc/lightdm/lightdm.conf to avoid automatic user login
sudo cp /etc/lightdm/lightdm.conf.bibos_firstboot /etc/lightdm/lightdm.conf
sudo sed -i "s/autologin-user=[a-zA-Z0-9]\+/autologin-user=$USER/" /etc/lightdm/lightdm.conf
# The PostInstall script should clean up, i.e. reverse all these changes.

