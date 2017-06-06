#!/usr/bin/env bash

# Setup the configuration we know to be necessary for this 
# computer to be "BibOS ready".

# Will execute the following steps:
# * Get the latest code from git
# * Overwrite file structure
# * Install packages
# * Create and setup user "user"
#
# The machine will now be a fully functional and standardized 
# BibOS computer.
#
# After running this script on a fresh Ubuntu install, you can
# customize it to your heart's content - change the wallpaper of the default
# user, add scripts, whatever. 

# Update package list and install git

gsettings set org.gnome.desktop.screensaver lock-enabled false

sudo apt-get update

sudo apt-get -y install git

# Grab the source code

git clone https://github.com/magenta-aps/bibos_image.git

# Go to the bibos_image folder

cd bibos_image

# Fetch changes

git fetch

# Switch branch - Only for testing purposes.

git checkout feature/18082_change_user_name

# Go to the script folder

cd image/scripts

# Create standard BibOS setup

./bibos_setup.sh

# Finalize the image

./finalize.sh

gsettings set org.gnome.desktop.screensaver lock-enabled true

# Now reboot.

sudo reboot

