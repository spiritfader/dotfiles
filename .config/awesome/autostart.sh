#!/bin/sh
run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}
run xss-lock --transfer-sleep-lock -- ff-lock.sh
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
#run aa-notify -p -s 1 -w 60 -f /var/log/audit/audit.log
run picom -b --config "$HOME"/.config/picom/picom.conf
#run polybar
run nm-applet
run blueman-applet
run variety
#run numlockx on
run wal -R
xidlehook-script.sh
