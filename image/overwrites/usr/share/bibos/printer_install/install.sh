#!/bin/bash

INSTALLDIR=`dirname $0`

# TODO: This is no longer necessary. Remove these lines once everything is
# tested. Superuser will from now on be created before user and will always
# be member of admin group. Also, the name "superuser" is no longer hard coded.
#echo "Setting up lpadmin group membership"
#adduser superuser lpadmin
#deluser user lpadmin

echo "Unpacking files"
tar -C / -pxvzf "$INSTALLDIR/printer_files.tar.gz"

echo "Installing python 2.6"
dpkg -i /usr/share/bibos/printer_install/*.deb

echo "Adding printers:"
echo "Sort/Hvid"
lpadmin -p "SorthvidPrinter" -E -v "sqport://10.37.7.102/secure" -P /usr/share/bibos/printer_install/sorthvid.ppd
echo "Farve"
lpadmin -p "FarvePrinter" -E -v "sqport://10.37.7.102/secure" -P /usr/share/bibos/printer_install/farve.ppd
echo "Setting SorthvidPrinter as default printer"
lpadmin -d "SorthvidPrinter"
