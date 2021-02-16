#!/usr/bin/env bash

set -e


# Vars
printer_name=$1
printer_loc=$2
printer_descr=$3
printer_driver=$4


printer_conn="socket://"


# Execute command with user defined vars
lpadmin -p $printer_name -v $printer_conn$printer_loc -D "$printer_descr" -E -P $printer_driver
