#!/bin/bash
# Identify touchpad and enable/disable it depending on its status
touchpad="$(xinput --list | grep 'MSFT0004:00 06CB:CE2D Touchpad' | awk '{print $6}' | cut -d'=' -f2)"
if [ "$(xinput list-props "$touchpad" | grep -P ".*Device Enabled.*\K.(?=$)" -o)" = "1" ]
then
    xinput disable "$touchpad"
else
    xinput enable "$touchpad"
fi

mouse="$(xinput --list | grep 'MSFT0004:00 06CB:CE2D Mouse' | awk '{print $6}' | cut -d'=' -f2)"
if [ "$(xinput list-props "$mouse" | grep -P ".*Device Enabled.*\K.(?=$)" -o)" = "1" ]
then
    xinput disable "$mouse"
else
    xinput enable "$mouse"
fi