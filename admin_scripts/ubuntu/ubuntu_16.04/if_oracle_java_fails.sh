#!/usr/bin/env bash
dpkg --configure -a
apt-get -f install -y
apt-get update && sudo apt-get upgrade -y
