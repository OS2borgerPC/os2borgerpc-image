#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    ${SCRIPT_NAME} [-hv] [-o[file]] args ...
#%
#% DESCRIPTION
#%    This is a script template
#%    to start any good shell script.
#%
#================================================================
#- IMPLEMENTATION
#-    version         ${SCRIPT_NAME} (magenta.dk) 0.0.1
#-    author          ${NAME}
#-    copyright       Copyright 2018, Magenta Aps"
#-    license         GNU General Public License
#-    email           ${EMAIL}
#-
#================================================================
#  HISTORY
#     2017/06/10 : danni : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================

# This script will change the name of the computer, it will not
# change how it looks in the admin. There will be no validation that this parameter is a valid name.

if [ $# -ne 1 ]
then
    echo "This script takes exactly one argument."
    exit -1
fi

NEW_NAME=$1
PREFS_FILE=/etc/hosts
STARTPAGE_PREFS_LINE="127.0.1.1 $NEW_NAME"
OLD_LINE=$(grep 127.0.1.1 /etc/hosts)
hostname $NEW_NAME

# Replace old line with new
sed -i "s/$OLD_LINE/$STARTPAGE_PREFS_LINE/g" $PREFS_FILE


