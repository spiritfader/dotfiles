#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

xcalib -d :0 .color/icc_profile

wm1=awesome

if ! [ -e "$HOME/.cache/wm-logs" ]; then
    mkdir "$HOME/.cache/wm-logs"
    touch stderr stdout
fi

export LIBVA_DRIVER_NAME=radeonsi 
export VDPAU_DRIVER=radeonsi

exec $wm1 >> "$HOME"/.cache/wm-logs/stdout 2>> "$HOME"/.cache/wm-logs/stderr

