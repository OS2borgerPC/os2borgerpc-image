#!/bin/bash

# Find current directory

DIR=$(dirname ${BASH_SOURCE[0]})

# Install BIBOS specific dependencies
#           
# The DEPENDENCIES file contains packages/programs
# required by BibOS AND extra packages which are free dependencies
# of Skype and MS Fonts - to shorten the postinstall process.
DEPENDENCIES=( $(cat "$DIR/DEPENDENCIES") )


PKGSTOINSTALL=""

dpkg -l | grep "^ii" > /tmp/installed-package-list.txt


grep -w "ii  deja-dup" /tmp/installed-package-list.txt > /dev/null
if [ $? -eq 0 ]; then
   # Things to get rid of. Factor out to file if many turn up.
    sudo apt-get -y remove --purge deja-dup
fi

# Remove amazon and update notifier
sudo apt-get -y remvoe --purge --autoremove unity-webapps-*
sudo apt-get -y remove --purge --autoremove update-notifer


for  package in "${DEPENDENCIES[@]}"
do
    grep -w "ii  $package " /tmp/installed-package-list.txt > /dev/null
    if [[ $? -ne 0 ]]; then
        PKGSTOINSTALL=$PKGSTOINSTALL" "$package
    fi
done

if [ "$PKGSTOINSTALL" != "" ]; then
    echo  -n "Some dependencies are missing."
    echo " The following packages will be installed: $PKGSTOINSTALL" 
    
    # Step 1: Check for valid APT repositories.

    sudo apt-get update &> /dev/null
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then
        echo "" 1>&2
        echo "ERROR: Apt repositories are not valid or cannot be reached from your network." 1>&2
        echo "Please fix and retry" 1>&2
        echo "" 1>&2
        exit -1
    else
        echo "Repositories OK: Installing packages"
    fi

    # Step 2: Do the actual installation. Abort if it fails.
    # and install
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install $PKGSTOINSTALL | tee /tmp/bibos_install_log.txt
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then
        echo "" 1>&2
        echo "ERROR: Installation of dependencies failed." 1>&2
        echo "Please note that \"universe\" repository MUST be enabled" 1>&2
        echo "" 1>&2
        exit -1
    fi

    # upgrade
    sudo apt-get -y upgrade | tee /tmp/bibos_upgrade_log.txt
    sudo apt-get -y dist-upgrade | tee /tmp/bibos_upgrade_log.txt

    # Clean .deb cache to save space
    sudo apt-get -y autoremove
    sudo apt-get -y clean

fi

# Install python packages
pip install --upgrade bibos-utils bibos-client

# Enable security updates to be automatically installed
CONF="/etc/apt/apt.conf.d/90os2borgerpc-automatic-upgrades"

if ! dpkg -s unattended-upgrades > /dev/null 2>&1; then
    sudo apt-get -y install unattended-upgrades
fi
    cat > "$CONF" <<END
APT::Periodic::Enable "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::Update-Package-Lists "1";
#clear Unattended-Upgrade::Allowed-Origins;
Unattended-Upgrade::Allowed-Origins {
    "\${distro_id}:\${distro_codename}-security"
    ; "\${distro_id}ESM:\${distro_codename}"
};

# We're done!
END

# Install English language package
sudo apt-get -y install language-pack-en language-pack-gnome-en