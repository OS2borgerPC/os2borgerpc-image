#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    install_security_scripts.sh
#%
#% DESCRIPTION
#%    This script enables an already running OS2BorgerPC to become
#%    security surveillance ready. It creates the missing folder and scripts
#%    and updates the bibos client to the latest version.
#%
#================================================================
#- IMPLEMENTATION
#-    version         install_security_scripts.sh (magenta.dk) 0.0.1
#-    author          Danni Als
#-    copyright       Copyright 2017, Magenta Aps"
#-    license         GNU General Public License
#-    email           danni@magenta-aps.dk
#-
#================================================================
#  HISTORY
#     2017/06/10 : danni : Script creation
#     2018/16/01 : danni : Security dir is deleted if it already exists.
#
#================================================================
# END_OF_HEADER
#================================================================

SECURITY_SCRIPT_HOME=/etc/bibos/security

if [ -d "$SECURITY_SCRIPT_HOME" ];then
  rm -R $SECURITY_SCRIPT_HOME
fi

mkdir -p $SECURITY_SCRIPT_HOME

cd $SECURITY_SCRIPT_HOME

# Get latest files from github.
wget https://raw.githubusercontent.com/magenta-aps/bibos_image/master/image/overwrites/etc/bibos/security/csv_writer.py

wget https://raw.githubusercontent.com/magenta-aps/bibos_image/master/image/overwrites/etc/bibos/security/log_read.py

ls

pip install --upgrade bibos_client