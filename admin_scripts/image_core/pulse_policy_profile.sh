#!/bin/sh

#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    pulse_policy_profile.sh [PROFILE]
#%
#% DESCRIPTION
#%    This script changes the default output profile used by PulseAudio, and
#%    should be used when a system doesn't automatically detect the correct
#%    audio device.
#%
#%    It takes one optional parameter: which output profile to select. (Typical
#%    values for this parameter include "hdmi" and "analog".) If this parameter
#%    is missing, empty, "false", or "falsk", the policy will instead be
#%    removed.
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
#     2020/10/05 : af : Script created
#
#================================================================
# END_OF_HEADER
#================================================================

POLICY="/etc/pulse/os2borgerpc/profile.pa"

set -ex

if [ "$1" = "" -o "$1" = "false" -o "$1" = "falsk" ]; then
    rm -f "$POLICY"
else
    # Configure PulseAudio to load OS2borgerPC-specific settings from a special
    # directory
    if ! grep "os2borgerpc" /etc/pulse/default.pa ; then
        echo ".include /etc/pulse/os2borgerpc/" >> /etc/pulse/default.pa
    fi
    mkdir -p "`dirname "$POLICY"`"

    cat > "$POLICY" <<END
# Select a custom PulseAudio policy whenever the daemon starts
set-card-profile 0 output:$1-stereo
END
fi
