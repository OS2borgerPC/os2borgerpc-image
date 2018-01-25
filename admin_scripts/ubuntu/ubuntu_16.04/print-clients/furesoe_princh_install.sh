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
#     2018/22/01 : danni : Added -y to add-apt and apt-get install.
#     2018/22/01 : danni : Now checks if HIDDEN _DIR exists.
#
#================================================================
# END_OF_HEADER
#================================================================

if [ $# -ne 3 ]
then
    echo "This job takes exactly three parameters."
    exit -1
fi

apt-add-repository -y ppa:princh/experimental
apt-get update
apt-get install -y princh

echo 'Princh is installed.'

HIDDEN_DIR=/home/.skjult/.config/autostart/

if [ ! -d "$HIDDEN_DIR" ];then
    echo 'Creating dir autostart.'
    mkdir -p $HIDDEN_DIR
fi

ln -s /usr/share/applications/com-princh-print-daemon.desktop "$HIDDEN_DIR"

ls "$HIDDEN_DIR"

PRINTER_NAME=$1
PRINTER_ID=$2
DESCRIPTION='"'$3'"'

lpadmin -p "$PRINTER_NAME" -v princh:$PRINTER_ID -D "$DESCRIPTION" -E -P /usr/share/ppd/princh/princh.ppd

exit 0