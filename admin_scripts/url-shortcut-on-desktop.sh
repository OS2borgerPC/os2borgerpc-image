#! /usr/bin/env sh

# Creates a customly named shortcut on the desktop for the normal user, which 
# opens the URL given as an argument in the default browser.
#
# After the script has run log out or restart the computer for the changes to
# take effect.
#
# Dev note: If wanting to globally change the icon used look into 
# shellscripts.png and application-x-shellscript.png 
# within /usr/share/icons/Yaru/
#
# Arguments:
# 1: ACTIVATE: Add or remove the shortcut. false/false/no/nej removes it, 
#              anything else adds it.
# 2: URL: The URL to visit when clicked
# 3: NAME: The name the shortcut should have - it needs to be a valid filename!
#
# Author: mfm@magenta.dk

lower() {
    echo "$@" | tr '[:upper:]' '[:lower:]'
}

ACTIVATE="$(lower "$1")"
URL=$2
NAME=$3

SHADOW=".skjult"
FILE="/home/$SHADOW/Skrivebord/$NAME"

if [ "$ACTIVATE" != 'false' ] && [ "$ACTIVATE" != 'falsk' ] && \
   [ "$ACTIVATE" != 'no' ] && [ "$ACTIVATE" != 'nej' ]; then
cat << EOF > "$FILE"
#! /usr/bin/env sh
xdg-open "$URL"
EOF

chmod +x "$FILE"
else
  rm "$FILE"
fi
