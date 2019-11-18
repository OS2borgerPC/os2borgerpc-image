#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    remove_update_notifier.sh
#%
#% DESCRIPTION
#%    This is script removes the Ubuntu update notifier message.
#%
#================================================================
#- IMPLEMENTATION
#-    version         remove_update_notifier (magenta.dk) 0.0.1
#-    author          Danni Als
#-    copyright       Copyright 2019, Magenta Aps"
#-    license         GNU General Public License
#-    email           danni@magenta-aps.dk
#-
#================================================================
#  HISTORY
#     2019/18/11 : danni : Script was created a long time ago.
#                          I just changed the logic so the package update notifier is removed instead.
#
#================================================================
# END_OF_HEADER
#================================================================
set -e

export DEBIAN_FRONTEND=noninteractive

apt-get -y remove --purge --autoremove update-notifer
apt-get -y autoremove
apt-get -y clean