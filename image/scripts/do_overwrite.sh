#!/usr/bin/env bash

printf "\n\n%s\n\n" "===== RUNNING: $0 ====="

if [ -z $1 ]
then
    DESTINATION='/'
else
    DESTINATION=$1
fi

# Now do the deed
DIR=$(dirname $(realpath $0 ))
cp -r "$DIR"/../overwrites/* $DESTINATION

# Permissions fixup
chmod 0440 ${DESTINATION}etc/sudoers.d/keep-proxy
chmod 0400 ${DESTINATION}home/.skjult/.local/share/keyrings/Standardnøglering.keyring
chown -R superuser:superuser /home/superuser

# Update dconf with settings from overwrites.
dconf update
