#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    furesoe_princh_install.sh
#%
#% DESCRIPTION
#%    This script installs and setup the princh client.
#%
#================================================================
#- IMPLEMENTATION
#-    version         furesoe_princh_install (magenta.dk) 0.0.1
#-    author          Danni Als
#-    copyright       Copyright 2018, Magenta Aps"
#-    license         GNU General Public License
#-    email           danni@magenta.dk
#-
#================================================================
#  HISTORY
#     2018/19/01 : danni : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================

if [ $# -ne 3 ]
then
    echo "This job takes exactly three parameters."
    exit -1
fi

add-apt-repository -y ppa:princh/experimental
apt-get update
apt-get install -y princh

HIDDEN_DIR=/home/.skjult

ln -s /usr/share/applications/com-princh-print-daemon.desktop $HIDDEN_DIR/.config/autostart/

PRINTER_NAME=$1
PRINTER_ID=$2
DESCRIPTION='"'$3'"'

lpadmin -p $PRINTER_NAME -v princh:$PRINTER_ID -D "$DESCRIPTION" -E -P /usr/share/ppd/princh/princh.ppd
