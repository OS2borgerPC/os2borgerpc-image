#!/usr/bin/env bash

#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    chrome_policy_deactivate_login.sh [URL]
#%
#% DESCRIPTION
#%    This script adds a Google Chrome policy that prevents the user
#%    logging in to the browser and disables the remember password
#%    feature.
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
#     2019/09/23 : af : Script created
#
#================================================================
# END_OF_HEADER
#================================================================

set -x

POLICY="/etc/opt/chrome/policies/managed/os2borgerpc-login.json"

if [ ! -d "`dirname "$POLICY"`" ]; then
    mkdir -p "`dirname "$POLICY"`"
fi

cat > "$POLICY" <<END
{
    "BrowserSignin": 0,
    "PasswordManagerEnabled": false
}
END
