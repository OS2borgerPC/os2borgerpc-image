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
#     2017/19/12 : danni : Script creation.
#
#================================================================
# END_OF_HEADER
#================================================================

CHROME_PREFERENCE_FILE='/home/.skjult/.config/google-chrome/Default/Preferences'

if [ ! -f $LOCAL_CHROME_FILE  ]
then
    echo 'File does not exists. Is Google Chrome installed?'
    exit -1
fi

sed '/countryid_at_install/ a \"credentials_enable_autosignin\":false,\"credentials_enable_service\":false,'

echo 'Autologin is disabled.'

exit 0