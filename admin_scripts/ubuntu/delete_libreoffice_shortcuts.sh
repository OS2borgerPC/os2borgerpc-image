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
#     2019/30/10 : danni : Simplified removal of the three files
#
#================================================================
# END_OF_HEADER
#================================================================

set -e

rm "/home/.skjult/Skrivebord/calc.desktop"
rm "/home/.skjult/Skrivebord/writer.desktop"
rm "/home/.skjult/Skrivebord/impress.desktop"

exit 0
