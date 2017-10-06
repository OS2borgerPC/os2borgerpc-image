#!/usr/bin/env bash

# http://askubuntu.com/questions/430434/replace-openjdk-with-oracle-jdk-on-ubuntu

add-apt-repository ppa:webupd8team/java -y
apt-get update

echo "oracle-java6-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
apt-get install oracle-java6-installer -y
