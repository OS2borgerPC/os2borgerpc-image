#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    suppress-shutdown.sh
#%
#% DESCRIPTION
#%    Hides the "Shutdown" and "Restart" options from the Ubuntu
#%    session menu.
#%
#================================================================
#- IMPLEMENTATION
#-    version         suppress-shutdown.sh (magenta.dk) 0.0.1
#-    author          Alexander Faithfull
#-    copyright       Copyright 2018, Magenta ApS
#-    license         GNU General Public License
#-    email           af@magenta.dk
#-
#================================================================
#  HISTORY
#     2018/12/11 : af : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================

NEWUSER=user
HIDDEN_HOME=/home/.skjult
WAS_LOGGED_IN="$(who | cut -f 1 -d ' ' | sort | uniq | grep -w "$NEWUSER")"

if [ "$OS2BC_PHASE" = "" ]; then
    # Running as root
    echo "Impersonating $NEWUSER ($WAS_LOGGED_IN)"
    export "OS2BC_PHASE=1"
    # Start this script again in the user's context...
    su "$NEWUSER" --shell /bin/bash -- "$0" "$@" || exit "$?"

    # ... and, if it succeeded, copy over the updated dconf database
    cp "/home/$NEWUSER/.config/dconf/user" "$HIDDEN_HOME/.config/dconf"
elif [ "$OS2BC_PHASE" = "1" ]; then
    # Running as the user in a new session
    echo "I am now `whoami`"

    # If the user was logged in, then assume there's a D-Bus session associated
    # with that session, and try to use that; otherwise, make a new one
    export "OS2BC_PHASE=2"
    if [ "$WAS_LOGGED_IN" ]; then
        export DISPLAY=:0.0
        export "XAUTHORITY=/home/$NEWUSER/.Xauthority"
        exec /bin/bash "$0" "$@"
    else
        exec dbus-launch --exit-with-session "$0" "$@"
    fi
elif [ "$OS2BC_PHASE" = "2" ]; then
    # Running as the user, and we *should* either have a D-Bus session bus or
    # an X session that we can use to find one

    # Make sure that errors are correctly propagated back up
    set -e

    for gsv in \
            suppress-shutdown-menuitem \
            suppress-restart-menuitem; do
        gsettings set com.canonical.indicator.session "$gsv" true
    done
fi