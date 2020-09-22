#!/usr/bin/env bash

# Setup the configuration we know to be necessary for this 
# computer to be "OS2borgerPC ready".

# Will execute the following steps:
# * Get the latest code from git
# * Overwrite file structure
# * Install packages
# * Create and setup user "user"
#
# The machine will now be a fully functional and standardized 
# OS2borgerPC computer.
#
# After running this script on a fresh Ubuntu install, you can
# customize it to your heart's content - change the wallpaper of the default
# user, add scripts, whatever. 

# Update package list and install git
export DEBIAN_FRONTEND=noninteractive

apt-get update

apt-get -y install git

# Grab the source code
git clone https://github.com/OS2borgerPC/image.git

pushd image/

# Fetch latest changes...
git fetch

# Create standard OS2borgerPC setup
image/scripts/os2borgerpc_setup.sh

# Finalize the image
image/scripts/finalize.sh

# Now reboot.
reboot

