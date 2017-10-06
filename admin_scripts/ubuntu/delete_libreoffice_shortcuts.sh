#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    delete_libre_office_shortcuts.sh
#%
#% DESCRIPTION
#%    Deletes all libreoffice shortcuts for user.
#%
#================================================================
#- IMPLEMENTATION
#-    version         delete_libre_office_shortcuts (magenta.dk) 0.0.1
#-    author          Danni Als
#-    copyright       Copyright 2017, Magenta Aps"
#-    license         GNU General Public License
#-    email           danni@magenta.dk
#-
#================================================================
#  HISTORY
#     2017/06/10 : danni : Added header
#
#================================================================
# END_OF_HEADER
#================================================================

CALCDESKTOP="/home/.skjult/Desktop/calc.desktop"

if [ -f $CALCDESKTOP ]
then
    rm -f "/home/.skjult/Desktop/calc.desktop"
else
    echo "File does not exist"
    exit -1
fi

WRITERDESKTOP="/home/.skjult/Desktop/writer.desktop"

if [ -f $WRITERDESKTOP ]
then
    rm -f "/home/.skjult/Desktop/writer.desktop"
else
    echo "File does not exist"
    exit -1
fi

IMPRESSDESKTOP="/home/.skjult/Desktop/impress.desktop"

if [ -f $IMPRESSDESKTOP ]
then
    rm -f "/home/.skjult/Desktop/impress.desktop"
else
    echo "File does not exist"
    exit -1
fi

exit 0
