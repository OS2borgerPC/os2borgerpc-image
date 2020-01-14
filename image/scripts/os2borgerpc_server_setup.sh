#!/usr/bin/env bash

# Setup the OS2BorgerPC client on an Ubuntu Server

DIR=$(dirname ${BASH_SOURCE[0]})

# Avoid script stopping because it wants user input.
export DEBIAN_FRONTEND=noninteractive

# Install all necessary packages and dependencies
$DIR/install_dependencies.sh OS2DISPLAY_DEPENDENCIES

# Prepare to run jobs
mkdir -p /var/lib/bibos/jobs
chmod -R og-r /var/lib/bibos

# Prepare to run security events
SECURITY_DIR=/etc/bibos/security/
mkdir -p /etc/bibos/security/
cp -R "$DIR"/../overwrites/usr/share/bibos/script-data/security/* "$SECURITY_DIR"

# Set version in configuration
VERSION=$(cat "$DIR"/../../VERSION)
set_bibos_config bibos_version "$VERSION"
# Securing grub
"$DIR/../../admin_scripts/image_core/grub_set_password.py" $(pwgen -N 1 -s 12)

#  Connect to the admin system

register_new_bibos_client.sh

exit
# All of the above is general "BorgerPC on a server" setup.
# Now do a minimal install of Chromium, make it autostart and set it up
# with OS2Display.


# Setup default user
useradd user -m -p 12345 -s /bin/bash -U
chfn -f Borger user

# Autologin default user

mkdir -p /etc/systemd/system/getty@tty1.service.d

cat << EOF > /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --noissue --autologin user %I $TERM
Type=idle
EOF
apt install xinit chromium-browser

cat << EOF > /home/user/.xinitrc
#!/bin/sh

exec chromium-browser --kiosk
EOF


echo "startx" >> /home/user/.profile
