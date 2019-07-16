#!/usr/bin/env bash

set -e

# Stop Debconf from doing anything
export DEBIAN_FRONTEND=noninteractive

apt-get update > /dev/null
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove
apt-get -y clean

