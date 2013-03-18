#!/bin/bash
# this wrapper resets the BibOS postinstall procedure
COMMAND='cp /usr/local/bin/bibos-postinstall.desktop /etc/xdg/autostart/'
gksu $COMMAND