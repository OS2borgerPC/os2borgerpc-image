#! /usr/bin/env sh

# Adds/Removes programs from the launcher (menu) in Ubuntu 20.04
# Author: mfm@magenta.dk
#
# Arguments:
# 1: Write 'nej', 'no', 'falsk' og 'false' to remove the program shortcut,
#    anything else to add it.
# 2: The name of the program you want to add/remove.

lower() {
    echo "$@" | tr '[:upper:]' '[:lower:]'
}

ACTIVATE="$(lower "$1")"
PROGRAM=$2

if [ "$ACTIVATE" != 'false' ] && [ "$ACTIVATE" != 'falsk' ] || \
   [ "$ACTIVATE" != 'no' ] && [ "$ACTIVATE" != 'nej' ]; then

  # Append the program specified above to the menu/launcher
  # Why ']? To not also match the first (title) line.
  sed -i "s/'\]/', '$PROGRAM'\]/" /etc/dconf/db/os2borgerpc.d/02-launcher-favorites

else

  # Remove the program specified above from the menu/launcher
  sed -i "s/, '$PROGRAM'//" /etc/dconf/db/os2borgerpc.d/02-launcher-favorites

fi

dconf update
