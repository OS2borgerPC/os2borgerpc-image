#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    change_time_for_xscreensaver args Time in minutes
#%
#% DESCRIPTION
#%    This changes the text shown for the xscreensaver.
#%    This script demands that the .xscreensaver file is present in the .skjult folder.
#%
#================================================================
#- IMPLEMENTATION
#-    version         change_time_for_xscreensaver (magenta.dk) 0.0.1
#-    author          Danni Als
#-    copyright       Copyright 2017, Magenta Aps"
#-    license         GNU General Public License
#-    email           danni@magenta.dk
#-
#================================================================
#  HISTORY
#     2017/02/11 : danni : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================

if [ $# -ne 1 ]
then
	echo "This job takes exactly one parameter."
	exit -1
fi

TIME=$1

echo "$TIME in minutes"

if [ -z "${TIME##+([0-9])}" ]
then
    echo "Input has to be a number."
    exit -1
fi

SCREENSAVER_FILE="/home/.skjult/.xscreensaver"

if [ -f $SCREENSAVER_FILE ]
then
    TIMEOUT_LINE='''timeout:        0:'$TIME':00'''
    sed -i "/timeout/c$TIMEOUT_LINE" $SCREENSAVER_FILE
else
    echo 'No xscreensaver file present.'
fi