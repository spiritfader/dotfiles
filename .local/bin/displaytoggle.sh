#!/bin/sh
# query xset to determine status of monitor, turn off/on display accordingly
DISPLAY_TOGGLE=$(xset q | grep "Monitor is" | awk '{print $3}')
if [ "$DISPLAY_TOGGLE" = "On" ]; then
    sleep 1;xset dpms force off
else
    sleep 1;xset dpms force on
fi