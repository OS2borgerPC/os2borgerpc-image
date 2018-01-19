#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    install_security_scripts_aarhus.sh
#%
#% DESCRIPTION
#%    This script enables an already running OS2BorgerPC to become
#%    security surveillance ready. It creates the missing folder and scripts
#%    and updates the bibos client to the latest version.
#%    As Aarhus network is very restricted we have to provide them with a special version of this script,
#%    where you have to provide the correct security files as arguments.
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
#     2018/18/01 : danni : Special copy for Aarhus, due to their network restrictions.
#
#================================================================
# END_OF_HEADER
#================================================================

CSV_WRITER=$1

if [ ! -f $CSV_WRITER ]
then
    echo "No such file: $CSV_WRITER"
    echo "Please supply a path to an existing image file"
    exit -1
fi

LOG_READER=$2

if [ ! -f $LOG_READER ]
then
    echo "No such file: $LOG_READER"
    echo "Please supply a path to an existing image file"
    exit -1
fi

SECURITY_SCRIPT_HOME=/etc/bibos/security

if [ -d "$SECURITY_SCRIPT_HOME" ];then
  rm -R $SECURITY_SCRIPT_HOME
fi

mkdir -p $SECURITY_SCRIPT_HOME

CSV_WRITER_FULL_PATH="$SECURITY_SCRIPT_HOME"/"$(basename "$CSV_WRITER")"

cp "$CSV_WRITER" "$CSV_WRITER_FULL_PATH"

LOG_READER_FULL_PATH="$SECURITY_SCRIPT_HOME"/"$(basename "$LOG_READER")"

cp "$LOG_READER" "$LOG_READER_FULL_PATH"

ls $SECURITY_SCRIPT_HOME

# pip install --upgrade bibos_client