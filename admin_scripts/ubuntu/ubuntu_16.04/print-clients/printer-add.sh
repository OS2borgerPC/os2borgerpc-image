#!/usr/bin/env bash

set -e


# Vars
# Replace space with underscore and remove æøå
printer_name=`echo $1 | tr ' ' '_' | tr -dc '[:print:]'`
printer_conn=$2
printer_loc=$3
# Remove æøå
printer_descr=`echo $4 | tr -dc '[:print:]'`
printer_driver=$5


# Define conncetion type for the printer
if [ `echo $printer_conn | grep 1` ]
then
    printer_conn="socket://"

elif [ `echo $printer_conn | grep 2` ]
then
    printer_conn="usb://"
else
    echo "Forbindelsestypen findes ikke"
    exit 1
fi

# Execute command with user defined vars
lpadmin -p $printer_name -v $printer_conn$printer_loc -D "$printer_descr" -E -P $printer_driver
