#!/usr/bin/env bash

# switch to normal lightdm timeout
sed --in-place "s/autologin-user-timeout=30/autologin-user-timeout=10/" /etc/lightdm/lightdm.conf

# Activate superuser desktop shortcuts
USR=superuser
for FILE in /home/$USR/Skrivebord/*.desktop; do
	gio set "$FILE" metadata::trusted true
	# Can't make sense of this as it already has execute permissions, but it won't work without it
	chmod u+x "$FILE"
done

# Remove password bypass on firstboot.sh
sed --in-place "/firstboot/d" /etc/sudoers

# Remove the firstboot-related files
rm /home/superuser/.config/autostart/firstboot.desktop /usr/share/os2borgerpc/bin/firstboot.sh