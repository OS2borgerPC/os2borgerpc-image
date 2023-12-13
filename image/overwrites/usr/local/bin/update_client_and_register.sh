#!/usr/bin/env bash

if [ "$(id -u)" != "0" ]; then
  echo "Critical error. Halting registration: This program must be run as root"
  exit 1
fi

if ! grep --quiet "_os_name" "/etc/os2borgerpc/os2borgerpc.conf"; then
  echo "Updating OS2borgerPC-client. This should only take a moment."
  pip install --upgrade os2borgerpc-client &> /dev/null
fi

/usr/local/bin/register_new_os2borgerpc_client.sh
