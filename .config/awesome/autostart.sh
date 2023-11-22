#!/bin/sh
run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}
run xss-lock --transfer-sleep-lock -- ff-lock.sh
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
run aa-notify -p -s 1 -w 60 -f /var/log/audit/audit.log
run picom -b --config "$HOME"/.config/picom/picom.conf
run nm-applet
run pasystray -g --volume-max=100 --volume-inc=1 --notify=sink_default --notify=source_default
#run cbatticon
#run blueman-applet
#run arch-audit-gtk
run variety
run numlockx on
run wal -R
xidlehook-script.sh
