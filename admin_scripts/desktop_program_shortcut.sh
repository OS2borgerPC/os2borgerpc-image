#! /usr/bin/env sh

# Adds/Removes programs from the desktop in Ubuntu 20.04
# Author: mfm@magenta.dk

# Note that the program assumes danish locale, where the 'Desktop' directory 
# is instead named 'Skrivebord'.

# Arguments:
# 1: This argument should specify the name of a program (.desktop-file) 
# under /usr/share/applications/

lower() {
    echo "$@" | tr '[:upper:]' '[:lower:]'
}

PROGRAM="$(lower "$1")"
SLET="$(lower "$2")"

SHADOW=.skjult

if [ "$SLET" = "slet" ]
then
  echo "Forsøger at slette programmet $PROGRAM"
  rm "/home/$SHADOW/Skrivebord/$PROGRAM.desktop"
  exit $?
fi

cp "/usr/share/applications/$PROGRAM.desktop" /home/$SHADOW/Skrivebord/
