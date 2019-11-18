#!/usr/bin/env bash

# Setup the configuration we know to be necessary for this 
# computer to be "BibOS ready".

# Will execute the following steps:
# * Overwrite file structure
# * Install packages
# * Create and setup user "user"
#
# The machine will now be a fully functional and standardized 
# BibOS computer which is not, however, registered with the admin 
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
sudo "$DIR/do_overwrite.sh"


# Install all necessary packages and dependencies
$DIR/install_dependencies.sh

# Setup default user
sudo useradd user -m -p 12345 -s /bin/bash -U
sudo chfn -f Borger user
sudo adduser user nopasswdlogin

# Disable showing shortcuts UI for user Borger
HOME=/home/user/
HIDDEN_DIR=/home/.skjult
sudo mkdir -p "$HOME"/.cache/unity
sudo touch "$HOME"/.cache/unity/first_run.stamp

sudo mkdir -p "$HIDDEN_DIR"/.cache/unity

sudo cp "$HOME"/.cache/unity/first_run.stamp "$HIDDEN_DIR"/.cache/unity/first_run.stamp

# Make now first boot
sudo touch /etc/bibos/firstboot

# Prepare to run jobs
sudo mkdir -p /var/lib/bibos/jobs
sudo chmod -R og-r /var/lib/bibos

# Prepare to run security events
SECURITY_DIR=/etc/bibos/security/
sudo mkdir -p /etc/bibos/security/
sudo cp -R "$DIR"/script-data/security/* "$SECURITY_DIR"

# Set version in configuration
VERSION=$(cat ../../VERSION)
sudo set_bibos_config bibos_version "$VERSION"

# Do not check for updates or run update-manager
sudo rm /etc/xdg/autostart/update-notifier.desktop

# Do not show user backgrounds in Unity greeter

OVERRIDE_FILE=com.canonical.unity-greeter.gschema.override
cat << EOF > /tmp/$OVERRIDE_FILE
[com.canonical.unity-greeter]
draw-user-backgrounds = false
play-ready-sound = false

EOF

sudo mv /tmp/$OVERRIDE_FILE /usr/share/glib-2.0/schemas
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
