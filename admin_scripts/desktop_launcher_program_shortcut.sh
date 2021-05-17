#! /usr/bin/env sh

# Adds/Removes programs from the launcher (menu) in Ubuntu 20.04
# Author: mfm@magenta.dk

# Arguments:
# 1: Write 'tilfoj' to add the program, anything else to remove it.

lower() {
    echo "$@" | tr '[:upper:]' '[:lower:]'
}

PROGRAM="$(lower "$1")"

if [ "$PROGRAM" = "tilfoj" ]
then

  # Append the program specified above to the menu/launcher
  # Why ']? To not also match the first (title) line.
  sed -i "s/'\]/', '$PROGRAM'\]/" /etc/dconf/db/os2borgerpc.d/02-launcher-favorites

else

  # Remove the program specified above from the menu/launcher
  sed -i "s/, '$PROGRAM'//" /etc/dconf/db/os2borgerpc.d/02-launcher-favorites

fi

dconf update
