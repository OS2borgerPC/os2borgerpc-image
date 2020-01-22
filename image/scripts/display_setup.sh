#!/bin/bash

# This script is intended for distribution directly to the customer.
# When properly tested it may also be preseeded to the custom
# OS2Display Server installation. But alternatively, it can be sent to
# the customer by mail etc.

# Get the main install scripts
git clone https://github.com/os2borgerpc/image
pushd image/image/scripts
# Delete this line when the code is merged
git checkout feature/33101_borgerpc_server
sudo ./os2display_server_setup.sh
popd
rm -rf image

