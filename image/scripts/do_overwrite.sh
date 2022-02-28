#!/usr/bin/env bash

if [ -z $1 ]
then
    DESTINATION='/'
else
    DESTINATION=$1
fi

# First, special handling of Gnome Control Center
pushd /usr/bin/ > /dev/null
cp gnome-control-center gnome-control-center.real
popd > /dev/null

# Now do the deed
DIR=$(dirname $(realpath $0 ))
cp -r "$DIR"/../overwrites/* $DESTINATION

# Permissions fixup
chmod 0440 ${DESTINATION}etc/sudoers.d/keep-proxy
chmod 0400 ${DESTINATION}home/.skjult/.local/share/keyrings/Standardnøglering.keyring
mkdir --parents /home/superuser/.config/autostart
# superuser doesn't exist yet but we create the user specifically with the user id 1001, so set that
# here
chown -R 1001:1001 /home/superuser
chmod 0777 ${DESTINATION}home/superuser/.config/autostart/gio-fix-desktop-file-permissions-superuser.desktop ${DESTINATION}home/superuser/gio-fix-desktop-file-permissions-superuser.sh

# Remove Bluetooth indicator applet from Borger user
"$DIR/remove_bluetooth_applet.sh"

# Update dconf with settings from overwrites.
dconf update
