#!/usr/bin/env bash

# SYNOPSIS
#    systemd_policy_cleanup.sh [ENFORCE]
#
# DESCRIPTION
#    This script installs a systemd unit that resets the contents of "user"'s
#    home directory at system startup and shutdown time.
#
#    It takes one optional parameter: whether or not to enforce this policy.
#    If this parameter is missing, empty, "false", or "falsk", the policy will
#    be removed; otherwise, it will be enforced.
#
#===============================================================
# IMPLEMENTATION
#    author          Alexander Faithfull
#    copyright       Copyright 2019, 2020 Magenta ApS
#    license         GNU General Public License, version 3 or later
#    email           af@magenta.dk

set -x

POLICY="/etc/systemd/system/os2borgerpc-cleanup.service"
UNIT="`basename "$POLICY"`"

if [ "$1" = "" -o "$1" = "false" -o "$1" = "falsk" ]; then
    if [ -f "$POLICY" ]; then
        systemctl stop "$UNIT" || true
        systemctl disable "$UNIT" || true
        rm -f "$POLICY"
    else
        # If the unit file didn't exist, then it can't have been enabled, so we
        # just stop here
        exit 0
    fi
else
    if [ ! -d "`dirname "$POLICY"`" ]; then
        mkdir "`dirname "$POLICY"`"
    fi

    cat > "$POLICY" <<END
[Unit]
Description=OS2borgerPC user directory cleanup

[Service]
Type=oneshot
ExecStart=/usr/share/os2borgerpc/bin/user-cleanup.bash
RemainAfterExit=yes
ExecStop=/usr/share/os2borgerpc/bin/user-cleanup.bash

[Install]
WantedBy=multi-user.target
END
fi

# Tell systemd about this change in the unit file set
systemctl daemon-reload
systemctl reset-failed

if [ -f "$POLICY" ]; then
    systemctl enable "$UNIT"
    systemctl start "$UNIT"
fi
