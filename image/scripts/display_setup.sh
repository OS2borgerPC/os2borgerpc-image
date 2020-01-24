#!/bin/bash

# This script is intended for distribution directly to the customer.
# When properly tested it may also be preseeded to the custom
# OS2Display Server installation. But alternatively, it can be sent to
# the customer by mail etc.

# Use tmp directory for installation files.
IMAGE=/tmp/image_install
# Get the main install scripts
git clone https://github.com/os2borgerpc/image $IMAGE
pushd $IMAGE/image/scripts

sudo ./os2display_server_setup.sh
popd
rm -rf $IMAGE

