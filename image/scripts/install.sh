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

gsettings set org.gnome.desktop.screensaver lock-enabled false

sudo apt-get update

sudo apt-get -y install git

# Grab the source code

git clone https://github.com/OS2borgerPC/image.git

# Go to the image folder

cd image

# Fetch changes

git fetch

# Go to the script folder

cd image/scripts

# Create standard OS2borgerPC setup

setup.sh

# Finalize the image

./finalize.sh

gsettings set org.gnome.desktop.screensaver lock-enabled true

# Now reboot.

sudo reboot

