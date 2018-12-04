#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    set_default_applications_in_unity_launcher
#%
#% DESCRIPTION
#%    This script sets the unity launcher to only show:
#%    * nautilus-home
#%    * google-chrome
#%    * libreoffice-writer
#%    * libreoffice-calc
#%    * libreoffice-impress
#%
#================================================================
#- IMPLEMENTATION
#-    version         set_default_applications_in_unity_launcher (magenta.dk) 0.0.3
#-    author          Danni Als
#-    copyright       Copyright 2017, Magenta Aps"
#-    license         GNU General Public License
#-    email           danni@magenta.dk
#-
#================================================================
#  HISTORY
#     2017/22/11 : danni     : Script creation
#     2017/23/11 : danni     : User Unity Launcher should not contain amazon, ubuntu software and security copy.
#     2018/07/02 : andreasnn : Remove Amazon and other webapps
#     2018/04/12 : danni     : Remove gnome Software
#
#================================================================
# END_OF_HEADER
#================================================================
# Løsning fundet her:
# https://askubuntu.com/questions/611162/how-do-you-add-remove-applications-to-from-the-unity-launcher-from-command-line

set -e

AS_USER=user
HIDDEN_DIR=/home/.skjult

USER_LOGGED_IN=$(who | cut -f 1 -d ' ' | sort | uniq | grep $AS_USER)

if [ $USER_LOGGED_IN ]
then
    # Run gsettings with X, change background right away.
    export DISPLAY=:0.0
    export XAUTHORITY=/home/$AS_USER/.Xauthority
    su - $AS_USER -s /bin/bash -c '/usr/bin/gsettings set com.canonical.Unity.Launcher favorites '\"'['\''application://nautilus-home.desktop'\'', '\''application://google-chrome.desktop'\'', '\''application://libreoffice-writer.desktop'\'', '\''application://libreoffice-calc.desktop'\'', '\''application://libreoffice-impress.desktop'\'', '\''unity://running-apps'\'', '\''unity://expo-icon'\'', '\''unity://devices'\'']'\"''
else
    su - $AS_USER -s /bin/bash -c 'dbus-launch --exit-with-session /usr/bin/gsettings set com.canonical.Unity.Launcher favorites '\"'['\''application://nautilus-home.desktop'\'', '\''application://google-chrome.desktop'\'', '\''application://libreoffice-writer.desktop'\'', '\''application://libreoffice-calc.desktop'\'', '\''application://libreoffice-impress.desktop'\'', '\''unity://running-apps'\'', '\''unity://expo-icon'\'', '\''unity://devices'\'']'\"''
fi

cp /home/$AS_USER/.config/dconf/$AS_USER $HIDDEN_DIR/.config/dconf/


# Remove Amazon and other webapps

# The package is not a Unity dependency
# apt -y purge unity-webapps-common

# Removing the package could give problems, depending on the installation method, so:
mv /usr/share/applications/ubuntu-amazon-default.desktop /usr/share/applications/ubuntu-amazon-default.desktop.org
mv /usr/share/applications/org.gnome.Software.desktop /usr/share/applications/org.gnome.Software.desktop.org
