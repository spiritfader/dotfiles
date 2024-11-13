#!/bin/sh
run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}
run waybar
run dunst
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
#run aa-notify -p -s 1 -w 60 -f /var/log/audit/audit.log
run nm-applet
run blueman-applet
run variety
run wal -R
