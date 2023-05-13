#!/bin/bash
select=$(echo "Lock Screen
Exit Session
Log Out
Suspend
Hibernate
Reboot
Power Off" | rofi -dmenu -p "Powermenu")

if [[ $select = "Lock Screen" ]]; then ff-lock.sh; fi
if [[ $select = "Exit Session" ]]; then killall xinit; fi
if [[ $select = "Log Out" ]]; then killall xinit && exit; fi
if [[ $select = "Suspend" ]]; then systemctl suspend; fi
if [[ $select = "Hibernate" ]]; then systemctl hibernate; fi
if [[ $select = "Reboot" ]]; then reboot; fi
if [[ $select = "Power Off" ]]; then poweroff; fi
