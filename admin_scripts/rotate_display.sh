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
#%    Based on xrandr. From xrandr manual:
#%    "Rotation can be one of 'normal', 'left', 'right' or 'inverted'. This causes the output contents to be
#%    rotated in the specified direction. 'right' specifies a clockwise rotation of the picture and  'left'
#%    specifies a counter-clockwise rotation."
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
#     2019/11/14 : af : Changed tactics. Instead of trying to connect to the X-server from root, we now rotate screen upon user login.
#
#================================================================
# END_OF_HEADER
#================================================================

set -e

if [ "$1" != "normal" -a "$1" != "right" -a "$1" != "left" ]; then
    echo "Wrong rotation command given: $1"
    exit -1
fi

# Testing....
#w
#
#USER_LOGGED_IN=$(who | cut -f 1 -d ' ' | sort | uniq | grep user)
#echo "User logged in $USER_LOGGED_IN"
#
#export DISPLAY=:0.0
#export XAUTHORITY=/home/user/.Xauthority

# xdpyinfo

#xrandr -q
# Testing....

#active_monitors=$(xrandr --listactivemonitors | grep -oE ' (e?)DP-[0-9](-?[0-9]?)(-?[0-9]?)')
#
#active_monitors_array=($active_monitors)
#
#echo -e "${#active_monitors_array[@]} Active monitors found:\n${active_monitors}"
#
#echo "Rotating monitor named: ${active_monitors_array[0]}"
#
#xrandr --output ${active_monitors_array[0]} --rotate $1
AUTOSTART_FOLDER=/home/.skjult/.config/autostart/
FILENAME=rotate_screen.desktop
COMPLETE_PATH="$AUTOSTART_FOLDER$FILENAME"
if [ -f $COMPLETE_PATH ]; then
    rm $COMPLETE_PATH
    echo "$COMPLETE_PATH deleted..."
fi
if [ ! -d $AUTOSTART_FOLDER ]; then
    mkdir $AUTOSTART_FOLDER
    echo "$AUTOSTART_FOLDER created..."
fi

cat <<EOT >> "$COMPLETE_PATH"
[Desktop Entry]
Type=Application
Exec=xrandr --output DP-1 --rotate $1
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=rotate screen
Name=rotate screen
Comment[en_US]=Rotates DP-1 $1
Comment=Rotates DP-1 $1
EOT
echo "$COMPLETE_PATH created with rotation $1"
exit 0
