#!/bin/sh

#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    xdg_policy_numlock.sh [MODE]
#%
#% DESCRIPTION
#%    This script controls the state of the NumLock key when the user logs in.
#%
#%    It takes one optional parameter: the state to set the NumLock key to.
#%    This should be either "on" (or, equivalently, "til") or "off" (or,
#%    equivalently, "fra"). If this parameter is missing, empty, "false", or
#%    "falsk", the policy will instead be removed.
#%
#================================================================
#- IMPLEMENTATION
#-    version         pulse_policy_profile.sh (magenta.dk) 1.0.0
#-    author          Alexander Faithfull
#-    copyright       Copyright 2020 Magenta ApS
#-    license         GNU General Public License
#-    email           af@magenta.dk
#-
#================================================================
#  HISTORY
#     2021/05/27 : af : Script created
#
#================================================================
# END_OF_HEADER
#================================================================

POLICY="/etc/xdg/autostart/os2borgerpc-numlock.desktop"

set -ex

if [ "$1" = "" -o "$1" = "false" -o "$1" = "falsk" ]; then
    rm -f "$POLICY"
else
    if [ ! -f "/usr/bin/numlockx" ]; then
        # Stop Debconf from doing anything
        export DEBIAN_FRONTEND=noninteractive
        apt-get update > /dev/null
        apt-get -yf install numlockx
    fi

    if [ "$1" = "on" -o "$1" = "til" ]; then
        state="on"
    elif [ "$1" = "off" -o "$1" = "fra" ]; then
        state="off"
    else
        exit 2
    fi
    cat > "$POLICY" <<END
[Desktop Entry]
Type=Application
Name=OS2borgerPC - Set NumLock state
Name[da]=OS2borgerPC - Sæt NumLock-tilstand
Exec=/usr/bin/numlockx $state
Terminal=False
NoDisplay=true
END
fi
