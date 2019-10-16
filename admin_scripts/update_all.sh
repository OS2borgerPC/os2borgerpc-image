#!/usr/bin/env bash

#================================================================
#% SYNOPSIS
#+    update_all.sh
#%
#% DESCRIPTION
#%    This script updates all apt repositories and then applies all available
#%    upgrades, picking default values for all debconf questions. It takes no
#%    parameters.
#%
#================================================================
#- IMPLEMENTATION
#-    version         update_all.sh (magenta.dk) 1.0.0
#-    author          Alexander Faithfull
#-    copyright       Copyright 2019, Magenta ApS
#-    license         GNU General Public License
#-    email           af@magenta.dk
#-
#================================================================
#  HISTORY
#     2019/07/16 : af : Script updated
#
#================================================================
# END_OF_HEADER
#================================================================

set -e

# Stop Debconf from doing anything
export DEBIAN_FRONTEND=noninteractive

apt-get update > /dev/null
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove
apt-get -y clean

