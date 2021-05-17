#! /usr/bin/env sh

# Lists programs available, programs on the desktop or in the launcher
# Author: mfm@magenta.dk
#
# Arguments
# 1: Default is to print programs available. Write 'skrivebord' to print
# programs already on the desktop.

lower() {
    echo "$@" | tr '[:upper:]' '[:lower:]'
}

DESKTOP="$(lower "$1")"

USER=user

if [ "$DESKTOP" = "menu" ];
then
  # Print only the last line only and format it a bit more nicely
  tail -n 1 /etc/dconf/db/os2borgerpc.d/02-launcher-favorites | sed "s/favorite-apps=\[\|'\|\]//g" | tr ',' '\n'
  exit
elif [ "$DESKTOP" = "skrivebord" ]
then
  PTH="/home/$USER/Skrivebord"
else
  PTH=/usr/share/applications/
fi

ls -l $PTH
