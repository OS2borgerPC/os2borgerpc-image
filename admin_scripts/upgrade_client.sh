#!/bin/bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    upgrade-client.sh
#%
#% DESCRIPTION
#%    This script updates the OS2borgerPC client package  to the
#%    latest version available on PyPI. It takes no
#%    parameters.
#%
#================================================================
#- IMPLEMENTATION
#-    version         upgrade-client.sh (magenta.dk) 1.0.0
#-    author          Carsten Agger
#-    copyright       Copyright 2019, Magenta ApS
#-    license         GNU General Public License
#-    email           af@magenta.dk
#-
#================================================================
#  HISTORY
#     2019/02/20 : af : Script created
#     2021/05/07 : af : Script created for Ubuntu 20.04.
#
#================================================================
# END_OF_HEADER
#================================================================

pip3 install --upgrade os2borgerpc-client

