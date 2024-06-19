#!/bin/sh
SCRIPT_DIR="/etc/lightdm/greeter-setup-scripts"
greeter_setup_scripts=$(find $SCRIPT_DIR -mindepth 1)
for file in $greeter_setup_scripts
do
    ./"$file" &
done
