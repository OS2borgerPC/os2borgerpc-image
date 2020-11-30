#!/bin/bash

# Install acpi
dpkg -l acpi 2>1 > /dev/null
HAS_ACPI=$?

if [[ $HAS_ACPI == 1 ]]
then
    apt-get update
    apt-get install -y acpi
fi

# Aflæs temperaturen

acpi -t

