#! /usr/bin/env sh

USR="superuser"

DESKTOP=$(xdg-user-dir DESKTOP)

for FILE in "$DESKTOP/"*.desktop; do
  echo "About to fix permissions for the desktop shortcut: $FILE"
  gio set "$FILE" metadata::trusted true
  # Can't make sense of this as it already has execute permissions, but it won't work without it
  chmod u+x "$FILE"
done

echo "About to clean up after itself:"

# Cleanup and delete itself and the desktop file launching it
rm "$0" /home/superuser/.config/autostart/gio_fix_desktop_file_permissions_superuser.desktop
