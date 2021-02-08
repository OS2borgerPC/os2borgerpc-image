#!/usr/bin/env bash

#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    chrome_policy_homepage.sh [URL]
#%
#% DESCRIPTION
#%    This script adds a Google Chrome policy that defines a homepage, adds
#%    the "Home" button to the main browser bar, and causes the homepage to
#%    be opened automatically when the browser starts.
#%
#%    Adding a Google Chrome policy does not require that Google Chrome is
#%    already installed, although obviously the policy won't take effect
#%    until it has been.
#%
#%    It takes one optional parameter: the URL to set as the homepage. If
#%    this parameter is missing or empty, the existing policy will be
#%    deleted, if there is one.
#%
#================================================================
#- IMPLEMENTATION
#-    version         chrome_policy_homepage.sh (magenta.dk) 1.0.0
#-    author          Alexander Faithfull
#-    copyright       Copyright 2019, Magenta ApS
#-    license         GNU General Public License
#-    email           af@magenta.dk
#-
#================================================================
#  HISTORY
#     2019/09/23 : af : Script created
#
#================================================================
# END_OF_HEADER
#================================================================

set -x

POLICY="/etc/opt/chrome/policies/managed/os2borgerpc-homepage.json"

if [ "$1" = "" ]; then
    rm -f "$POLICY"
else
    if [ ! -d "`dirname "$POLICY"`" ]; then
        mkdir -p "`dirname "$POLICY"`"
    fi

    cat > "$POLICY" <<END
{
    "ShowHomeButton": true,
    "HomepageIsNewTabPage": false,
    "HomepageLocation": "$1",

    "RestoreOnStartup": 4,
    "RestoreOnStartupURLs": [
        "$1"
    ]
}
END
fi
