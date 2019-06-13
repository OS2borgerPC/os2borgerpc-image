#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    chrome_autostart - args[fullscreen(Ja/Nej)]
#%
#% DESCRIPTION
#%    This script sets Google Chrome to autostart in fullscreen or normal screen size.
#%
#================================================================
#- IMPLEMENTATION
#-    version         chrome_autostart (magenta.dk) 0.0.1
#-    author          Danni Als
#-    copyright       Copyright 2019, Magenta Aps"
#-    license         GNU General Public License
#-    email           danni@magenta.dk
#-
#================================================================
#  HISTORY
#     2019/13/06 : danni : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================

command="[Desktop Entry]\nType=Application\nExec=google-chrome --full-screen\nHidden=false\nNoDisplay=false\nX-GNOME-Autostart-enabled=true\nName[en_US]=Chrome\nName=Chrome\nComment[en_US]=run the Google-chrome webbrowser at startup\nComment=run the Google-chrome webbrowser at startup\nName[en]=Chrome\n"

if [ "$1" == "Nej" ]
then
    command=$(echo $command | sed -e "s/ --full-screen//g")
fi

echo "Adding chrome to autostart"
mkdir /home/.skjult/.config/autostart
printf  "$command" > /home/.skjult/.config/autostart/chrome.desktop
echo "Done."
