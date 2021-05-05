#! /usr/bin/env sh

set -ex

# Enable / Disable network printer discovery.
# "til" enables network printer discovery, "fra" disables it.
# As a side effect all network printers previously found are removed 
# and any you want, have to be added manually.
# Log out or restart if changes don't take immediate effect.

# Author: mfm@magenta.dk

lower() {
    echo "$@" | tr '[:upper:]' '[:lower:]'
}

ACTIVATE="$(lower "$1")"

CUPS_CONFIG=/etc/cups/cups-browsed.conf

if [ "$ACTIVATE" != 'false' ] && [ "$ACTIVATE" != 'falsk' ] || \
   [ "$ACTIVATE" != 'no' ] && [ "$ACTIVATE" != 'nej' ]; then
  sed -i 's,BrowseProtocols none,# BrowseProtocols none,' $CUPS_CONFIG
else # Disable network printer discovery
  sed -i 's,# BrowseProtocols none,BrowseProtocols none,' $CUPS_CONFIG
fi

# Restarting cups to reduce the chances of needing the restart:
systemctl restart cups-browsed cups
