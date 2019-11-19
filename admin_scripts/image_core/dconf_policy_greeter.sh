#!/usr/bin/env bash

#================================================================
#% SYNOPSIS
#+    dconf_policy_greeter.sh [FILE]
#%
#% DESCRIPTION
#%    This script configures whether or not the greeter (i.e., the login
#%    screen) should show the background image of the selected user. If used
#%    together with dconf_policy_desktop.sh, which sets a background image for
#%    all users, this has the effect of setting that background as the
#%    greeter's background.
#%
#%    It takes one optional parameter. If this parameter is "false" or "falsk",
#%    the greeter will not show user background images; any other value will
#%    cause them to be shown. Omitting this parameter altogether will remove
#%    all changes made by this script.
#%
#================================================================
#- IMPLEMENTATION
#-    version         dconf_policy_greeter.sh (magenta.dk) 1.0.0
#-    author          Alexander Faithfull
#-    copyright       Copyright 2019, Magenta ApS
#-    license         GNU General Public License
#-    email           af@magenta.dk
#-
#================================================================
#  HISTORY
#     2019/09/24 : af : dconf_policy_desktop.sh created
#     2019/11/19 : af : New derived script created
#
#================================================================
# END_OF_HEADER
#================================================================

set -x

POLICY="/etc/dconf/db/os2borgerpc.d/00-greeter"
POLICY_LOCK="/etc/dconf/db/os2borgerpc.d/locks/greeter"

if [ "$1" = "" ]; then
    rm -f "$POLICY"
    rm -f "$POLICY_LOCK"
else
    if [ ! -d "`dirname "$POLICY"`" ]; then
        mkdir "`dirname "$POLICY"`"
    fi
    if [ ! -d "`dirname "$POLICY_LOCK"`" ]; then
        mkdir "`dirname "$POLICY_LOCK"`"
    fi

    # dconf does not, by default, require the use of a system database, so
    # add one (called "os2borgerpc") to store our system-wide settings in
    cat > "/etc/dconf/profile/user" <<END
user-db:user
system-db:os2borgerpc
END

    VS="true"
    if [ "$1" = "false" -o "$1" = "falsk" ]; then
        VS="false"
    fi

    cat > "$POLICY" <<END
[com/canonical/unity-greeter]
play-ready-sound=false
draw-user-backgrounds=$VS
END
    # "dconf update" will only act if the content of the keyfile folder has
    # changed: individual files changing are of no consequence. Force an update
    # by changing the folder's modification timestamp
    touch "`dirname "$POLICY"`"

    # Tell the system that the values of the dconf keys we've just set can no
    # longer be overridden by the user
    cat > "$POLICY_LOCK" <<END
/com/canonical/unity-greeter/play-ready-sound
/com/canonical/unity-greeter/draw-user-backgrounds
END
fi

# Incorporate all of the text files we've just created into the system's dconf
# databases
dconf update
