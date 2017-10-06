#!/bin/bash

PACKAGE='google-chrome-stable_61.0.3163.100-1_amd64.deb'

wget http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/$PACKAGE
dpkg -i $PACKAGE


