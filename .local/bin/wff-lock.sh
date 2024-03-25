#!/bin/bash
pngfile=/tmp/lock.png
pngfileedit=/tmp/lockedit.png
grim -t png $pngfile
ffmpeg -loglevel quiet -y -i "$pngfile" -vf scale=10:540,scale=1920:1080 $pngfileedit
swaylock -fFeli $pngfileedit
rm "$pngfile" "$pngfileedit"