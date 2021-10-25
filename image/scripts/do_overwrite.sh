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

# Remove Bluetooth indicator applet from Borger user
"$DIR/../../admin_scripts/image_core/remove_bluetooth_applet.sh"

# Update dconf with settings from overwrites.
dconf update
