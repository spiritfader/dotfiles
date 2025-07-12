#!/bin/bash
# get PID of wvkbd
WVKBD_PID=$(pgrep -x "wvkbd-mobintl")
#check if wvkbd is running
if [ -z "$WVKBD_PID" ]; then
    # start wvkbd if not running
    ~/wvkbd/wvkbd-mobintl
else
    # kill wvkbd if running
    kill "$WVKBD_PID"
fi