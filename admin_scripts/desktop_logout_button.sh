#! /usr/bin/env sh

# Author: mfm@magenta.dk
# Credits: Vordingborg Kommune
#
# Arguments:
# 1: Whether to add or delete the shortcut from the desktop.
#    'nej' or 'falsk' removes it.
# 2: The name the button should have on the desktop. 
#    If you choose deletion, the contents of the name argument does not matter.

lower() {
    echo "$@" | tr '[:upper:]' '[:lower:]'
}

ACTIVATE="$(lower "$1")"
NAME=$2

FILE_PATH=/home/.skjult/Skrivebord/Logout.desktop

if [ "$ACTIVATE" != 'false' ] && [ "$ACTIVATE" != 'falsk' ] && \
   [ "$ACTIVATE" != 'no' ] && [ "$ACTIVATE" != 'nej' ]; then
cat << EOF > $FILE_PATH
[Desktop Entry]
Version=1.0
Type=Application
Name=$NAME
Comment=Logout-funktion
Icon=application-exit
Exec=gnome-session-quit --logout --no-prompt
EOF

else
  rm "$FILE_PATH"
fi
