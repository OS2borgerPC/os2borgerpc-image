#!/usr/bin/env bash

set -x

printf "\n\n%s\n\n" "Installing dependencies"

# Find current directory

DIR=$(dirname "${BASH_SOURCE[0]}")

# The DEPENDENCIES file contains packages/programs
# required by OS2borgerPC.
DEPENDENCIES=( $(cat "$DIR/DEPENDENCIES") )

if [ "$LANG_ALL" ]; then
    # Add support for specific languages besides those preinstalled
  LN="sv"
  DEPENDENCIES+=(language-pack-"$LN")
else
  # The current default: Only add support for Danish
  LN="da"
  DEPENDENCIES+=(language-pack-"$LN")
fi

dpkg -l | grep "^ii" > /tmp/scripts_installed_packages_list.txt

for  package in "${DEPENDENCIES[@]}"
do
    grep -w "ii  $package " /tmp/scripts_installed_packages_list.txt > /dev/null
    if [[ $? -ne 0 ]]; then
        PKGS_TO_INSTALL=$PKGS_TO_INSTALL" "$package
    fi
done


if [ "$PKGS_TO_INSTALL" != "" ]; then
    echo  -n "Some dependencies are missing."
    echo " The following packages will be installed: $PKGS_TO_INSTALL"

    # Step 2: Do the actual installation. Abort if it fails.
    # and install
    # shellcheck disable=SC2086 # We want word-splitting here
    apt-get -y install $PKGS_TO_INSTALL | tee /tmp/os2borgerpc_install_log.txt
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then
        echo "" 1>&2
        echo "ERROR: Installation of dependencies failed." 1>&2
        echo "Please note that \"universe\" repository MUST be enabled" 1>&2
        echo "" 1>&2
        exit 1
    fi
else
    echo "No dependencies missing...?"
fi

#echo "Install any missing language support packages for the missing target languages specifically"
# shellcheck disable=SC2046 # We want word-splitting here
apt-get install -y $(check-language-support -l $LN) $(check-language-support -l en)
# Mark language support packages as explicitly installed as otherwise it seems later stages gets rid of some of them
# shellcheck disable=SC2046 # We want word-splitting here
apt-mark manual $(check-language-support -l $LN --show-installed) $(check-language-support -l en --show-installed)

pip3 install os2borgerpc-client
