#!/usr/bin/env bash

#if [ $# -ne 3 ]
#then
#    echo "This job takes exactly three parameters."
#    exit -1
#fi

printer_name=$1
printer_conn=$2
printer_id=$3
printer_descr=$4
printer_driver=$5

if [ $printer_conn == "princh" ]
then
    princh_check=`dpkg -l | grep princh`

    if [ ! -n "$check_princh" ]
    then
        add-apt-repository -y ppa:princh/experimental
        apt-get update
        apt-get install -y princh
    fi

    princh_autostart_dir=/home/.skjult/.config/autostart

    if [ ! -d "$princh_autostart_dir" ]
    then
        mkdir -p $princh_autostart_dir
    fi

    ln -sf /usr/share/applications/com-princh-print-daemon.desktop $princh_autostart_dir

elif [ $printer_conn == "net" ]
then
    $printer_conn="socket://"
elif [ $printer_conn == "usb" ]
then
    $printer_conn="usb://"
fi

# Define driver type

if [ $printer_driver == "Nej" ]
then
    read -p "Hvad er navnet på printeren?" printer
    lpinfo -v | grep "$printer"
    read -p "Indtast den ønskede printdriver" printer
    lpadmin -p $printer_name -v $printer_conn$printer_id -D $printer_descr -E -m $printer
elif [ $printer_driver == "Ja"
then
    echo "Hvor er print-driveren plcaeret?"
    lpadmin -p $printer_name -v $printer_conn$printer_id -D $printer_descr -E -P
fi
