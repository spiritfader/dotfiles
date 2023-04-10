#!/bin/sh
pngfile=/tmp/ff-lock.png
ffmpeg -loglevel quiet -y -f x11grab -video_size 1920x1080 -i "$DISPLAY" -vf scale=10:540,scale=1920:1080 $pngfile #Scale  
#ffmpeg -loglevel quiet -y -f x11grab -video_size 1920x1080 -i "$DISPLAY" -vf scale=11:190,scale=1920:1080 $pngfile #Scale
#ffmpeg -loglevel quiet -y -f x11grab -video_size 1920x1080 -i "$DISPLAY" -vf scale=iw*.1:ih*.1,scale=1920:1080 $pngfile #Scale 
#ffmpeg -loglevel quiet -y -f x11grab -video_size 1920x1080 -i "$DISPLAY" -filter_complex "boxblur=10" -vframes 1 $pngfile #Blur

playerctl pause
i3lock -efni $pngfile
rm $pngfile