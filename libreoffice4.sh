#!/usr/bin/env bash

# Replaces LibreOffice 3 with LibreOffice 4.

sudo add-apt-repository -y ppa:libreoffice/libreoffice-4-0
sudo apt-get -y update
sudo apt-get -y dist-upgrade

exit 0


