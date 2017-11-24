#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    set_chrome_as_default_browser
#%
#% DESCRIPTION
#%    This is script sets chrome as default browser.
#%
#================================================================
#- IMPLEMENTATION
#-    version         set_chrome_as_default_browser (magenta.dk) 0.0.1
#-    author          Danni Als
#-    copyright       Copyright 2017, Magenta Aps"
#-    license         GNU General Public License
#-    email           danni@magenta.dk
#-
#================================================================
#  HISTORY
#     2017/24/11 : danni : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================

if [ $(google-chrome --version) -ne 0 ]
then
    echo 'Google Chrome is not installed.'
    exit -1
fi

AS_USER=user

su - $AS_USER -s /bin/bash -c 'xdg-settings set default-web-browser google-chrome.desktop'

HIDDEN_DIR=/home/.skjult
cp /home/user/.config/dconf/$AS_USER $HIDDEN_DIR/.config/dconf/