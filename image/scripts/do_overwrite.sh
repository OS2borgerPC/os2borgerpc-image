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

# Setup cleanup script in systemd.
"$DIR/../../admin_scripts/image_core/systemd_policy_cleanup.sh" 1

# Update dconf with settings from overwrites.
dconf update
