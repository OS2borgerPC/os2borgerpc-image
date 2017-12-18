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
#-    version         set_chrome_as_default_browser (magenta.dk) 0.0.2
#-    author          Danni Als
#-    copyright       Copyright 2017, Magenta Aps"
#-    license         GNU General Public License
#-    email           danni@magenta.dk
#-
#================================================================
#  HISTORY
#     2017/18/12 : danni : Now creates a mimeapps.list file in .skjult setting chrome to default browser.
#     2017/24/11 : danni : Now checks if Chrome is installed.
#     2017/24/11 : danni : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================

CHROME_VERSION=$(google-chrome --version)

if [ -z "$CHROME_VERSION" ]
then
    echo 'Google Chrome is not installed.'
    exit -1
fi

MIMEAPPS=/home/.skjult/.config/mimeapps.list


cat <<EOT >> "$MIMEAPPS"
[Default Applications]
x-scheme-handler/http=google-chrome.desktop
x-scheme-handler/https=google-chrome.desktop
text/html=google-chrome.desktop

[Added Associations]
x-scheme-handler/http=google-chrome.desktop;
x-scheme-handler/https=google-chrome.desktop;
text/html=google-chrome.desktop;
EOT
