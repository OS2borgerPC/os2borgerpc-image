#!/bin/bash

#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    rotate_display.sh [normal/right/left]
#%
#% DESCRIPTION
#%    This script looks for all displays connected and rotates the first one from the list.
#%
#%    It takes one mandatory parameter. The direction of the rotation.
#%
#================================================================
#- IMPLEMENTATION
#-    version         rotate_display.sh (magenta.dk) 1.0.0
#-    author          Danni Als
#-    copyright       Copyright 2019, Magenta ApS
#-    license         GNU General Public License
#-    email           danni@magenta-aps.dk
#-
#================================================================
#  HISTORY
#     2019/11/12 : af : Script created
#
#================================================================
# END_OF_HEADER
#================================================================

set -e

if [ "$1" != "normal" -a "$1" != "right" -a "$1" != "left" ]; then
    echo "Wrong rotation command given: $1"
    exit -1
fi

active_monitors=$(xrandr --listactivemonitors | grep -oE ' (e?)DP-[0-9](-?[0-9]?)(-?[0-9]?)')

active_monitors_array=($active_monitors)

echo -e "${#active_monitors_array[@]} Active monitors found:\n${active_monitors}"

echo "Rotating monitor named: ${active_monitors_array[0]}"

xrandr --output ${active_monitors_array[0]} --rotate $1

exit 0




