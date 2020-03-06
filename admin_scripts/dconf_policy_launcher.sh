#!/usr/bin/env bash

#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    dconf_policy_launcher.sh [ENFORCE]
#%
#% DESCRIPTION
#%    This script causes the Unity launcher to be hidden until the user
#%    interacts with the left-hand side of the screen.
#%
#%    It takes one optional parameter: whether or not to enforce this policy.
#%    If this parameter is missing, empty, "false", or "falsk", the policy will
#%    be removed; otherwise, it will be enforced.
#%
#================================================================
#- IMPLEMENTATION
#-    version         dconf_policy_shutdown.sh (magenta.dk) 1.0.0
#-    author          Alexander Faithfull
#-    copyright       Copyright 2019, Magenta ApS
#-    license         GNU General Public License
#-    email           af@magenta.dk
#-
#================================================================
#  HISTORY
#     2019/09/25 : af : dconf_policy_desktop.sh created
#     2020/03/06 : af : This script created based on dconf_policy_desktop.sh
#
#================================================================
# END_OF_HEADER
#================================================================

set -x

POLICY="/etc/dconf/db/os2borgerpc.d/00-unity-launcher"
POLICY_LOCK="/etc/dconf/db/os2borgerpc.d/locks/unity-launcher"

if [ "$1" = "" -o "$1" = "false" -o "$1" = "falsk" ]; then
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

    cat > "$POLICY" <<END
[org/compiz/profiles/unity/plugins/unityshell]
launcher-hide-mode=1

[org/compiz/profiles/unity-lowgfx/plugins/unityshell]
launcher-hide-mode=1
END
    # "dconf update" will only act if the content of the keyfile folder has
    # changed: individual files changing are of no consequence. Force an update
    # by changing the folder's modification timestamp
    touch "`dirname "$POLICY"`"

    # Tell the system that the values of the dconf keys we've just set can no
    # longer be overridden by the user
    cat > "$POLICY_LOCK" <<END
/org/compiz/profiles/unity/plugins/unityshell
/org/compiz/profiles/unity-lowgfx/plugins/unityshell
END
fi

# Incorporate all of the text files we've just created into the system's dconf
# databases
dconf update
