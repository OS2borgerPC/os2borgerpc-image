#!/bin/bash

# stolen from here : https://askubuntu.com/questions/47311/how-do-i-disable-my-system-from-going-to-sleep

systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
