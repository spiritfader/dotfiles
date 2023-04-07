#!/bin/sh

# Only exported variables can be used within the timer's command.
PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"
export PRIMARY_DISPLAY

# Make sure no other instances of xidlehook are running
killall xidlehook

# Run xidlehook
xidlehook \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  `# Don't lock when there's audio playing` \
  --not-when-audio \
  `# Detect wake from suspend state and reset timer` \
  --detect-sleep \
  `# Dim the screen after 300 seconds, undim if user becomes active` \
  --timer 300 \
    "xrandr --output $PRIMARY_DISPLAY --brightness .1" \
    "xrandr --output $PRIMARY_DISPLAY --brightness 1" \
  `# Undim & lock after 10 more seconds` \
  --timer 10 \
    "$HOME/.config/scripts/locker/ff-lock.sh" \
    "xrandr --output eDP --brightness 1" \
  --timer 20 \
    "xrandr --output $PRIMARY_DISPLAY --brightness .1" \
    "xrandr --output $PRIMARY_DISPLAY --brightness 1" \
  `# Finally, suspend an hour after it locks` \
  --timer 1200 \
    "systemctl suspend" \
    "xrandr --output $PRIMARY_DISPLAY --brightness 1"

#xrandr --output $PRIMARY_DISPLAY --brightness 1; 