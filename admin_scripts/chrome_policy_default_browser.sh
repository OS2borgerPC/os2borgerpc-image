#!/usr/bin/env bash

#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    chrome_policy_defalt_browser.sh [URL]
#%
#% DESCRIPTION
#%    This script adds a Google Chrome policy that prevents Google
#%    Chrome from asking if it should be default browser.
#%
#%    Adding a Google Chrome policy does not require that Google Chrome is
#%    already installed, although obviously the policy won't take effect
#%    until it has been.
#%
#================================================================
#- IMPLEMENTATION
#-    version         chrome_policy_homepage.sh (magenta.dk) 1.0.0
#-    author          Carsten Agger
#-    copyright       Copyright 2020, Magenta ApS
#-    license         GNU General Public License
#-    email           carstena@magenta.dk
#-
#================================================================
#  HISTORY
#     2020/11/16 : carstena : Script created
#
#================================================================
# END_OF_HEADER
#================================================================

set -x

POLICY="/etc/opt/chrome/policies/managed/os2borgerpc-default-hp.json"

if [ ! -d "`dirname "$POLICY"`" ]; then
    mkdir -p "`dirname "$POLICY"`"
fi

cat > "$POLICY" <<END
{
    "DefaultBrowserSettingEnabled": true,
    "MetricsReportingEnabled": false
}
END
