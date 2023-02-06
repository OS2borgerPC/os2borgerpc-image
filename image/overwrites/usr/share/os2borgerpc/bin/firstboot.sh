#!/usr/bin/env bash

# switch to normal lightdm timeout
sed --in-place "s/autologin-user-timeout=30/autologin-user-timeout=10/" /etc/lightdm/lightdm.conf

# Activate superuser desktop shortcuts
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u superuser)/bus"
USR=superuser
for FILE in /home/$USR/Skrivebord/*.desktop; do
  chown superuser:superuser "$FILE"
	runuser -u $USR gio set "$FILE" metadata::trusted true
	chown root:root "$FILE"
	# In order for gio changes to take effect, it is necessary to update the file time stamp
	touch "$FILE"
done

# Install dbus-x11 for dbus-launch
apt-get -y install dbus-x11

# Remove password bypass on firstboot.sh
sed --in-place "/firstboot/d" /etc/sudoers

# Remove the firstboot-related files
rm /home/superuser/.config/autostart/firstboot.desktop /usr/share/os2borgerpc/bin/firstboot.sh