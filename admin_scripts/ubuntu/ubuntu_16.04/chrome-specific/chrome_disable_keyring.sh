#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    chrome_disable_keyring
#%
#% DESCRIPTION
#%    This script copies Google Chromes desktop file to /home/.skjult,
#%    and disables keyring question.
#%
#================================================================
#- IMPLEMENTATION
#-    version         chrome_disable_keyring (magenta.dk) 0.0.4
#-    author          Danni Als
#-    copyright       Copyright 2017, Magenta Aps"
#-    license         GNU General Public License
#-    email           danni@magenta.dk
#-
#================================================================
#  HISTORY
#     2017/24/11 : danni : Instead of copy first, we do sed on global file and stream the edit into local file.
#     2017/19/12 : danni : If local path does not exists applications is created.
#     2017/19/12 : danni : If old desktop file is present, it is removed.
#     2017/19/12 : danni : Now copies global chrome desktop file into .skjult and adds password-store.
#     2017/24/11 : danni : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================

LOCAL_PATH='/home/.skjult/.local/share/applications/'

CHROME_DESKTOP='google-chrome.desktop'

LOCAL_CHROME_FILE="$LOCAL_PATH$CHROME_DESKTOP"

if [ -f $LOCAL_CHROME_FILE  ]
then
    rm $LOCAL_CHROME_FILE
    echo 'Old google-chrome.desktop file found. It has been deleted.'
elif [ ! -d "$LOCAL_PATH" ]
then
    mkdir $LOCAL_PATH
    echo "$LOCAL_PATH is created."
fi

GLOBAL_CHROME='/usr/share/applications/google-chrome.desktop'

sed '/%U/s/$/ --password-store=basic/' $GLOBAL_CHROME >> $LOCAL_CHROME_FILE

echo 'Password store is set to basic.'

exit 0