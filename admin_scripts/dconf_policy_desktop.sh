#!/usr/bin/env bash

#================================================================
#% SYNOPSIS
#+    dconf_policy_desktop.sh [FILE]
#%
#% DESCRIPTION
#%    This script changes and locks the desktop background for all users on the
#%    system using a dconf lock.
#%
#%    It takes one optional parameter: the path to the desktop background. If
#%    this parameter is missing or empty, any existing background lock will be
#%    removed.
#%
#================================================================
#- IMPLEMENTATION
#-    version         dconf_policy_desktop.sh (magenta.dk) 1.0.0
#-    author          Alexander Faithfull
#-    copyright       Copyright 2019, Magenta ApS
#-    license         GNU General Public License
#-    email           af@magenta.dk
#-
#================================================================
#  HISTORY
#     2019/09/24 : af : Script created
#
#================================================================
# END_OF_HEADER
#================================================================

set -x

POLICY="/etc/dconf/db/os2borgerpc.d/00-background"
POLICY_LOCK="/etc/dconf/db/os2borgerpc.d/locks/background"

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

    # Copy the new desktop background into the appropriate folder
    LOCAL_PATH="/usr/share/backgrounds/`basename "$1"`"
    cp "$1" "$LOCAL_PATH"

    cat > "$POLICY" <<END
[org/gnome/desktop/background]
picture-uri='file://$LOCAL_PATH'
picture-options='zoom'
END
    # "dconf update" will only act if the content of the keyfile folder has
    # changed: individual files changing are of no consequence. Force an update
    # by changing the folder's modification timestamp
    touch "`dirname "$POLICY"`"

    # Tell the system that the values of the dconf keys we've just set can no
    # longer be overridden by the user
    cat > "$POLICY_LOCK" <<END
/org/gnome/desktop/background/picture-uri
/org/gnome/desktop/background/picture-options
END
fi

# Incorporate all of the text files we've just created into the system's dconf
# databases
dconf update
