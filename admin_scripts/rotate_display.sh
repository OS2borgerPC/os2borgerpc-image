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

AUTOSTART_FOLDER=/home/.skjult/.config/autostart/

if [ ! -d $AUTOSTART_FOLDER ]; then
    mkdir $AUTOSTART_FOLDER
    echo "$AUTOSTART_FOLDER created..."
fi

ROTATE_SCREEN_FILE=rotate_screen.sh
ROTATE_SCREEN_FILE_COMPLETE_PATH="$AUTOSTART_FOLDER$ROTATE_SCREEN_FILE"

if [ -f $ROTATE_SCREEN_FILE_COMPLETE_PATH ]; then
    rm $ROTATE_SCREEN_FILE_COMPLETE_PATH
    echo "$ROTATE_SCREEN_FILE_COMPLETE_PATH deleted..."
fi
cat <<EOT >> "$ROTATE_SCREEN_FILE_COMPLETE_PATH"
#!/bin/bash

active_monitors=\$(xrandr --listactivemonitors | grep -oE ' (e?)DP-[0-9](-?[0-9]?)(-?[0-9]?)')

active_monitors_array=(\$active_monitors)

xrandr --output \${active_monitors_array[0]} --rotate $1
EOT

chmod +x $ROTATE_SCREEN_FILE_COMPLETE_PATH

echo "$ROTATE_SCREEN_FILE_COMPLETE_PATH created with rotation $1"

DESKTOP_FILENAME=rotate_screen.desktop
DESKTOPFILE_COMPLETE_PATH="$AUTOSTART_FOLDER$DESKTOP_FILENAME"
if [ -f $DESKTOPFILE_COMPLETE_PATH ]; then
  exit 0
fi

#xrandr --output DP-1 --rotate $1

cat <<EOT >> "$DESKTOPFILE_COMPLETE_PATH"
[Desktop Entry]
Type=Application
Exec=$ROTATE_SCREEN_FILE_COMPLETE_PATH
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=rotate screen
Name=rotate screen
Comment[en_US]=Rotates Primary monitor $1
Comment=Rotates Primary monitor $1
EOT

chmod +x $DESKTOPFILE_COMPLETE_PATH

echo "$DESKTOPFILE_COMPLETE_PATH created..."
exit 0
