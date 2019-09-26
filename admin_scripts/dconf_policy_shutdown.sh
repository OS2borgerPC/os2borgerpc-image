#!/usr/bin/env bash

#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    dconf_policy_shutdown.sh [ENFORCE]
#%
#% DESCRIPTION
#%    This script removes the shutdown and restart options from the Ubuntu
#%    session indicator for all users using a dconf lock.
#%
#%    It takes one optional parameter: whether or not to enforce this policy.
#%    If this parameter is missing, empty, or "false", the policy will be
#%    removed; otherwise, it will be enforced.
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
#     2019/09/25 : af : Script created
#
#================================================================
# END_OF_HEADER
#================================================================

set -x

POLICY="/etc/dconf/db/os2borgerpc.d/00-shutdown"
POLICY_LOCK="/etc/dconf/db/os2borgerpc.d/locks/shutdown"

if [ "$1" = "" -o "$1" = "false" ]; then
    rm -f "$POLICY"
    rm -f "$POLICY_LOCK"
else
    if [ ! -d "`dirname "$POLICY"`" ]; then
        mkdir "`dirname "$POLICY"`"
    fi
    if [ ! -d "`dirname "$POLICY_LOCK"`" ]; then
        mkdir "`dirname "$POLICY_LOCK"`"
    fi

    cat > "/etc/dconf/profile/user" <<END
user-db:user
system-db:os2borgerpc
END

    cat > "$POLICY" <<END
[apps/indicator-session]
suppress-restart-menuitem=true
suppress-shutdown-menuitem=true
END
    # "dconf update" will only act if the content of the keyfile folder has
    # changed: individual files changing are of no consequence. Force an update
    # by changing the folder's modification timestamp
    touch "`dirname "$POLICY"`"

    cat > "$POLICY_LOCK" <<END
/apps/indicator-session/suppress-restart-menuitem
/apps/indicator-session/suppress-shutdown-menuitem
END
fi

dconf update
