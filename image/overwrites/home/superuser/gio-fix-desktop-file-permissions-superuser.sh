#! /usr/bin/env sh

for FILE in /home/superuser/Skrivebord/*.desktop; do
  gio set "$FILE" metadata::trusted true
  # Can't make sense of this as it already has execute permissions, but it
  # won't work without it
  chmod ug+x "$FILE"
done

# Cleanup and delete itself and the desktop file launching it
rm /home/superuser/.config/autostart/gio-fix-desktop-file-permssions-superuser.desktop /home/superuser/gio-fix-desktop-file-permssions-superuser.sh
