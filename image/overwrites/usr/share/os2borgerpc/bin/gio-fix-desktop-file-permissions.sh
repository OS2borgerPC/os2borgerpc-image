#! /usr/bin/env sh

USERNAME=user
GIO_SCRIPT=/usr/share/os2borgerpc/bin/gio-dbus.sh
# Determine the name of the user desktop directory. This is done via xdg-user-dir,
# which checks the /home/user/.config/user-dirs.dirs file. To ensure this file exists,
# we run xdg-user-dirs-update, which generates it based on the environment variable
# LANG. This variable is empty in lightdm so we first export it
# based on the value stored in /etc/default/locale
export $(grep LANG= /etc/default/locale | tr -d '"')
runuser -u user xdg-user-dirs-update
DESKTOP=$(runuser -u $USERNAME xdg-user-dir DESKTOP)

# Gio expects the user to own the file so temporarily change that
for FILE in $DESKTOP/*.desktop; do
  chown $USERNAME:$USERNAME $FILE
done

su --login user --command $GIO_SCRIPT

# Now set the permissions back to their restricted form
for FILE in $DESKTOP/*.desktop; do
  chown root:$USERNAME "$FILE"
  # In order for gio changes to take effect, it is necessary to update the file time stamp
  # This can be done with many commands such as chmod or simply touch
  # However, in some cases the files might not have execute permission so we add it with chmod
  chmod ug+x "$FILE"
done
