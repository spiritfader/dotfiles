#!/bin/sh
if pgrep -x "picom" > /dev/null
then
	killall picom
else
	picom -b --config "$HOME"/.config/picom/picom.conf
fi