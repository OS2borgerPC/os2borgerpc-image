#!/usr/bin/env bash

# switch to normal lightdm timeout
sed --in-place "s/autologin-user-timeout=30/autologin-user-timeout=10/" /etc/lightdm/lightdm.conf

# Install dbus-x11 for dbus-launch from .deb file
dpkg -i /etc/os2borgerpc/*.deb

# Activate superuser desktop shortcuts
USR=superuser
for FILE in /home/$USR/Skrivebord/*.desktop; do
	runuser -u $USR dbus-launch gio set "$FILE" metadata::trusted true
	# In order for gio changes to take effect, it is necessary to update the file time stamp
	touch "$FILE"
done

# Remove the firstboot-related files
rm  /etc/lightdm/greeter-setup-scripts/firstboot.sh /etc/os2borgerpc/*.deb