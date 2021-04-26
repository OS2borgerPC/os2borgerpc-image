#! /usr/bin/env sh

set -ex

# Enable / Disable network printer discovery.
# "til" enables network printer discovery, "fra" disables it.
# As a side effect all network printers previously found are removed 
# and any you want, have to be added manually.
# Log out or restart if changes don't take immediate effect.

# Author: mfm@magenta.dk

TIL_FRA=$1

CUPS_CONFIG=/etc/cups/cups-browsed.conf

if [ "$TIL_FRA" = "til" ]; then
  sed -i 's,BrowseProtocols none,# BrowseProtocols none,' $CUPS_CONFIG
elif [ "$TIL_FRA" = "fra" ]; then
  sed -i 's,# BrowseProtocols none,BrowseProtocols none,' $CUPS_CONFIG
else
  printf  '%s\n' 'Du skal specificere "til" eller "fra". Annullerer.'
  exit 1
fi

# Restarting cups shouldn't be necessary for changes to take effect:
# systemctl restart cups-browsed cups
