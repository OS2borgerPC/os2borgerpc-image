#!/bin/sh

#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    install_hook_support.sh
#%
#% DESCRIPTION
#%    This script patches the OS2borgerPC job manager with support for running
#%    hook scripts before and after checking in with the administration system.
#%
#%    Newer versions of the OS2borgerPC client packages include this
#%    functionality by default. This script will do nothing in this case.
#%
#================================================================
#- IMPLEMENTATION
#-    version         install_hook_support.sh (magenta.dk) 1.0.0
#-    author          Alexander Faithfull
#-    copyright       Copyright 2021, Magenta ApS
#-    license         GNU General Public License
#-    email           af@magenta.dk
#-
#================================================================
#  HISTORY
#     2021/03/12 : af : Script created
#
#================================================================
# END_OF_HEADER
#================================================================

set -x

if [ ! -f "/usr/local/bin/jobmanager.real" ]; then
    mv -f /usr/local/bin/jobmanager /usr/local/bin/jobmanager.real
    cat <<"END" > /usr/local/bin/jobmanager
#!/bin/bash

if [ -d "/etc/os2borgerpc/pre-checkin.d" ]; then
    for i in "/etc/os2borgerpc/pre-checkin.d/"*; do
        test -x "$i" && \
                echo "$0: running pre-checkin script $i" && \
                "$i" pre-checkin
    done
fi

/usr/local/bin/jobmanager.real "$@"
STATUS="$?"

if [ -d "/etc/os2borgerpc/post-checkin.d" ]; then
    for i in "/etc/os2borgerpc/post-checkin.d/"*; do
        test -x "$i" && \
                echo "$0: running post-checkin script $i" && \
                "$i" post-checkin "$STATUS"
    done
fi
END
    chmod +x /usr/local/bin/jobmanager
    mkdir -p /etc/os2borgerpc/{pre,post}-checkin.d
fi
