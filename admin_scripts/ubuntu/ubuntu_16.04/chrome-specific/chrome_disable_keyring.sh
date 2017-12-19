#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    disable_keyring
#%
#% DESCRIPTION
#%    This is script sets Google Chromes default keyring.
#%
#================================================================
#- IMPLEMENTATION
#-    version         disable_keyring (magenta.dk) 0.0.1
#-    author          Danni Als
#-    copyright       Copyright 2017, Magenta Aps"
#-    license         GNU General Public License
#-    email           danni@magenta.dk
#-
#================================================================
#  HISTORY
#     2017/19/12 : danni : Now copies global chrome config into .skjult and adds password-store.
#     2017/24/11 : danni : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================

LOCAL_PATH='/home/.skjult/.local/share/applications/'

LOCAL_CHROME_FILE="$LOCAL_PATH" + 'google-chrome.desktop'

if [ -f $LOCAL_CHROME_FILE  ]
then
    rm $LOCAL_CHROME_FILE
    echo 'Old .xscreensaver file found. It has been deleted.'
fi

cp /usr/share/applications/google-chrome.desktop $LOCAL_PATH

sed '/%U/ a \--password-store=basic' $LOCAL_CHROME_FILE

exit 0