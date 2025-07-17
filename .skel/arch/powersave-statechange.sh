#!/bin/sh
	if cat < /sys/class/power_supply/ACAD/online | grep 0 > /dev/null 2>&1; then
		/home/spiritfader/.local/bin/powertop-battery.sh
	else
    	/home/spiritfader/.local/bin/powertop-plugged.sh
	fi
