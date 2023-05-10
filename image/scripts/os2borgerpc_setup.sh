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

# Overwrite file tree
"$DIR/do_overwrite.sh"

# Adding this group here as apt-periodic-control called by install_dependencies.sh expects it to exist
groupadd nopasswdlogin

# Install all necessary packages and dependencies
"$DIR/install_dependencies.sh"

# Setup default user
useradd user --create-home --password 12345 --shell /bin/bash --user-group \
  --groups nopasswdlogin --comment Borger

# Setup superuser
# shellcheck disable=SC2016 # It may look like it's a bash variable, but it's not
useradd superuser --create-home --shell /bin/bash \
  --password '$6$/c6Zcifihma/P9NL$MJfwhzrFAcQ0Wq992Wc8XvQ.4mb0aPHK7sUyvRMyicghNmfe7zbvwb5j2AI5AEZq3OfVQRQDbGfzgjrxSfKbp1' \
  --user-group --key UMASK=0077  --groups sudo --comment Superuser

# Now make superuser own its home dir and its contents, and also the script-data dir, so it can delete it after moving
#.its desktop files
chown --recursive superuser:superuser /home/superuser /usr/share/os2borgerpc/bin/script-data

# Make now first boot
touch /etc/os2borgerpc/firstboot

# Prepare to run jobs
mkdir -p /var/lib/os2borgerpc/jobs
chmod -R og-r /var/lib/os2borgerpc

# Switch display manager to LightDM
apt-get -y install lightdm
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

# Download the dbus-x11 .deb file to a known folder
cd /etc/os2borgerpc/
apt download dbus-x11
cd -

figlet "=== About to run assorted OS2borgerPC scripts ==="

# Cloning script repository
apt-get install --assume-yes git
git clone --depth 1 https://github.com/OS2borgerPC/os2borgerpc-scripts.git

# Cloned script directory
SCRIPT_DIR="/os2borgerpc-scripts"

# Remove Bluetooth indicator applet from Borger user
"$SCRIPT_DIR/os2borgerpc/bluetooth/remove_bluetooth_applet.sh"

# Initially disable unattended upgrades to prevent problems with firstboot script
"$SCRIPT_DIR/common/system/apt_periodic_control.sh" false

# Move unattended upgrades script to another folder so that firstboot can run it later
mv "$SCRIPT_DIR/common/system/apt_periodic_control.sh" "/etc/os2borgerpc/"

# Randomize checkins with server.
"$SCRIPT_DIR/common/system/randomize_jobmanager.sh" 5

# Securing grub
"$SCRIPT_DIR/common/system/grub_set_password.py" "$(pwgen -N 1 -s 12)"

# Setup a script to activate the desktop shortcuts for user on login
# This must run after user has been created
"$SCRIPT_DIR/os2borgerpc/desktop/desktop_activate_shortcuts.sh"

# Block suspend, shut down and reboot and remove them from the menu
#sed --in-place "/polkitd/d" "$SCRIPT_DIR/os2borgerpc/desktop/polkit_policy_shutdown_suspend.sh"
"$SCRIPT_DIR/os2borgerpc/desktop/polkit_policy_shutdown_suspend.sh" True True

# Remove lock from the menu
"$SCRIPT_DIR/os2borgerpc/desktop/dconf_disable_lock_menu.sh" True

# Remove change user from the menu
"$SCRIPT_DIR/os2borgerpc/desktop/dconf_disable_user_switching.sh" True

# Remove user access to settings
"$SCRIPT_DIR/os2borgerpc/sikkerhed/adjust_settings_access.sh" False

# Setup /etc/lightdm/lightdm.conf, which needs to exist before we can enable running scripts at login
if [[ -f /etc/lightdm/lightdm.conf.os2borgerpc ]]
then
    mv /etc/lightdm/lightdm.conf.os2borgerpc /etc/lightdm/lightdm.conf
fi

# Enable running scripts at login
"$SCRIPT_DIR/os2borgerpc/login/lightdm_greeter_setup_scripts.sh" True False

# Create the directory expected by the script to set user as the default user
mkdir --parents /var/lib/lightdm/.cache/unity-greeter

# Set user as the default user
"$SCRIPT_DIR/os2borgerpc/login/set_user_as_default_lightdm_user.sh" True

# Prevent future upgrade notifications
"$SCRIPT_DIR/os2borgerpc/desktop/remove_new_release_message.sh"

# Improve Firefox browser security
"$SCRIPT_DIR/os2borgerpc/firefox/firefox_global_policies.sh" https://borger.dk

# Correctly make Firefox the initial standard browser
"$SCRIPT_DIR/os2borgerpc/os2borgerpc/browser_set_default.sh" firefox_firefox

# Disable the run prompt
"$SCRIPT_DIR/os2borgerpc/sikkerhed/dconf_run_prompt_toggle.sh" True

# Install Okular and set it as default PDF reader, mostly because it can conveniently also edit PDFs
"$SCRIPT_DIR/os2borgerpc/os2borgerpc/install_okular_and_set_as_standard_pdf_reader.sh" True

# Set background images on login screen and desktop
"$SCRIPT_DIR/os2borgerpc/desktop/dconf_desktop_background.sh" /usr/share/backgrounds/os2bpc_default_desktop.svg
"$SCRIPT_DIR/os2borgerpc/login/dconf_change_login_bg.sh" True /usr/share/backgrounds/os2bpc_default_login.png

# Make apt-get wait 5 min for dpkg lock
"$SCRIPT_DIR/images/apt_get_config_set_dpkg_lock_timeout.sh" True

# Set fix-broken true by default in the apt-get configuration
"$SCRIPT_DIR/images/apt_get_config_set_fix_broken.sh" True

# Hide libreoffice tip of the day
"$SCRIPT_DIR/os2borgerpc/libreoffice/overwrite_libreoffice_config.sh" True False

# Enable universal access menu by default
"$SCRIPT_DIR/os2borgerpc/desktop/dconf_a11y.sh" True

# Allow superuser to manage CUPS / change printer settings (and make changes via CUPS' web interface)
"$SCRIPT_DIR/printer/allow_superuser_to_manage_cups.sh" True

# Remove cloned script repository
rm --recursive "$SCRIPT_DIR"
apt-get remove --assume-yes git

printf "\n\n%s\n\n" "=== Finished running assorted OS2borgerPC scripts ==="
