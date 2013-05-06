#!/usr/bin/env bash

# This file will finalize the BibOS installation by installing the things which
# could not be preinstalled on the BibOS image. 
# This includes:
#
# * Printer and other hardware setup
# * Proprietary packages which we're not allowed to distribute
# * Registration to admin system.
# 
# This script REQUIRES AN INTERNET CONNECTION!

# The script should be run as a sudo-enabled user - not directly as root.


# Printer setup
sudo system-config-printer


# Proprietary stuff

zenity --info --text="Will now install proprietary and restricted systems"

sudo apt-get install ubuntu-restricted-extras
