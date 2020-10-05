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

# Remove Bluetooth indicator applet from Borger user
"$DIR/../../admin_scripts/image_core/remove_bluetooth_applet.sh"

# This is not necessary, as these settings are now in overwrites.
# "$DIR/../../admin_scripts/image_core/dconf_policy_desktop.sh" "$DIR/../graphics/production-green.png"
# Instead just
dconf update
