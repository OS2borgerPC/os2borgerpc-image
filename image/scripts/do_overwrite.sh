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


