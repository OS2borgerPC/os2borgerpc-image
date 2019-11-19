#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    remove_bluetooth_applet.sh
#%
#% DESCRIPTION
#%    This script removes the bluetooth applet if present.
#%
#================================================================
#- IMPLEMENTATION
#-    version         remove_bluetooth_applet (magenta.dk) 0.0.1
#-    author          Danni Als
#-    copyright       Copyright 2017, Magenta Aps"
#-    license         GNU General Public License
#-    email           danni@magenta.dk
#-
#================================================================
#  HISTORY
#     2017/06/11 : danni : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================
set -e

# Remove Bluetooth indicator applet from Borger user
BLUETOOTH_INDICATOR_PATH=$(find /usr/lib -name 'indicator-bluetooth-service')
if [ ! -z "$BLUETOOTH_INDICATOR_PATH" ]
then
    chmod o-x $BLUETOOTH_INDICATOR_PATH
fi
