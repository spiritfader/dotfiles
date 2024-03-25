swayidle -w timeout 300 'brightnessctl set 0%' resume 'brightnessctl set 80%' \
            timeout 310 'wff-lock.sh' \
            timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' \
            timeout 1200 'systemctl suspend' \
            before-sleep 'wff-lock.sh' &