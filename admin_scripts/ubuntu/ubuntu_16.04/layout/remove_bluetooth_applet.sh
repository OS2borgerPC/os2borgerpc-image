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

export DEBIAN_FRONTEND=noninteractive

# Remove Bluetooth indicator applet from Borger user
apt-get update > /dev/null
apt-get -y remove indicator-bluetooth
apt-get -y autoremove
apt-get -y clean

