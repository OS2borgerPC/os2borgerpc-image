#! /usr/bin/env sh

# Chrome launch maximized by default
# Arguments:
# 1: 'false/falsk/no/nej' disables maximizing by default, anything else enables it.

# Author: mfm@magenta.dk

lower() {
    echo "$@" | tr '[:upper:]' '[:lower:]'
}

ACTIVATE="$(lower "$1")"

DESKTOP_FILE_PATH=/usr/share/applications/google-chrome.desktop

if [ "$ACTIVATE" != 'false' ] && [ "$ACTIVATE" != 'falsk' ] && \
   [ "$ACTIVATE" != 'no' ] && [ "$ACTIVATE" != 'nej' ]; then
  # Don't add --start-maximized multiple times
  if ! grep -q -- '--start-maximized' $DESKTOP_FILE_PATH; then
    sed -i 's,\(Exec=/usr/bin/google-chrome-stable\)\(.*\),\1 --start-maximized\2,' $DESKTOP_FILE_PATH
  fi
else
  sed -i 's/ --start-maximized//g' $DESKTOP_FILE_PATH
fi
