#!/usr/bin/env bash

# Setup the configuration we know to be necessary for this 
# computer to be "OS2borgerPC ready".

# Will execute the following steps:
# * Overwrite file structure
# * Install packages
# * Create and setup user "user"
#
# The machine will now be a fully functional and standardized 
# OS2borgerPC computer which is not, however, registered with the admin
# system nor endowed with local settings such as printers, etc.
#
# After running this script on a fresh Ubuntu install, you can
# customize it to your heart's content - change the wallpaper of the default
# user, add scripts, whatever. Once you're done customizing, please call the
# *finalize* script to launch the setup script on first boot.
# When this is done, the image can be cloned and packed with Clonezilla
# and/or be made available for Clonezilla network installation.

DIR=$(dirname ${BASH_SOURCE[0]})

# Overwrite file tree.
"$DIR/do_overwrite.sh"

# Install all necessary packages and dependencies
$DIR/install_dependencies.sh

# Setup default user
useradd user -m -p 12345 -s /bin/bash -U
chfn -f Borger user
adduser user nopasswdlogin

# Disable showing shortcuts UI for user Borger
HOME=/home/user/
HIDDEN_DIR=/home/.skjult
mkdir -p "$HOME"/.cache/unity
touch "$HOME"/.cache/unity/first_run.stamp

mkdir -p "$HIDDEN_DIR"/.cache/unity

cp "$HOME"/.cache/unity/first_run.stamp "$HIDDEN_DIR"/.cache/unity/first_run.stamp

# Make now first boot
touch /etc/bibos/firstboot

# Prepare to run jobs
mkdir -p /var/lib/bibos/jobs
chmod -R og-r /var/lib/bibos

# Prepare to run security events
SECURITY_DIR=/etc/bibos/security/
mkdir -p /etc/bibos/security/
cp -R "$DIR"/script-data/security/* "$SECURITY_DIR"

# Set version in configuration
VERSION=$(cat ../../VERSION)
set_bibos_config bibos_version "$VERSION"

mv /tmp/$OVERRIDE_FILE /usr/share/glib-2.0/schemas
glib-compile-schemas /usr/share/glib-2.0/schemas/

# Securing grub
"$DIR/../../admin_scripts/image_core/grub_set_password.py" $(pwgen -N 1 -s 12)
