#!/bin/bash
# Identify touchpad and enable/disable it depending on its status, and reload the i2c_hid_acpi to fix touchpad if bugging out
#touchpad="$(xinput --list | grep 'MSFT0004:00 06CB:CE2D Touchpad' | awk '{print $6}' | cut -d'=' -f2)"
#if [ "$(xinput list-props "$touchpad" | grep -P ".*Device Enabled.*\K.(?=$)" -o)" = "1" ]; then
#    xinput disable "$touchpad"
#    sudo modprobe -r i2c_hid_acpi
#else
#    xinput enable "$touchpad"
#    sudo modprobe i2c_hid_acpi
#fi
#
#mouse="$(xinput --list | grep 'MSFT0004:00 06CB:CE2D Mouse' | awk '{print $6}' | cut -d'=' -f2)"
#if [ "$(xinput list-props "$mouse" | grep -P ".*Device Enabled.*\K.(?=$)" -o)" = "1" ]; then
#    xinput disable "$mouse"
#    sudo modprobe -r i2c_hid_acpi
#
#else
#    xinput enable "$mouse"
#    sudo modprobe i2c_hid_acpi    
#fi

# Identify touchpad and enable/disable it depending on its status, and reload the i2c_hid_acpi to fix touchpad if bugging out
touchpad="$(xinput --list | grep 'MSFT0004:00 06CB:CE2D Touchpad' | awk '{print $6}' | cut -d'=' -f2)"
mouse="$(xinput --list | grep 'MSFT0004:00 06CB:CE2D Mouse' | awk '{print $6}' | cut -d'=' -f2)"
if [ "$(xinput list-props "$mouse" | grep -P ".*Device Enabled.*\K.(?=$)" -o)" = "1" ] || \
[ "$(xinput list-props "$touchpad" | grep -P ".*Device Enabled.*\K.(?=$)" -o)" = "1" ]; then
    xinput disable "$touchpad"
    xinput disable "$mouse"
else
    xinput enable "$touchpad"
    xinput enable "$mouse"
fi
