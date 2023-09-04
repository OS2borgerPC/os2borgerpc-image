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
#     2021/02/01 : carstena: Disable completely for Ubuntu 20.04- 
#
#================================================================
# END_OF_HEADER
#================================================================
set -e

# Disable Bluetooth completely.
systemctl disable --now bluetooth.service
