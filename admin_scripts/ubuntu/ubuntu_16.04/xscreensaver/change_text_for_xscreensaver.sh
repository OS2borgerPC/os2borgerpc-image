#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    change_text_for_xscreensaver args Text to show
#%
#% DESCRIPTION
#%    This changes the text shown for the xscreensaver.
#%    This script demands that the .xscreensaver file is present in the .skjult folder.
#%
#================================================================
#- IMPLEMENTATION
#-    version         change_text_for_xscreensaver (magenta.dk) 0.0.1
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

SCREENSAVER_FILE="/home/.skjult/.xscreensaver"

TEXT_MODE_LINE='textMode:       literal'
TEXT_LITERAL='''textLiteral:    '$1''


if [ -f $SCREENSAVER_FILE ]
then
    sed -i "/textMode/c$TEXT_MODE_LINE" $SCREENSAVER_FILE
    sed -i "/textLiteral/c$TEXT_MODE_LINE" $SCREENSAVER_FILE
else
    echo 'No xscreensaver file present.'
fi