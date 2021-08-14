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

# Overwrite file tree
"$DIR/do_overwrite.sh"

# Install all necessary packages and dependencies
$DIR/install_dependencies.sh

# Setup default user
useradd user -m -p 12345 -s /bin/bash -U
chfn -f Borger user
adduser user nopasswdlogin

# Make now first boot
touch /etc/os2borgerpc/firstboot

# Prepare to run jobs
mkdir -p /var/lib/os2borgerpc/jobs
chmod -R og-r /var/lib/os2borgerpc

# Switch display manager to LightDM
DEBIAN_FRONTEND=noninteractive apt -y install lightdm
echo "/usr/sbin/lightdm" > /etc/X11/default-display-manager
apt -y remove gdm3

# Prepare to run security events
SECURITY_DIR=/etc/os2borgerpc/security/
mkdir -p /etc/os2borgerpc/security/
cp -R "$DIR"/../overwrites/usr/share/os2borgerpc/script-data/security/* "$SECURITY_DIR"

# Set product in configuration
PRODUCT="os2borgerpc"
set_os2borgerpc_config os2_product "$PRODUCT"

# Set version in configuration
VERSION=$(cat "$DIR"/../../VERSION)
set_os2borgerpc_config os2borgerpc_version "$VERSION"

# Securing grub
"$DIR/../../admin_scripts/image_core/grub_set_password.py" $(pwgen -N 1 -s 12)
