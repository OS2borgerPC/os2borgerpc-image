#!/usr/bin/env bash


general_updates=$1
check_unattended_package=`dpkg -s unattended-upgrades | grep "is not installed"`
unattended_upgrades_conf=/etc/apt/apt.conf.d/50unattended-upgrades
auto_upgrades_conf=/etc/apt/apt.conf.d/20auto-upgrades
check_auto_upgrades=`grep 'Unattended-Upgrade "0";' $auto_upgrades_conf`
check_sec_updates=`grep $'\/\/\t"${distro_id}:${distro_codename}-security";' $unattended_upgrades_conf`
check_general_updates=`grep $'\/\/\t"${distro_id}:${distro_codename}-updates";' $unattended_upgrades_conf`

# Overall, check if package is installed
if [ ! $check_unattended_package ]
then

    # Check and activate auto upgrades
    if [ "$check_auto_upgrades" ]
    then
        cp $auto_upgrades_conf $auto_upgrades_conf.orig
        echo "$check_auto_upgrades" | sed 's/0/1/g' > $auto_upgrades_conf
    fi

    # Just make a simple backup
    if [ ! -e $unattended_upgrades_conf.orig ]
    then
        cp $unattended_upgrades_conf $unattended_upgrades_conf.orig
    fi

    # Activate security updates if they aren't
    if [ "$check_sec_updates" ]
    then
        sed -i 's/\/\/\t"${distro_id}:${distro_codename}-security"/\t"${distro_id}:${distro_codename}-security"/g' $unattended_upgrades_conf
        echo "Sikkerhedsopdateringer er nu blevet aktiveret"
    else
        echo "Sikkerhedsopdateringer er allerede aktiveret"
    fi

    # Activate general updates if it's needed
    if [ "$general_updates" = "Ja" ] || [ "$general_updates" = "ja" ]
    then
        if [ "$check_general_updates" ]
        then
            sed -i 's/\/\/\t"${distro_id}:${distro_codename}-updates"/\t"${distro_id}:${distro_codename}-updates"/g' $unattended_upgrades_conf
            sed -i 's/\/\/Unattended-Upgrade::MinimalSteps "true"/Unattended-Upgrade::MinimalSteps "true"/g' /etc/apt/apt.conf.d/50unattended-upgrades
            echo "Generelle opdateringer er nu blevet aktiveret"
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
