#
# ~/.zprofile
#

[[ -f ~/.zshrc ]] && . ~/.zshrc
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  #startx
  Hyprland
fi
