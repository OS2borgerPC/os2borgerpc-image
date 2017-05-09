#!/usr/bin/env bash

if [ -z $1 ]
then
    DESTINATION='/'
else
    DESTINATION=$1
fi


# First, special handling of Gnome Control Center
pushd /usr/bin/ > /dev/null
#Try gnome (ubuntu 12)
cp gnome-control-center gnome-control-center.real
#Try unity (ubuntu 14)
cp unity-control-center unity-control-center.real
popd > /dev/null

# Then, disable all X sessions except one
# TODO: This does not seem to work very well - investigate!
#pushd /usr/share/xsessions > /dev/null
#mv gnome.desktop gnome.desktop.backup
#mv gnome-shell.desktop gnome-shell.desktop.backup
#mv ubuntu.desktop ubuntu.desktop.backup
#mv ubuntu-2d.desktop ubuntu-2d.desktop.backup
#popd > /dev/null

# Now do the deed
cp -r ../overwrites/* $DESTINATION

# Permissions fixup
chmod 0440 ${DESTINATION}etc/sudoers.d/keep-proxy
# Remove Bluetooth indicator applet from Borger user
BLUETOOTH_INDICATOR_PATH=$(find /usr/lib -name 'indicator-bluetooth-service')
if [ ! -z "$BLUETOOTH_INDICATOR_PATH" ]
then
    chmod o-x $BLUETOOTH_INDICATOR_PATH
fi

chown root:adm /usr/bin/unity-control-center
chmod o-x /usr/bin/unity-control-center
chmod g+rx, o-x /usr/bin/unity-control-center
