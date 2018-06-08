#!/usr/bin/env bash


general_updates=$1
check_unattended_package=`dpkg -s unattended-upgrades | grep "is not installed"`
unattended_upgrades_conf=/etc/apt/apt.conf.d/50unattended-upgrades
check_sec_updates=`cat $unattended_upgrades_conf | grep $'\/\/\t"${distro_id}:${distro_codename}-security";'`
check_general_updates=`cat $unattended_upgrades_conf | grep $'\/\/\t"${distro_id}:${distro_codename}-updates";'`

if [ ! $check_unattended_package ]
then

    # Just make a simple backup
    cp $unattended_upgrades_conf $unattended_upgrades_conf.orig

    # Activate security updates if they aren't
    if [ "$check_sec_updates" ]
    then
        sed -i 's/\/\/\t"${distro_id}:${distro_codename}-security"/\t"${distro_id}:${distro_codename}-security"/g' $unattended_upgrades_conf
        
        if [ $? ]
        then
            echo "Sikkerhedsopdateringer er nu blevet aktiveret"
        else
            echo "Der opstod en fejl ved aktivering af sikkerhedsopdateringer"
        fi
    else
        echo "Sikkerhedsopdateringer er allerede aktiveret"
    fi

    # Activate general updates if it's needed
    if [ "$general_updates" = "Ja" ] || [ "$general_updates" = "ja" ]
    then
        if [ "$check_general_updates" ]
        then
            sed -i 's/\/\/\t"${distro_id}:${distro_codename}-updates"/\t"${distro_id}:${distro_codename}-updates"/g' $unattended_upgrades_conf
        
            if [ $? ]
            then
                echo "Generelle opdateringer er nu blevet aktiveret"
            else
                echo "Der opstod en fejl ved aktivering af generelle opdateringer"
            fi
        else
            echo "Generelle opdateringer er allerede aktiveret"
        fi
    else
        if [ ! "$check_general_updates" ]
        then
            echo "Generelle opdateringer er allerede aktiveret"
        else
            echo "Generelle opdateringer blev ikke aktiveret"
        fi
    fi

else
    echo "Programmet for automatiske opdateringer er ikke installeret på computeren"
fi
