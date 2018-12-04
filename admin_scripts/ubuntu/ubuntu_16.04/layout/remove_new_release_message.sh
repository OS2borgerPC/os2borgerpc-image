#!/usr/bin/env bash


release_upgrades_file=/etc/update-manager/release-upgrades

# Simple backup
if [ ! -f $release_upgrades_file.org ]
then
    cp $release_upgrades_file $release_upgrades_file.org
fi

# Replace Prompt with never value
sed -i 's/Prompt=.*/Prompt=never/' $release_upgrades_file
