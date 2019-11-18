#!/usr/bin/env bash


# Replace space with underscore and remove æøå
printer_name=`echo $1 | tr ' ' '_' | tr -dc '[:print:]'`
printer_id=$2
# Remove æøå
printer_descr=`echo $3 | tr -dc '[:print:]'`

if [ "`which princh`" ]
then
   lpadmin -p $printer_name -v princh:$printer_id -D "$printer_descr" -E -P /usr/share/ppd/princh/princh.ppd
   exit 0
else
   echo "Princh er ikke installeret"
   exit 1
fi
