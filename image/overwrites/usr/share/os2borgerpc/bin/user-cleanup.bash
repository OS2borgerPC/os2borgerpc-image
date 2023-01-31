#!/bin/bash

# This script cleans up the users home directory.

USERNAME="user"


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
