#!/bin/bash
remote_ip="62.212.66.171/BibOS"

add-apt-repository -y ppa:gstreamer-developers/ppa
apt-get update
apt-get -y install gstreamer1.0*
apt-get -y install gstreamer-tools
cd /home/superuser
wget http://$remote_ip/afa.deb -e use_proxy=yes -e http_proxy=10.215.28.20:8000
dpkg -i /home/superuser/afa.deb
rm afa.deb

exit 0
