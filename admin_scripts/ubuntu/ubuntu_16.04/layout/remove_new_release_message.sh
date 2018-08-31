#!/usr/bin/env bash


release_upgrades_file=/etc/update-manager/release-upgrades

# Simple backup
cp $release_upgrades_file $release_upgrades_file.org

# Replace Prompt with never value
sed -i 's/Prompt=.*/Prompt=never/' release_upgrades_file
