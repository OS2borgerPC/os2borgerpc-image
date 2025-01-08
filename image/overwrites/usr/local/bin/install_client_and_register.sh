#!/usr/bin/env bash

if [ "$(id -u)" != "0" ]; then
  echo "Critical error. Halting registration: This program must be run as root"
  exit 1
fi

# install os2borgerpc-client
/usr/local/bin/install_client.sh

# Register 
/usr/local/bin/register_new_os2borgerpc_client.sh
