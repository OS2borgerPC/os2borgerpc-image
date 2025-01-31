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

DIR=$(dirname "${BASH_SOURCE[0]}")

# Add universe repositories

# Load VERSION_CODENAME variable below, so it's dynamically set
. /etc/os-release

cat << EOF >> /etc/apt/sources.list
# Add universe stuff
deb http://archive.ubuntu.com/ubuntu/ $VERSION_CODENAME universe
deb http://security.ubuntu.com/ubuntu/ $VERSION_CODENAME-security universe
deb http://archive.ubuntu.com/ubuntu/ $VERSION_CODENAME-updates universe
EOF

export DEBIAN_FRONTEND=noninteractive

apt-get update

# Setup superuser. This is done before do_overwrite, as that currently copies in some files into superusers home dir.
# shellcheck disable=SC2016 # It may look like it's a bash variable, but it's not
useradd superuser --create-home --shell /bin/bash \
  --password '$6$/c6Zcifihma/P9NL$MJfwhzrFAcQ0Wq992Wc8XvQ.4mb0aPHK7sUyvRMyicghNmfe7zbvwb5j2AI5AEZq3OfVQRQDbGfzgjrxSfKbp1' \
  --user-group --key UMASK=0077  --groups sudo --comment Superuser

# Overwrite file tree
"$DIR/do_overwrite.sh"

# Adding this group here as apt-periodic-control called by install_dependencies.sh expects it to exist
groupadd nopasswdlogin

# Install all necessary packages and dependencies
"$DIR/install_dependencies.sh"

# Setup default user
useradd user --create-home --password 12345 --shell /bin/bash --user-group \
  --groups nopasswdlogin --comment Borger

# Make now first boot
touch /etc/os2borgerpc/firstboot

# Prepare to run jobs
mkdir /var/lib/os2borgerpc --mode 700

# Switch display manager to LightDM
apt-get --assume-yes install lightdm
echo "/usr/sbin/lightdm" > /etc/X11/default-display-manager
apt-get remove --assume-yes gdm3

# Prepare for security scripts
mkdir --parents /etc/os2borgerpc/security/

# Set product in configuration
PRODUCT="os2borgerpc"
echo "os2_product: $PRODUCT" >> /etc/os2borgerpc/os2borgerpc.conf

# Set version in configuration
VERSION=$(cat "$DIR"/../../VERSION)
echo "os2borgerpc_version: $VERSION" >> /etc/os2borgerpc/os2borgerpc.conf

# Insert values from config.cfg that are prefixed with 'DEFAULT_' into os2borgerpc.conf.
# Path to the configuration file
CONFIG_FILE="$DIR/../../config.cfg"

