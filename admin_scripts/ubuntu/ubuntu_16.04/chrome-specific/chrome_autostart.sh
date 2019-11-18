#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    chrome_autostart - args[fullscreen(Ja/Nej/Fjernj)]
#%
#% DESCRIPTION
#%    This script sets Google Chrome to autostart in fullscreen or normal screen size.
#%
#================================================================
#- IMPLEMENTATION
#-    version         chrome_autostart (magenta.dk) 0.0.4
#-    author          Danni Als
#-    copyright       Copyright 2019, Magenta Aps"
#-    license         GNU General Public License
#-    email           danni@magenta.dk
#-
#================================================================
#  HISTORY
#     2019/19/06 : danni : Changed exit -1 to exit 0 which is the correct exit status to use here.
#     2019/19/06 : danni : Added exit -1 after remove autostart has been completed.
#     2019/14/06 : danni : Changed command --full-screen to --start-fullscreen.
#     2019/14/06 : danni : Removed password-store popup.
#     2019/13/06 : danni : Added possibility to remove autostart file.
#     2019/13/06 : danni : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================

autostart_text="[Desktop Entry]\nType=Application\nExec=google-chrome-stable --password-store=basic --start-fullscreen\nHidden=false\nNoDisplay=false\nX-GNOME-Autostart-enabled=true\nName[en_US]=Chrome\nName=Chrome\nComment[en_US]=run the Google-chrome webbrowser at startup\nComment=run the Google-chrome webbrowser at startup\nName[en]=Chrome\n"
desktop_file="/home/.skjult/.config/autostart/chrome.desktop"

if [ "$1" == "Nej" ]
then
    autostart_text=$(echo $autostart_text | sed -e "s/ --start-fullscreen//g")
elif [ "$1" == "Fjern" ]
then
    echo "removing chrome from autostart"
    rm "$desktop_file"
    echo "Done."
    exit 0
fi

echo "Adding chrome to autostart"
mkdir /home/.skjult/.config/autostart
printf  "$autostart_text" > "$desktop_file"
echo "Done."
