#!/bin/bash

# This script cleans up the users home directory.

USERNAME="user"

# Determine the name of the user desktop directory. This is done via xdg-user-dir,
# which checks the /home/user/.config/user-dirs.dirs file. To ensure this file exists,
# we run xdg-user-dirs-update, which generates it based on the environment variables
# LANG and LANGUAGE. These variables are empty in lightdm so we first export them
# based on the values stored in /etc/default/locale
export "$(grep LANG= /etc/default/locale | tr -d '"')"
runuser -u $USERNAME xdg-user-dirs-update
DESKTOP=$(runuser -u $USERNAME xdg-user-dir DESKTOP)

chattr -i "$DESKTOP"

rm --recursive --force /tmp/* /tmp/.??* /home/$USERNAME
# Remove pending print jobs
PRINTERS=$(lpstat -p | grep printer | awk '{ print $2; }')

for PRINTER in $PRINTERS
do
    lprm -P $PRINTER -
done

# Restore $HOME
rsync -vaz /home/.skjult/ /home/$USERNAME/
chown -R $USERNAME:$USERNAME /home/$USERNAME

# Make the desktop read only to user
chown -R root:$USERNAME "$DESKTOP"
chattr +i "$DESKTOP"
