#!/usr/bin/env bash

printf "\n\n%s\n\n" "===== RUNNING: $0 ====="

# Now do the deed
DIR=$(dirname "$(realpath "$0" )")
cp --recursive "$DIR"/../overwrites/* /

# Permissions fixup
chmod 0400 "/home/.skjult/.local/share/keyrings/Standardnøglering.keyring"
chown --recursive superuser:superuser /home/superuser
# Set more restrictive permissions on some system files
chmod 0700 "/usr/share/os2borgerpc/bin/user-cleanup.bash" "/usr/share/os2borgerpc/bin/xset.sh"

# Set correct permissions on the gio scripts
chmod u+x "/usr/share/os2borgerpc/bin/gio-fix-desktop-file-permissions.sh"
chmod +x "/usr/share/os2borgerpc/bin/gio-dbus.sh"

# Set correct permissions on files related to greeter-setup-scripts
chmod 0700 "/etc/lightdm/greeter_setup_script.sh"
chmod 0700 --recursive "/etc/lightdm/greeter-setup-scripts"

# Update dconf with settings from overwrites.
dconf update
