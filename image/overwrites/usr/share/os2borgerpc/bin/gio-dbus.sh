#! /usr/bin/env sh

# gio needs to run as the user + dbus-launch, we have this script to create it and kill it afterwards
export $(dbus-launch)
DBUS_PROCESS=$$

# Determine the name of the user desktop directory. This can be done simply
# because this file is run as user during the execution of GIO_LAUNCHER
# which already makes sure that /home/user/.config/user-dirs.dirs exists
DESKTOP=$(xdg-user-dir DESKTOP)

for FILE in $DESKTOP/*.desktop; do
  gio set "$FILE" metadata::trusted true
done

kill $DBUS_PROCESS
