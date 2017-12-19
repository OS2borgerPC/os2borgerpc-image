#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    chrome_disable_autologin.sh
#%
#% DESCRIPTION
#%    This script disables Google Chrome autologin, and savev password feature.
#%
#================================================================
#- IMPLEMENTATION
#-    version         chrome_disable_autologin.sh (magenta.dk) 0.0.1
#-    author          Danni Als
#-    copyright       Copyright 2017, Magenta Aps"
#-    license         GNU General Public License
#-    email           danni@magenta.dk
#-
#================================================================
#  HISTORY
#     2017/19/12 : danni : Modified sed command, so new line and spaces matches the rest of the file.
#     2017/19/12 : danni : Added checks to if file is present, or autologin is already disabled.
#     2017/19/12 : danni : Script creation.
#
#================================================================
# END_OF_HEADER
#================================================================

CHROME_PREFERENCE_FILE='/home/.skjult/.config/google-chrome/Default/Preferences'

if [ ! -f $CHROME_PREFERENCE_FILE  ]
then
    echo 'File does not exists. Is Google Chrome installed?'
    exit -1
elif grep -Fxq 'credentials_enable_autosignin' $CHROME_PREFERENCE_FILE
then
    echo 'Autologin is already disabled.'
    exit -1
fi

sed -i '/countryid_at_install/s/$/\n   \"credentials_enable_autosignin\":false,\n    \"credentials_enable_service\":false,/' $CHROME_PREFERENCE_FILE

echo 'Autologin is disabled.'

exit 0