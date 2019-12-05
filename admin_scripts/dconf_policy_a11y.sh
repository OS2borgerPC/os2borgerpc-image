#!/usr/bin/env bash

#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    dconf_policy_a11y.sh [ENFORCE]
#%
#% DESCRIPTION
#%    This script installs a policy that forces the Universal Access menu to be
#%    shown at all times.
#%
#%    It takes one optional parameter: whether or not to enforce this policy.
#%    If this parameter is missing, empty, or "false", the policy will be
#%    removed; otherwise, it will be enforced.
#%
#================================================================
#- IMPLEMENTATION
#-    version         dconf_policy_a11y.sh (magenta.dk) 1.0.0
#-    author          Alexander Faithfull
#-    copyright       Copyright 2019, Magenta ApS
#-    license         GNU General Public License
#-    email           af@magenta.dk
#-
#================================================================
#  HISTORY
#     2019/09/25 : af : dconf_policy_shutdown.sh created
#     2019/12/05 : af : This script created based on dconf_policy_shutdown.sh
#
#================================================================
# END_OF_HEADER
#================================================================

set -x

POLICY="/etc/dconf/db/os2borgerpc.d/00-accessibility"
POLICY_LOCK="/etc/dconf/db/os2borgerpc.d/locks/accessibility"

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

    # dconf does not, by default, require the use of a system database, so
    # add one (called "os2borgerpc") to store our system-wide settings in
    cat > "/etc/dconf/profile/user" <<END
user-db:user
system-db:os2borgerpc
END

    cat > "$POLICY" <<END
[org/gnome/desktop/a11y]
always-show-universal-access-status=true
END
    # "dconf update" will only act if the content of the keyfile folder has
    # changed: individual files changing are of no consequence. Force an update
    # by changing the folder's modification timestamp
    touch "`dirname "$POLICY"`"

    # Tell the system that the values of the dconf keys we've just set can no
    # longer be overridden by the user
    cat > "$POLICY_LOCK" <<END
/org/gnome/desktop/a11y/always-show-universal-access-status
END
fi

# Incorporate all of the text files we've just created into the system's dconf
# databases
dconf update
