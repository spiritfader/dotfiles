#!/bin/sh

: "${XDG_RUNTIME_DIR:?Environment variable XDG_RUNTIME_DIR not set}"
: "${HYPRLAND_INSTANCE_SIGNATURE:?Environment variable HYPRLAND_INSTANCE_SIGNATURE not set}"

handle() {
  case "$1" in
    workspace* | focusedmon* | openwindow* | closewindow* | movewindow*)
      update_active_clients
    ;;
  esac
}

update_active_clients() {
  active_clients=$(hyprctl activeworkspace -j | jq -r .windows)
  echo "$active_clients"
}

# Initial update
update_active_clients

# Listen to events and handle them
socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while IFS= read -r line; do
  handle "$line"
done