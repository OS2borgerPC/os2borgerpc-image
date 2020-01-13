#!/usr/bin/env bash

# Setup the OS2BorgerPC client on an Ubuntu Server

# Setup default user
useradd user -m -p 12345 -s /bin/bash -U
chfn -f Borger user
adduser user nopasswdlogin

# Autologin default user

mkdir -p /etc/systemd/system/getty@tty1.service.d

cat << EOF > /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --noissue --autologin myusername %I $TERM
Type=idle
EOF

# Make now first boot
touch /etc/bibos/firstboot

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

# All of the above is general "BorgerPC on a server" setup.
# Now do a minimal install of Chromium, make it autostart and set it up
# with OS2Display.

# TODO!!!


