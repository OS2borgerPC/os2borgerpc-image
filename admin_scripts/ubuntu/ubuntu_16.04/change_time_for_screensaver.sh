#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    change_time_for_screensaver.sh args Time in minutes
#%
#% DESCRIPTION
#%    This changes the system settings for gnome screensaver.
#%    0 disables screensaver.
#%
#%    Gnome screen saver is not the recommended screensaver for Ubuntu.
#%    Xscreensaver is a better option and much more versatile.
#%
#================================================================
#- IMPLEMENTATION
#-    version         change_time_for_screensaver.sh (magenta.dk) 0.0.1
#-    author          Danni Als
#-    copyright       Copyright 2017, Magenta Aps"
#-    license         GNU General Public License
#-    email           danni@magenta.dk
#-
#================================================================
#  HISTORY
#     2017/18/12 : danni : Removes xscreensaver if present.
#     2017/02/11 : danni : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================

if [ $# -ne 1 ]
then
    echo "This job takes exactly one parameter."
    exit -1
fi


# Disables xscreensaver if present.
SCREENSAVER_FILE="/home/.skjult/.xscreensaver"

if [ -f $SCREENSAVER_FILE ]
then
    rm $SCREENSAVER_FILE
    echo 'Old .xscreensaver file found. It has been deleted.'
fi

TIME=$1

echo "$TIME in minutes"

if [ -z "${TIME##+([0-9])}" ]
then
    echo "Input has to be a number."
    exit -1
fi


TIME=$(($TIME*60))

echo "$TIME in seconds"

mkdir -p /home/.skjult/.config/autostart

cat << EOF > /home/.skjult/.config/autostart/gnome-screensaver.desktop

[Desktop Entry]
Type=Application
Exec=gsettings set org.gnome.desktop.session idle-delay $TIME
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[da_DK]=Pauseskærm
Name=Pauseskærm
Comment[da_DK]=
Comment=
EOF