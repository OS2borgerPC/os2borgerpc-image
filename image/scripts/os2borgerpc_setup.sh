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

echo "RUNNING SCRIPT $0 (INSIDE SQUASHFS)"
echo "Beware: This is the version on GitHub if the --mount flag wasn't passed to build_os2borgerpc_image.sh"

DIR=$(dirname "${BASH_SOURCE[0]}")

# Add universe repositories

cat << EOF >> /etc/apt/sources.list
# Add universe stuff
deb http://archive.ubuntu.com/ubuntu/ focal universe
deb http://security.ubuntu.com/ubuntu/ focal-security universe
deb http://archive.ubuntu.com/ubuntu/ focal-updates universe
EOF

apt-get update

# Overwrite file tree
"$DIR/do_overwrite.sh"

# Adding this group here as apt-periodic-control called by install_dependencies.sh expects it to exist
groupadd nopasswdlogin

# Install all necessary packages and dependencies
"$DIR/install_dependencies.sh"

# Setup default user
useradd user -m -p 12345 -s /bin/bash -U
chfn -f Borger user
adduser user nopasswdlogin

# Setup superuser
useradd superuser -m -s /bin/bash -p '$6$/c6Zcifihma/P9NL$MJfwhzrFAcQ0Wq992Wc8XvQ.4mb0aPHK7sUyvRMyicghNmfe7zbvwb5j2AI5AEZq3OfVQRQDbGfzgjrxSfKbp1' -U
chfn -f Superuser superuser
adduser superuser sudo
chmod -R 744 /home/superuser

# Make now first boot
touch /etc/os2borgerpc/firstboot

# Prepare to run jobs
mkdir -p /var/lib/os2borgerpc/jobs
chmod -R og-r /var/lib/os2borgerpc

# Switch display manager to LightDM
DEBIAN_FRONTEND=noninteractive apt -y install lightdm
echo "/usr/sbin/lightdm" > /etc/X11/default-display-manager
apt-get remove --assume-yes gdm3

# Prepare for security scripts
mkdir -p /etc/os2borgerpc/security/

# Set product in configuration
PRODUCT="os2borgerpc"
set_os2borgerpc_config os2_product "$PRODUCT"

# Set version in configuration
VERSION=$(cat "$DIR"/../../VERSION)
set_os2borgerpc_config os2borgerpc_version "$VERSION"

printf "\n\n%s\n\n" "=== About to run assorted OS2borgerPC scripts ==="

# Setup unattended upgrades
"$DIR/apt_periodic_control.sh" security

# Randomize checkins with server.
"$DIR/randomize_jobmanager.sh" 5

# Securing grub
"$DIR/grub_set_password.py" $(pwgen -N 1 -s 12)

# Setup a script to activate the desktop shortcuts for superuser on login
# This must run after superuser has been created
"$DIR/superuser_fix_desktop_shortcuts_permissions.sh"

printf "\n\n%s\n\n" "=== Finished running assorted OS2borgerPC scripts ==="
