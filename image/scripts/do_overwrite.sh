#!/usr/bin/env bash

if [ -z $1 ]
then
    DESTINATION='/'
else
    DESTINATION=$1
fi


# First, special handling of Gnome Control Center
pushd /usr/bin/
cp gnome-control-center gnome-control-center.real
popd

# Now do the deed
cp -r ../overwrites/* $DESTINATION


