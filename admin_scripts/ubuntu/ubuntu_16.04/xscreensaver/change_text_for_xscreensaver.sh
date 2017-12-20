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
#-    version         change_text_for_xscreensaver (magenta.dk) 0.1.0
#-    author          Danni Als
#-    copyright       Copyright 2017, Magenta Aps"
#-    license         GNU General Public License
#-    email           danni@magenta.dk
#-
#================================================================
#  HISTORY
#     2017/20/12 : danni : Is now checking if gltext is already set or not.
#     2017/19/12 : danni : Is making this script work.
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

#   GL: 				gltext -root -no-spin -text "Magenta"	    \n\

if [ -f $SCREENSAVER_FILE ]
then
    sed -i "/textMode/$TEXT_MODE_LINE" $SCREENSAVER_FILE
    # if gtext is present change it.
    if grep -q 'gltext' $SCREENSAVER_FILE
    then
        sed -i "s/\".*\"/\"$1\"/" $SCREENSAVER_FILE
        echo 'gltext is updated'
        exit 0
    else
        # if not, add it
        GLTEXT="GL: 				gltext -root -no-spin -text \"$1\"	    \n\\"
        sed -i "/flipscreen3d -root/ a $GLTEXT" $SCREENSAVER_FILE
        echo 'New gltext added.'
        exit 0
    fi
else
    echo 'No xscreensaver file present.'
    exit -1
fi