# Read each line in the configuration file and reformat it
while IFS='=' read -r key value; do
    # Skip empty lines, lines without '=', and lines starting with '#'
    if [[ -n "$key" && -n "$value" && "$key" != \#* ]]; then
        # Convert key to lowercase and remove "DEFAULT_" prefix
        lowercase_key=$(echo "$key" | sed 's/^DEFAULT_//' | tr '[:upper:]' '[:lower:]')
        
        # Write in "key: value" format
        echo "${lowercase_key}: ${value}" >> /etc/os2borgerpc/os2borgerpc.conf
    fi
done < "$CONFIG_FILE"


echo "About to run assorted OS2borgerPC scripts from this repo:"

# Remove Bluetooth indicator applet from Borger user
"$DIR/remove_bluetooth_applet.sh"

# Download the dbus-x11 .deb file to a known folder
cd /etc/os2borgerpc/
apt download dbus-x11
cd -

figlet "=== About to run assorted OS2borgerPC scripts from the scripts repo ==="

# Temporary intall os2borgerpc-client, as it is a dependency for running the scripts below.
# the script has been copied by do_overwrite.sh above.
"./usr/local/bin/install_client.sh"

# Cloning script repository
git clone --depth 1 https://github.com/OS2borgerPC/os2borgerpc-core-scripts.git

# Cloned script directory
SCRIPT_DIR="/os2borgerpc-core-scripts/scripts"

# Make sure all scripts are executable
chmod +x $SCRIPT_DIR/*

# Initially disable unattended upgrades to prevent problems with firstboot script
"$SCRIPT_DIR/apt_periodic_control.sh" false

# Move unattended upgrades script to another folder so that firstboot can run it later
mv "$SCRIPT_DIR/apt_periodic_control.sh" "/etc/os2borgerpc/"

# Randomize checkins with server.
"$SCRIPT_DIR/randomize_jobmanager.sh" 5

# Securing grub
"$SCRIPT_DIR/grub_set_password.py" "$(pwgen -N 1 -s 12)"

# Setup a script to activate the desktop shortcuts for user on login
# This must run after user has been created
"$SCRIPT_DIR/desktop_activate_shortcuts.sh"

# Block suspend, shut down and reboot and remove them from the menu
#sed --in-place "/polkitd/d" "$SCRIPT_DIR/os2borgerpc/desktop/polkit_policy_shutdown_suspend.sh"
"$SCRIPT_DIR/polkit_policy_shutdown_suspend.sh" True True

# Remove lock from the menu
"$SCRIPT_DIR/dconf_disable_lock_menu.sh" True

# Remove change user from the menu
"$SCRIPT_DIR/dconf_disable_user_switching.sh" True

# Block Gnome Remote Desktop
"$SCRIPT_DIR/dconf_disable_gnome_remote_desktop.sh" True

# Remove user access to terminal
"$SCRIPT_DIR/protect_terminal.sh" False

# Remove user access to settings
"$SCRIPT_DIR/adjust_settings_access.sh" False

# Setup /etc/lightdm/lightdm.conf, which needs to exist before we can enable running scripts at login
if [[ -f /etc/lightdm/lightdm.conf.os2borgerpc ]]
then
    mv /etc/lightdm/lightdm.conf.os2borgerpc /etc/lightdm/lightdm.conf
fi

# Enable running scripts at login
"$SCRIPT_DIR/lightdm_greeter_setup_scripts.sh" False

# Include fix for rare LightDM startup error
"$SCRIPT_DIR/lightdm_fix_boot_error.sh" True

# Set user as the default user
"$SCRIPT_DIR/set_user_as_default_lightdm_user.sh" True

# Prevent future upgrade notifications
"$SCRIPT_DIR/remove_new_release_message.sh"

# Improve Firefox browser security
"$SCRIPT_DIR/firefox_global_policies.sh" https://borger.dk

# Correctly make Firefox the initial standard browser
"$SCRIPT_DIR/browser_set_default.sh" firefox_firefox

# Disable the run prompt
"$SCRIPT_DIR/dconf_run_prompt_toggle.sh" True

# Install Okular and set it as default PDF reader, mostly because it can conveniently also edit PDFs
"$SCRIPT_DIR/install_okular_and_set_as_standard_pdf_reader.sh" True

# Set background images on login screen and desktop
# Multi user image uses a different image because the Danish one has Danish text on it
if [ "$LANG_ALL" ]; then
  BG="/usr/share/backgrounds/os2bpc_default_login.png"
else
  BG="/usr/share/backgrounds/os2bpc_default_desktop.svg"
fi
"$SCRIPT_DIR/dconf_desktop_background.sh" $BG
"$SCRIPT_DIR/dconf_change_login_bg.sh" True /usr/share/backgrounds/os2bpc_default_login.png

# Make apt-get wait 5 min for dpkg lock
"$SCRIPT_DIR/apt_get_config_set_dpkg_lock_timeout.sh" True

# Set fix-broken true by default in the apt-get configuration
"$SCRIPT_DIR/apt_get_config_set_fix_broken.sh" True

# Hide libreoffice tip of the day
"$SCRIPT_DIR/overwrite_libreoffice_config.sh" True False

# Enable universal access menu by default
"$SCRIPT_DIR/dconf_a11y.sh" True

# Allow superuser to manage CUPS / change printer settings (and make changes via CUPS' web interface)
"$SCRIPT_DIR/allow_superuser_to_manage_cups.sh"

# Remove cloned script repository
rm --recursive "$SCRIPT_DIR"

# Uninstall temporary os2borgerpc-client install
pip uninstall -y os2borgerpc-client

printf "\n\n%s\n\n" "=== Finished running assorted OS2borgerPC scripts ==="
