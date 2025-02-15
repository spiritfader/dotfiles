#!/bin/sh
capture=/tmp/lock.png;lockscreen=/tmp/lockedit.png
grim -t png $capture; ffmpeg -loglevel quiet -y -i "$capture" -vf scale=10:540,scale=1920:1080 "$lockscreen"
hyprlock -fFeli $lockscreen
rm "$capture" "$lockscreen"