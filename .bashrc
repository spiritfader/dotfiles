#!/bin/bash
#
# ~/.bashrc: executed by bash(1) for non-login shells.
#
# shellcheck disable=SC1090
# shellcheck disable=SC1091

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# source git-prompt for ps1
#source /usr/share/git/git-prompt.sh

# source bashrc.d if exists
for sh in /etc/bash/bashrc.d/* ; do
	[[ -r ${sh} ]] && source "${sh}"
done

# you may want to put all your additions into a separate file like ~/.bash_aliases, instead of adding them here directly.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# default umask. A umask of 022 prevents new files from being created group and world writable.
# file permissions: rwxr-xr-x
umask 022

# search path for cd(1)
CDPATH=:$HOME

# enable the builtin emacs(1) command line editor in sh(1), e.g. C-a -> beginning-of-line.
set -o emacs

# enable the builtin vi(1) command line editor in sh(1), e.g. ESC to go into visual mode.
# set -o vi

# set ksh93 visual editing mode:
if [ "$SHELL" = "/bin/ksh" ]; then
  VISUAL=emacs
fi

# set ssh agent
#if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
#fi

#if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
#    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
#fi

# set environment path________________________________________________________

#### check for user bin $HOME/.local/bin and add to path if it exists and isnt in path
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  path="$HOME/.local/bin${PATH:+":$path"}"
fi

#### check for user bin $HOME/bin and add to path if it exists and isnt in path
if [ -d "$HOME/bin" ] && [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
  path="$HOME/bin${PATH:+":$path"}"
fi

#### check for pspdev toolchain and add to path if exists
if [ -d "$HOME/.pspdev" ] && [[ ":$PATH:" != *":$HOME/.pspdev/bin:"* ]]; then
  export PSPDEV=.pspdev
  path="$HOME/$PSPDEV/bin${PATH:+":$path"}"
fi

#### Check for openjdk and add to env variable
if [ -f /etc/profile.d/jre.sh ] && [[ ":$PATH:" != *":/usr/lib/jvm/default/bin:"* ]]; then
  path="/usr/lib/jvm/default/bin${PATH:+":$path"}"
fi

#### check for ruby gems & add ruby gems to path
if command -v gem &> /dev/null && [ -d "$(gem env user_gemhome)" ] && [[ ":$PATH:" != *":$GEM_HOME/bin:"* ]]; then
  GEM_HOME="$(gem env user_gemhome)"
  export GEM_HOME
  path="$GEM_HOME/bin${PATH:+":$path"}"
fi

#### check for go bin and add to path
if command -v go &> /dev/null && [ -d "$(go env GOPATH)" ] && [[ ":$PATH:" != *":$(go env GOBIN):$(go env GOPATH)/bin:"* ]]; then
  path="$(go env GOBIN):$(go env GOPATH)/bin${PATH:+":$path"}"
fi

#### check for dotnet and add to path
if command -v dotnet &> /dev/null && [ -d "$HOME/.dotnet/tools"  ] && [[ ":$PATH:" != *":$HOME/.dotnet/tools:"* ]]; then
  path="$HOME/.dotnet/tools${PATH:+":$path"}"
  export DOTNET_CLI_TELEMETRY_OPTOUT=1
fi

#### check for ccache and add to path
if command -v ccache &> /dev/null && [ -d "/usr/lib/ccache/bin" ] && [[ ":$PATH:" != *":/usr/lib/ccache/bin:"* ]]; then
  path="/usr/lib/ccache/bin${PATH:+":$path"}"
fi

#### check for rustup and add to path
if command -v rustup &> /dev/null && [ -d "/usr/lib/rustup/bin" ] && [[ ":$PATH:" != *":/usr/lib/rustup/bin:"* ]]; then
  path="/usr/lib/rustup/bin${PATH:+":$path"}"
fi

#### check for npm and allow for local installations
if command -v npm &> /dev/null && [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" = *":$HOME/.local/bin:"* ]]; then
  export npm_config_prefix="$HOME/.local"
fi

# Set environment variables __________________________________________________
export EDITOR="emacs"
export VISUAL="emacs"
export LD_PRELOAD=""
export HISTSIZE=8192
export HISTCONTROL=ignorespace
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export RANGER_LOAD_DEFAULT_RC=FALSE
export PAGER="less"
export SYSTEMD_PAGER="less"
export CFLAGS+="-fdiagnostics-color=always"

shopt -s autocd # Enable auto cd when typing directories
shopt -s checkwinsize # check the terminal size when it regains control - check winsize when resize
shopt -s histappend # append to the history file, don't overwrite it
shopt -s globstar # the pattern "**" used in a pathname expansion context will match all files and zero or more directories and subdirectories.
shopt -s promptvars # prompt strings undergo parameter expansion, command substitution, arithmetic expansion, and quote removal after being expanded.
shopt -s no_empty_cmd_completion # Disable completion when the input buffer is empty

bind "set completion-ignore-case on" #ignore upper and lowercase when TAB completion

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# change the window title of X terminals
case ${TERM} in
  [aEkx]term*|rxvt*|gnome*|konsole*|interix|tmux*|alacritty*)  PS1='\[\033]0;\u@\h:\w\007\]';;
  screen*)  PS1='\[\033k\u@\h:\w\033\\\]';;
  *)  unset PS1;;
esac

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database instead of using /etc/DIR_COLORS. Try to use the external file first to take advantage of user additions.
# We run dircolors directly due to its changes in file syntax and terminal name patching.
use_color=false
if type -P dircolors >/dev/null ; then
  # enable colors for ls, etc.  Prefer ~/.dir_colors #64489
  LS_COLORS=
  if [[ -f ~/.dir_colors ]] ; then
    eval "$(dircolors -b ~/.dir_colors)"
  elif [[ -f /etc/DIR_COLORS ]] ; then
    eval "$(dircolors -b /etc/DIR_COLORS)"
  else
    eval "$(dircolors -b)"
  fi
  # note: We always evaluate the LS_COLORS setting even when it's the default.
  # if it isn't set, then `ls` will only colorize by default based on file attributes and ignore extensions (even the compiled in defaults of dircolors). #583814
  if [[ -n ${LS_COLORS:+set} ]]; then
    use_color=true
  else
    # delete it if it's empty as it's useless in that case.
    unset LS_COLORS
  fi
else
  # some systems (e.g. BSD & embedded) don't typically come with
  # dircolors so we need to hardcode some terminals in here.
  case ${TERM} in
  [aEkx]term*|rxvt*|gnome*|konsole*|screen|tmux|cons25|*color) use_color=true;;
  esac
fi

# 'safe' version of __git_ps1 to avoid errors on systems that don't have it, shows git status within bash prompt
gitPrompt () {
  command -v __git_ps1 > /dev/null && __git_ps1 " (%s)"
}

# set PS1 prompt display
if ${use_color} ; then 
  i=1;
  if [[ ${EUID} == 0 ]] ; then # set root PS1
    PS1+='\[\e[32m\]\T \[\e[36m\]\w\[\e[33m\]$(gitPrompt)\[\e[34m\] \$\[\e[00m\]$(if ! [ $(jobs | wc -l) -eq 0 ]; then jobs | wc -l;fi) ' # custom root prompt with inline git branch status
  else # set user PS1
    PS1+='\[\e[32m\]\T \[\e[36m\]\w\[\e[33m\]$(gitPrompt)\[\e[34m\] \$\[\e[36m\]$(if ! [ $(jobs | wc -l) -eq 0 ]; then echo "[$(jobs | wc -l)]";fi)\[\e[00m\] ' # custom root prompt with inline git branch status
    PS2="~ "
  fi
  #BSD#@export CLICOLOR=1
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias ip='ip -c'
  alias diff='diff --color=auto'
  export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01' # colored GCC warnings and errors
else
  # show root@ when we don't have colors
  PS1+='\u@\h \w \$ '
fi

# start bash PS1 prompt on newline if none within previous EOT (FIX, breaks multiple term in tiled wm)
#PS1='$(printf "%$((`tput cols`-1))s\r")'$PS1

# set 'man' colors
if [ "$use_color" = yes ]; then
  man() {
  env \
  LESS_TERMCAP_mb=$'\e[01;31m' \
  LESS_TERMCAP_md=$'\e[01;31m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[01;44;33m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[01;32m' \
  man "$@"
  }
fi

# import colorscheme from 'wal' asynchronously.
#(cat ~/.cache/wal/sequences &)

# try to keep environment pollution down, EPA loves us.
unset use_color sh

# Set aliases & functions_____________________________________________________
# basic util aliases
alias ssh='TERM=xterm-256color ssh'
alias em='emacs'
#alias em='emacsclient -t'
alias sudo='sudo '
alias ll='ls -lhZ'
alias la='ls -lhaZ'
alias l='ls -CF'
alias less='less -FR --use-color'
alias env='env | sort'
alias dd='dd status=progress'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias shred="shred -zf"
alias wget="wget -U 'noleak'"
alias curl="curl --user-agent 'noleak'"
alias count='find . -type f | wc -l'
alias empty_trash='rm -rf ~/.local/share/Trash/*'
alias infgears='vblank_mode=0 glxgears'
alias fwupd='fwupdmgr get-updates'
alias logout='pkill -9 -u $(whoami)'
alias h='fc -l'
alias j='jobs'
alias m="\$PAGER"
alias g='egrep -i'
alias gif='ffmpeg -i "input.mkv" -vf "fps=10,scale=320:-1:flags=lanczos" -c:v pam -f image2pipe - | convert -delay 10 - -loop 0 -layers optimize output.gif'
alias mountrw='mount -o noatime -uw' # Decrease likelihood of filesystem metadata corruption on [CF,SD,USB] persistent media by setting '-o noatime'.
alias wmstderr='tail -f $HOME/.cache/wm-logs/stderr'
alias wmstdout='tail -f $HOME/.cache/wm-logs/stdout'
alias scrubstart='sudo btrfs scrub start'
alias scrubstatus='sudo btrfs scrub status'
alias scrublive='sudo btrfs scrub start /; watch -n 1 sudo btrfs scrub status /'
alias largesthome='btrfs fi du ~/ | sort -h'
alias largestroot='sudo btrfs fi du / | sort -h'
alias threads='ps --no-headers -Leo user | sort | uniq --count'
alias setuid='find /usr/bin -perm "/u=s,g=s"'
alias smart='sudo smartctl -a $(sudo fdisk -l | grep "Disk /dev/" | cut -d " " -f2 | tr -d ":")'
alias services='systemctl --type=service --state=running'
alias c='clear'
alias trim='sudo fstrim -av'
alias rsync='rsync -P'
alias free="free -mth"
alias da='date "+%Y-%m-%d %A    %T %Z"'
alias sb='source ~/.bashrc'
alias xlx='xrdb -load $HOME/.Xresources'
alias errorlog='journalctl -p 3 -b'
alias brokensym='sudo find / -xtype l -print'
alias portcheck='nc -v -i1 -w1' # Test port connection - Usage: portcheck 192.168.122.137 22
alias ports='netstat -nape --inet'
alias ns='netstat -alnp --protocol=inet | grep -v CLOSE_WAIT | cut -c-6,21-94 | tail +2'
alias intercept="sudo strace -ff -e trace=write -e write=1,2 -p" #given a PID, intercept the stdout and stderr
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e" # search processes (find PID easily)
alias psf="ps auxfww" # show all processes
alias localip='ifconfig | sed -rn "s/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p"' # Show local primary IP address
alias rng='watch -n 1 cat /proc/sys/kernel/random/entropy_avail'
alias scheduler='grep "" /sys/block/*/queue/scheduler'
alias upde='sudo pacman -Syu && paru -Syu'
alias xls='xlsclients'
alias err='journalctl -b -p err'
alias sysdblame='systemd-analyze plot > $HOME/Pictures/boot.svg'
alias rr='ranger'

# add an "alert" alias for long running commands, Usage: "sleep 10; alert"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# selinux troubleshooting
alias errsel='sudo ausearch -m AVC,USER_AVC,SELINUX_ERR,USER_SELINUX_ERR'

# docker aliases
alias lzd='lazydocker'
alias dcu='docker compose up -d'
alias dcd='docker compose down'

# compile in docker toolchain, usage: dtc "docker image"
dtc() { 
  docker run --rm -v "$PWD":/source -w /source "$@"
}

# podman aliases 
alias pcu='podman compose up -d'
alias pcd='podman compose down'
alias pls='podman container ps --all'

# compile in podman toolchain, usage: ptc "docker image"
ptc() {
  podman run --rm -it -v "$PWD":/source:z -w /source "$@"
}

ptr() {
  podman run -it -w / "$@"
}

alias sdu='systemctl --user start'
alias sdd='systemctl --user stop'
alias sdr='systemctl --user daemon-reload'
alias dryrun='/usr/lib/systemd/system-generators/podman-system-generator --user --dryrun'
alias qhd='cd .config/containers/systemd/'

# compile for psp using pspdev toolchains
alias pspmake='ptc docker.io/spiritfader/pspdev-plus:latest make'
#alias pspsdkmake='ptc docker.io/pspdev/pspdev:latest make'
#alias pspkzmake='ptc docker.io/krazynez/ark-4:latest make'

# launch psp app for testing
alias pspur='ppsspp $HOME/Git/spiritfader/UMDRescue/PSP/GAME150/__SCE__UMDRescue/EBOOT.PBP'

export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

# update the latest pspsdk toolchain
updpspdev(){
  curl -L https://github.com/pspdev/pspdev/releases/latest/download/pspdev-ubuntu-latest-x86_64.tar.gz | tar -zxvf - -C "$HOME"
  mv "$HOME/pspdev" "$HOME/.pspdev"
}

# flatpak aliases
if command -v flatpak run org.winehq.Wine &> /dev/null && ! command -v wine &> /dev/null; then alias wine='flatpak run org.winehq.Wine'; fi
if command -v com.openwall.John &> /dev/null && ! command -v john &> /dev/null; then alias john='com.openwall.John'; fi
if command -v io.gitlab.librewolf-community &> /dev/null && ! command -v librewolf &> /dev/null; then alias librewolf='io.gitlab.librewolf-community'; fi
if command -v org.mozilla.firefox $> /dev/null && ! command -v firefox &> /dev/null; then alias firefox='org.mozilla.firefox'; fi
if command -v org.videolan.VLC &> /dev/null && ! command -v vlc &> /dev/null; then alias vlc='org.videolan.VLC'; fi
if command -v org.kde.dolphin &> /dev/null && ! command -v dolphin &> /dev/null; then alias dolphin='org.kde.dolphin'; fi
if command -v org.ppsspp.PPSSPP &> /dev/null && ! command -v ppsspp &> /dev/null; then alias ppsspp='org.ppsspp.PPSSPP'; fi

# digital forensics
alias loginsh='cat /etc/passwd | grep sh$'
alias allcron='for i in $(cat /etc/passwd | grep sh$ | cut -f1 -d: ); do echo $i; sudo crontab -u $i -l; done'
alias loginshcron='for i in $(cat /etc/passwd | grep sh$ | cut -f1 -d: ); do echo $i; sudo crontab -u $i -l; done'

# clone a hard disk to another, usage: 'clonedisk2disk /dev/sda /dev/sda' clonedisk2disk [source] [destination]
clonedisk2disk() {
  sudo sh -c dd if="$1" of="$2" bs=64K conv=noerror,sync status=progress
}

# image a hard disk to a compressed file, usage: 'imagedisk2file /dev/sda file_to_write_to.img' clonedisk2file [source-disk] [destination-file]
imagedisk2file() {
  dd if="$1" conv=sync,noerror bs=64K | gzip -c  > "$2".img.gz
  fdisk -l "$1" > "$2".info
}

# encrypt and overwrite drive with encrypted cipher for secure erase - Usage: encryptwholeerase "/dev/sdX"
encryptwholeerase() {
  DEVICE="$1"; PASS=$(tr -cd '[:alnum:]' < /dev/urandom | head -c 1024)
  openssl enc -aes-256-ctr -pass pass:"$PASS" -nosalt < /dev/zero | dd obs=64K ibs=4K of="$DEVICE" oflag=direct status=progress
}

# encrypt and overwrite free space with encrypted cipher for secure erase - Usage: encryptfreeerase
encryptfreeerase() {
  PASS=$(tr -cd '[:alnum:]' < /dev/urandom | head -c 1024)
  openssl enc -pbkdf2 -pass pass:"$PASS" -nosalt < /dev/zero | dd obs=128K ibs=4K of="Eraser" oflag=direct status=progress
  rm -f "Eraser"
}

# proxmox/virtualization tools
alias iommugroup='find /sys/kernel/iommu_groups/ -type l | sort -V'
alias iommusupport='sudo dmesg | grep -e DMAR -e IOMMU -e AMD-Vi'
alias pcidsupport="grep ' pcid ' /proc/cpuinfo"
alias cpuvuln='for f in /sys/devices/system/cpu/vulnerabilities/*; do echo "${f##*/} -" $(cat "$f"); done'

# check for hugepage support
hugepage() {
  grep -e AnonHugePages  /proc/*/smaps | awk  '{ if($2>4) print $0} ' |  awk -F "/"  '{printf $0; system("ps -fp " $3)} '
}

# git tools___________________________________________________________________
alias gadd='git add'
alias gpush='git push'
alias gshow='git ls-tree --full-tree -r --name-only HEAD'

gcom(){
  git commit -m "$*"
}

gcompush(){
  git commit -m "$*"; git push
}
alias gst='git status'
alias gcl='git clone'
alias gpull='git pull'
alias gfet='git fetch'
alias gbr='git branch -a'

# converts regular github repo link to private link that can be cloned
# usage: pcl https://github.com/username/repo
pcl(){
  git clone "${1/#https:\/\/github.com/git@github.com:}"
}

git_update_all() {
  find . -maxdepth 1 -print0 | xargs -P10 -I{} git -C {} pull
}

# dotfile Management _________________________________________________________
alias dtf='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dfpush='dtf push origin'
alias dfshow='dtf ls-tree --full-tree -r --name-only HEAD'
alias dfs='dtf status'

dfc(){
  dtf commit -am "$*"
}

# Dotfile Management System - Loop through ".$HOME/.dotfiles.conf" of files, check to see if file within exists and track it in the bare repo
dftrack(){
  untrack+=();

  # initialize array to hold dir/files to be "untracked" and removed from .dotfiles.conf
  wdir=$(pwd | sed "s|$HOME|\$HOME|");

  # loop through $HOME/.dotfiles.conf
  while IFS="" read -r p || [ -n "$p" ]; do

    # if dir/file does not exist within filesystem, add to "untracked" array
    if ! [[ $p ]]; then
      untrack+=("$p");
    fi

    # if dir/file exists within fs, track it with "git add"
    if [[ $p ]]; then
      dtf -C "$HOME" add "${p##\$HOME/}"
    fi
  done < "$HOME/.dotfiles.conf"

  # remove dir & files from .dotfiles.conf that are in array and untrack from git with "git rm --cached"
  for i in "${untrack[@]}"; do
    sed -i "\:$i:d" "$HOME/.dotfiles.conf"
    if [[ -e "$p" ]]; then
      dtf rm -r --cached "$i";
    fi;
  done

  # unset "untracked" variable to keep consecutive runs clean
  unset untrack

  sort -o "$HOME/.dotfiles.conf" "$HOME/.dotfiles.conf"
}

# Dotfile Management System - Add file(s) to tracked dotfiles
dfadd(){
  wdir=$(pwd | sed "s|$HOME|\$HOME|");

  # Loop through tracked dotfiles (.dotfiles.conf)
  for i in "$@"; do
    if [[ -e "$(pwd)/$i" ]]; then
      if grep -q "^$wdir/$i$" "$HOME"/.dotfiles.conf; then
        printf '%s\n' "dir/file already exists within tracked file, skipping.";
      fi;

      # if dir/file exists and is already in tracked file, do nothing.
      if ! grep -q "^$wdir/$i$" "$HOME"/.dotfiles.conf; then
        printf '%s\n' "$wdir/$i" >> "$HOME"/.dotfiles.conf;
      fi;
    fi;

    # if dir/file exists but is not in file, add it.
    if ! [[ -e "$(pwd)/$i" ]]; then
      # if dir/file does not exist, skip and do nothing.
      printf '%s\n' "The dir/file $wdir/$i cannot be located. Skipping.";
    fi
  done;
  sort -o "$HOME/.dotfiles.conf" "$HOME/.dotfiles.conf"
}

# miscellaenous programs/functions_____________________________________________

# output power scaling driver
powersch() {
  SCALING_DRIVER="$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver)"
  tput setaf 2;printf '%s\n\n' "Scaling Driver in-use: $(tput setaf 4;cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_driver | uniq)"
  tput setaf 2;printf '%s\n' "Governor in-use: $(tput setaf 4;cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor | uniq)"
  tput setaf 2;printf '%s\n' "Available Governors: $(tput setaf 4;cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_available_governors| uniq)"

  if [ "$SCALING_DRIVER" = "amd-pstate-epp" ]; then
    tput setaf 2;printf '\n%s\n' "EPP in-use: $(tput setaf 4;cat /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference | uniq)"
    tput setaf 2;printf '%s\n' "Available EPP: $(tput setaf 4;cat /sys/devices/system/cpu/cpufreq/policy*/energy_performance_available_preferences | uniq)"
  fi
}

# update all system programs
upd() {

  # Arch Linux
  if command -v pacman &> /dev/null; then
    if command -v pacman &> /dev/null; then tput setaf 2; printf '%s\n' "Arch Official Repos (pacman -Syu):"; tput sgr0; sudo pacman -Syu; fi
    if command -v paru &> /dev/null; then tput setaf 2; printf '\n%s\n' "Arch User Repository (paru -Syu):"; tput sgr0; paru -Syu; fi
    if command -v yay &> /dev/null; then tput setaf 2; printf '\n%s\n' "Arch User Repository (paru -Syu):"; tput sgr0; yay -Syua; fi
    if command -v updatedb &> /dev/null; then tput setaf 2; printf '\n%s\n' "Update locate/plocate database..."; tput sgr0; sudo updatedb; fi
    if command -v pkgfile &> /dev/null; then tput setaf 2; printf '\n%s\n' "Update pkgfile database (pkgfile -u):"; tput sgr0; sudo pkgfile -u; fi
    if command -v pacman &> /dev/null; then  tput setaf 2; printf '\n%s\n' "Update pacman file database (pacman -Fy):"; tput sgr0; sudo pacman -Fy; fi
    if command -v pacman-db-upgrade &> /dev/null; then tput setaf 2; printf '\n%s\n' "Upgrade pacman database"; tput sgr0; sudo pacman-db-upgrade; fi
    if command -v pacman &> /dev/null; then tput setaf 2; printf '\n%s\n' "Clear pacman cache:"; tput sgr0; yes | sudo pacman -Scc;
      if command -v paru &> /dev/null; then yes | paru -Scc; fi;
      if command -v yay &> /dev/null; then yes | yay -Scc; fi;
    fi
  fi

  # OpenSUSE
  if command -v zypper &> /dev/null; then
    if command -v zypper &> /dev/null; then tput setaf 2; printf '\n%s\n' "OpenSUSE Repos (zypper refresh):"; tput sgr0; sudo zypper -v refresh; fi
    if command -v zypper &> /dev/null; then tput setaf 2; printf '\n%s\n' "OpenSUSE Repos (zypper dist-upgrade):"; tput sgr0; sudo zypper -v dup; fi
    if command -v zypper &> /dev/null; then tput setaf 2; printf '\n%s\n' "OpenSUSE Repos (zypper clean):"; tput sgr0; sudo zypper -v clean; fi
    if which -v sbctl &> /dev/null; then tput setaf 2; printf '\n%s\n' "Secure Boot Signing (sbctl sign-all):"; tput sgr0; sudo sbctl sign-all; fi
  fi

  # Fedora/RHEL (DNF)
  if command -v dnf &> /dev/null; then # if Fedora/RHEL
    if command -v dnf &> /dev/null; then  tput setaf 2; printf '\n%s\n' "RHEL/Fedora Repos (dnf upgrade):"; tput sgr0; sudo dnf upgrade --assumeyes; fi
  fi

   # Fedora/RHEL (yum)
  if command -v yum &> /dev/null; then
    if command -v yum &> /dev/null; then tput setaf 2; printf '\n%s\n' "RHEL/Fedora Repos (yum update/yum upgrade):"; tput sgr0; sudo yum update; sudo yum upgrade; fi
  fi

  # Debian
  if command -v apt &> /dev/null; then
    if command -v apt &> /dev/null; then tput setaf 2; printf '\n%s\n' "Debian Repos (apt update/apt upgrade):"; tput sgr0; sudo apt update; sudo apt upgrade; fi
  fi

  # Alpine
  if command -v pkg &> /dev/null; then
    if command -v pkg &> /dev/null; then tput setaf 2; printf '\n%s\n' "Alpine Repos (pkg update/pkg upgrade):"; tput sgr0; sudo pkg update; sudo pkg upgrade; fi
  fi

  # Flatpak
  if command -v flatpak &> /dev/null; then tput setaf 2; printf '\n\n%s\n' "Flatpak (flatpak --user update):"; tput sgr0; flatpak --user -y update; flatpak uninstall --unused -y;fi

  # Snap
  if command -v snap &> /dev/null; then  tput setaf 2; printf '\n%s\n' "Snap (snap refresh):"; tput sgr0; sudo snap refresh; fi
  sync && printf '\n'

}

# measure packets per second on an interface
netpackets() {

  # Refactored from code written by Joe Miller (https://github.com/joemiller)
  # The following script periodically prints out the number of RX/TX packets for a given network interface (to be provided as an argument to the script).

  # default to wlan0 if no interface is provided
  if [ -z "$1" ]
  then
    set -- "wlan0"
  fi

  # update interval in seconds
  INTERVAL="1"

  printf '%s\n' "usage: $0 network-interface"
  printf '%s\n' "e.g. $0 eth0"
  printf '%s\n' "shows packets-per-second"

  while true
    do
      R1=$(cat /sys/class/net/"$1"/statistics/rx_packets)
      T1=$(cat /sys/class/net/"$1"/statistics/tx_packets)
      sleep $INTERVAL
      R2=$(cat /sys/class/net/"$1"/statistics/rx_packets)
      T2=$(cat /sys/class/net/"$1"/statistics/tx_packets)
      TXPPS=$((T2 - T1))
      RXPPS=$((R2 - R1))
      printf '\n%s%18s%s%18s' "TX $1:" "$TXPPS pkts/s " "RX $1:" "$RXPPS pkts/s"
  done
}

# measure network bandwidth on an interface
netspeed() {
  # Refactored from code written by Joe Miller (https://github.com/joemiller)
  # The following script periodically prints out the RX/TX bandwidth (KB/s) for a given network interface (to be provided as an argument to the script).

  # default to wlan0 if no interface is provided
  if [ -z "$1" ]
  then
    set -- "wlan0"
  fi

  INTERVAL="1"  # update interval in seconds

  printf '%s\n' "usage: netspeed network interface"
  printf '%s\n' "ie: netspeed eth0"
  printf '%s\n' "Printing kB/s:"

  while true
    do
      R1=$(cat /sys/class/net/"$1"/statistics/rx_bytes)
      T1=$(cat /sys/class/net/"$1"/statistics/tx_bytes)
      sleep $INTERVAL
      R2=$(cat /sys/class/net/"$1"/statistics/rx_bytes)
      T2=$(cat /sys/class/net/"$1"/statistics/tx_bytes)
      TBPS=$((T2 - T1))
      RBPS=$((R2 - R1))
      TKBPS=$((TBPS / 1024))
      RKBPS=$((RBPS / 1024))
      printf '\n%s%18s%s%18s' "TX $1:" "$TKBPS kB/s " "RX $1:" "$RKBPS kB/s"
  done
}

# verify flac files for corruption - flacverify [dir]
flacverify() { 
  find -L "$1" -type f -name '.flac' -print0 | while IFS= read -r -d '' file
  do printf '%3d %s\n' "$?" "$(tput sgr0)checking $(realpath "$file")";flac -wst "$file" 2>/dev/null || printf '%3d %s\n' "$?" "$(tput setaf 1;\
  realpath "$file") is corrupt $(tput sgr0)" | tee -a ~/corruptedFlacsList.txt
  done

}

# read file in and append pagenumbers to each line
appendPagination() {  
  while IFS="" read -r p || [ -n "$p" ]
  do
    for i in {2..50}
    do
      echo "$p$i" >> appended-"$1".txt
    done
  done < "$1"
}

packetDrop() {
  printf '%s\n' "netstat -s | grep segments retransmitted" "$(netstat -s | grep "segments retransmitted")"
  printf '%s\n' "ifconfig -a | grep X errors" "$(ifconfig -a | grep "X errors")"
}

# search for text in firefox with pre-configured search engine
ffs (){ 
  firefox -search "$*";exit 
}

# kill a given process by name
pskill() { 
  pgrep "$1" | grep -v grep | awk '{ print $1 }' | xargs kill
}

# wrap in loop to evaluate command, statement, or idea OR use confirm()
ask() { 
  echo -n "$@" '[y/n] ' ; read -r ans
  case "$ans" in
    y*|Y*) return 0 ;;
    *) return 1 ;;
  esac
}

# usage: confirm ls or confirm htop, etc.
confirm() {
  if ask "$1"; then 
    "$1" 
  fi
}

# Convert unix time to human readable - Usage: utime unixtime "utime 23454236" 
utime() { 
  if [ -n "$1" ]; then
    printf '%(%F %T)T\n' "$1"
  fi
}

# Pulls quote
quote() { 
  curl -s https://favqs.com/api/qotd | jq -r '[.quote.body, .quote.author] | "\(.[0]) \n~\(.[1])\n"'
}

# Repeat n times command. Usage: "repeat 20 ls"
repeat() { 
  local i max
  max=$1; shift;
  for ((i=1; i <= max ; i++)); do  # --> C-like syntax
    "$@";
  done
}

# check top ten commands executed
top10() { 
  all=$(history | awk '{print $2}' | awk 'BEGIN {FS="|"}{print $1}') 
  printf '%s\n' "$all" | sort | uniq -c | sort -n | tail | sort -nr
}

# returns a bunch of information about the current host, useful when jumping around hosts a lot
ii() {
  printf '%s\n\n' "You are logged on to $HOSTNAME"
  printf '%s\n%5s\n\n' "Kernel information: " "$(uname -a)"
  printf '%s\n\n\n' "Users logged on: $(PROCPS_USERLEN=32 w -hs | cut -d " " -f1 | sort | uniq)"
  printf '%s\n\n\n' "Current date: $(date)"
  printf '%s\n\n\n' "Machine stats: uptime is $(uptime | awk /'up/ {print $3,$4,$5,$6,$7,$8,$9,$10}')"
  printf '%s\n%5s\n\n' "Memory stats: " "$(free)"
  printf '%s\n%5s\n\n' "Diskspace: " "$(df -h / "$HOME")"
  printf '%s\n%5s\n\n' "Local IP Address:" "$(ip -4 addr | grep -v 127.0.0.1 | grep -v secondary | grep "inet" | awk '{print $2}' ; ip -6 addr | grep -v ::1 | grep -v secondary | grep "inet" | awk '{print $2}')"
  #printf '%s\n' ""
}

# print uptime, host name, number of users, and average load
upinfo() {
  printf '%s\n' "$HOSTNAME uptime is $(uptime | awk /'up/ {print $3,$4,$5,$6,$7,$8,$9,$10}')"
}

# swap the names/contents of two files
swapname() { # Swap 2 filenames around, if they exist (from Uzi's bashrc). - Usage: swapname file1 file2
  local TMPFILE=tmp.$$
  [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
  [ ! -e "$1" ] && echo "swap: $1 does not exist" && return 1
  [ ! -e "$2" ] && echo "swap: $2 does not exist" && return 1
  mv "$1" $TMPFILE
  mv "$2" "$1"
  mv $TMPFILE "$2"
}

# disables ctrl+z for the wrapped command ($1) 
nopause(){
  trap "" SIGTSTP # send signal 20
  "$1"
}

# compare the md5 of a file to a known sum
md5check() { 
  md5sum "$1" | grep "$2";
}

# report disk usage of directory and sort files by size
dusort() {
  find "$@" -mindepth 1 -maxdepth 1 -exec du -sch {} + | sort -h
}

## traverse up a number of directories | cu -> cd ../ | cu 2 -> cd ../../ |  cu 3 -> cd ../../../
#..() {
#  local count="$1"
#  if [ -z "${count}" ]; then
#    count=1
#  fi
#  local path=""
#  for i in $(seq 1 "${count}"); do
#    path="${path}../"
#  done
#  cd "$path" || exit
#}

# open all modified files in vim tabs
nvimod() {
    nvim -p "$(git status -suall | awk '{print $2}')"
}

# open files modified in a git commit in nvim tabs; defaults to HEAD. Usage: "virev 49808d5" or "virev HEAD~3"
virev() {
  commit=$1
  if [ -z "${commit}" ]; then
    commit="HEAD"
  fi
  rootdir=$(git rev-parse --show-toplevel)
  sourceFiles=$(git show --name-only --pretty="format:" "${commit}" | grep -v '^$')
  toOpen=""
  for file in ${sourceFiles}; do
    file="${rootdir}/${file}"
    if [ -e "${file}" ]; then
      toOpen="${toOpen} ${file}"
    fi
  done
  if [ -z "${toOpen}" ]; then
    echo "No files were modified in ${commit}"
    return 1
  fi
  nvim -p "${toOpen}"
}

# [e]xtract to [f]older = extracts archives into folders - usage: ex <file>
extract() {
  SAVEIFS=$IFS
  IFS="$(printf '\n\t')"
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf "$1";;
      *.tar.gz)    tar xzf "$1";;
      *.bz2)       bunzip2 "$1";;
      *.rar)       7z x -o"${1%.rar}" "$1";;
      *.gz)        gunzip "$1";;
      *.tar)       mkdir "${1%.tar}"; tar -xvf "$1" -C "${1%.tar}";;
      *.tbz2)      tar xjf "$1";;
      *.tgz)       tar xzf "$1";;
      *.zip)       7z x -o"${1%.zip}" "$1";; 
      *.Z)         uncompress "$1";;
      *.7z)        7z x -o"${1%.7z}" "$1" ;;
      *.iso)       7z x -o"${1%.iso}" "$1";;
      *.lzm)       7z x -o"${1%.lzm}" "$1";;
      *.deb)       ar x "$1";;
      *.tar.xz)    tar xf "$1";;
      *.tar.zst)   tar xf "$1";;
      *)           printf "%s" "$1 cannot be extracted";;
    esac
  else
    printf '%s' "$1 is not a valid file"
  fi
  IFS=$SAVEIFS
}

# [e]xtract[h]ere = extracts files loosely into directory - usage: exhere <file>
eh() {
  SAVEIFS=$IFS
  IFS="$(printf '\n\t')"
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)        tar xjf "$1";;
      *.tar.gz)         tar xzf "$1";;
      *.bz2)            bunzip2 "$1";;
      *.rar)            unrar x "$1";;
      *.gz)             gunzip "$1";;
      *.tar)            tar xf "$1";;
      *.tbz2)           tar xjf "$1";;
      *.tgz)            tar xzf "$1";;
      *.zip)            unzip "$1";;
      *.Z)              uncompress "$1";;
      *.7z|*.iso|.lzm)  7z x "$1";;
      *.deb)            ar x "$1";;
      *.tar.xz)         tar xf "$1";;
      *.tar.zst)        tar xf "$1";;
      *)                printf "%s" "$1 cannot be extracted";;
    esac
  else
    printf '%s' "$1 is not a valid file"
  fi
  IFS=$SAVEIFS
}

# file compression wrapper - Usage: "compress DESTINATION{.ext}  FILE(S)"
compress() { 
  DEST=$1
  case $DEST in
    *.tar.bz2)   tar cjf "${DEST::-8}" "$@";;
    *.tar.gz)    tar czf "${DEST::-7}" "$@";;
    *.tgz)       tar czf "${DEST::-4}" "$@";;
    *.zip)       7z a -tzip "${DEST::-4}" "$@";;
    *.rar)       rar "${DEST::-4}" "$@";;
    *.7z)        7z a -t7z -m0=lzma2 -mx=9 -mfb=64 -md=64m -ms=on "${DEST::-3}" "$@";;
  esac
}

# frees ram buffer
buffer_clean() { 
  free -h && sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches' && free -h
}

# calculate the input string using bc command (it's a calculator)
calc() { 
  echo "$*" | bc;
}

mktargz() { 
  tar czf "${1%%/}.tar.gz" "${1%%/}/"; 
}

# take ownership of file
mkown() { 
  sudo chown -R "$(whoami)" "${1:-.}"; 
}

# change ownership of group on file to self
mkgrp() { 
  sudo chgrp -R "$(whoami)" "${1:-.}"; 
}

# make directory and move file into it - Usage: "mkmv filetobemoved.txt NewDirectory"
mkmv() { 
  mkdir "$2"
  mv "$1" "$2"
}

## make directory and immediately enter it
#md() {
#  mkdir -p "$@" && cd "$@" || exit
#}

# prints ANSI 16-colors
ansicolortest() {
  T='ABC'   # The test text
  echo -ne "\n\011\011   40m     41m     42m     43m"
  echo -e "     44m     45m     46m     47m";
  fff=('    m' '   1m' '  30m' '1;30m' '  31m' '1;31m')
  fff2=('  32m' '1;32m' '  33m' '1;33m' '  34m' '1;34m')
  fff3=('  35m' '1;35m' '  36m' '1;36m' '  37m' '1;37m')
  FGS=("${fff[@]}" "${fff2[@]}" "${fff3[@]}")
  for FGs in "${FGS[@]}";
  do FG=${FGs// /}
  echo -en " $FGs\011 \033[$FG  $T  "
  for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
  do echo -en "$EINS \033[$FG\033[$BG  $T \033[0m\033[$BG \033[0m";
  done
  echo ""
  done
  echo ""
}

# prints xterm 256 colors
256colortest() {
  echo -en "\n   +  "
  for i in {0..35}; do
  printf "%2b " "$i"
  done
  printf "\n\n %3b  " 0
  for i in {0..15}; do
  echo -en "\033[48;5;${i}m  \033[m "
  done
  #for i in 16 52 88 124 160 196 232; do
  for i in {0..6}; do
  ((i = i*36 +16))
  printf "\n\n %3b  " $i
  for j in {0..35}; do
  ((val = i+j))
  echo -en "\033[48;5;${val}m  \033[m "
  done
  done
  echo -e "\n"
}

showcolors256() {
    local row col blockrow blockcol red green blue
    local showcolor=_showcolor256_${1:-bg}
    local white="\033[1;37m"
    local reset="\033[0m"

    echo -e "Set foreground color: \\\\033[38;5;${white}NNN${reset}m"
    echo -e "Set background color: \\\\033[48;5;${white}NNN${reset}m"
    echo -e "Reset color & style:  \\\\033[0m"
    echo

    echo 16 standard color codes:
    for row in {0..1}; do
        for col in {0..7}; do
            $showcolor $(( row*8 + col )) "$row"
        done
        echo
    done
    echo

    echo 6·6·6 RGB color codes:
    for blockrow in {0..2}; do
        for red in {0..5}; do
            for blockcol in {0..1}; do
                green=$(( blockrow*2 + blockcol ))
                for blue in {0..5}; do
                    $showcolor $(( red*36 + green*6 + blue + 16 )) $green
                done
                echo -n "  "
            done
            echo
        done
        echo
    done

    echo 24 grayscale color codes:
    for row in {0..1}; do
        for col in {0..11}; do
            $showcolor $(( row*12 + col + 232 )) "$row"
        done
        echo
    done
    echo
}

_showcolor256_fg() {
  local code
  code=$( printf %03d "$1" )
  echo -ne "\033[38;5;${code}m"
  echo -nE " $code "
  echo -ne "\033[0m"
}

_showcolor256_bg() {
  if (( $2 % 2 == 0 )); then
      echo -ne "\033[1;37m"
  else
      echo -ne "\033[0;30m"
  fi
  local code
  code=$( printf %03d "$1" )
  echo -ne "\033[48;5;${code}m"
  echo -nE " $code "
  echo -ne "\033[0m"
}

# scan subnet for active systems (arp scan) - Usage: subnetscan 192.168.122.1/24
subnetscan() {
  nmap -v -sn "${1}" -oG - | awk '$4=="Status:" && $5=="Up" {print $2}'
}

# scan subnet for available IPs - Usage: subnetfree 192.168.122.1/24
subnetfree() {
  nmap -v -sn -n "${1}" -oG - | awk '/Status: Down/{print $2}'
}

# network port scan of an IP, quick scan - Usage: quickportscan 192.168.122.37
quickportscan() {
  nmap -T4 -F "${1}" | grep "open"
}

# network port scan of an IP, all ports - Usage: allportscan 192.168.122.37
allportscan() {
  nmap -T4 -p 1-65535 "${1}" | grep "open"
}

# trace a packet on a single IP - Usage "tracepacket 192.168.1.1"
tracepacket() { 
  sudo nmap -vv -n -sn -PE -T4 --packet-trace "${1}"
}

stealthscan-dns(){ # use recursive DNS proxies for a stealth scan on a target - Usage: "stealthscan-dns <dns-server1,[dns-server2]> <target>" 
  nmap --dns-servers "${1}" -sL "${2}"
}

# stealth syn scan, OS and version detection, verbose output - Usage: portscan-stealth 192.168.122.1/24 or portscan-stealth 192.168.122.137 1-65535
stealthscan-port() {
  sudo nmap -v -p "${2}" -sV -O -sS -T5 "${1}" 
}

# detect if a website is protected by such a web-application firewall - usage: "wafscan url"
wafscan(){
  nmap -p443 --script http-waf-detect --script-args="http-waf-detect.aggro,http-waf-detect.detectBodyChanges" "${1}"
}

# detect frame drops using `ping` - Usage: pingdrops 192.168.122.137
pingdrops() { 
  ping "${1}" | grep -oP --line-buffered "(?<=icmp_seq=)[0-9]{1,}(?= )" | awk '$1!=p+1{print p+1"-"$1-1}{p=$1}'
}

# use curl to check URL connection performance - urltest https://google.com
urltest() { 
  URL="$*"
  if [ -n "${URL[0]}" ]; then
    curl -L --write-out "URL,DNS,conn,time,speed,size\n%{url_effective},%{time_namelookup} (s),%{time_connect} (s),%{time_total} (s),%{speed_download} (bps),%{size_download} (bytes)\n" \
-o/dev/null -s "${URL[0]}" | column -s, -t
  fi
}

# list processes associated with a port - Usage: "portproc 22"
portproc() { 
  port="${1}"
  if [ -n "${port}" ]
  then
    for proto in tcp udp
    do
      for pid in $(fuser "${port}"/${proto} 2>/dev/null | awk -F: '{print $NF}')
      do
        ps -eo user,pid,lstart,cmd | awk -v pid="$pid" '$2 == pid'
      done
    done 
  fi
}

# generate a file of randomized data and certain size - Usage: filegen <size> <location> <(a)lpha, (n)umeric, (r)andom, (b)inary>
filegen() {  
  s="${1}"
  if [ -z "${s}" ]; then s="1M"; fi
  fsize="$(echo "${s}" | grep -Eo '[0-9]{1,}')"
  sunit="$(echo "${s}" | grep -oE '[Aa-Zz]{1,}')"
  (( ssize = fsize * 6 ))
  f="${2}"
  if [ -z "${f}" ] || [ -f "${f}" ]; then f="$(mktemp)"; fi
  case "${3}" in
      -a)  head -c "${fsize}${sunit}" <(head -c "${ssize}${sunit}" </dev/urandom | tr -dc A-Za-z0-9) > "${f}" ;;
      -n)  head -c "${fsize}${sunit}" <(head -c "${ssize}${sunit}" </dev/urandom | tr -dc 0-9) > "${f}" ;;
      -r)  head -c "${fsize}${sunit}" <(head -c "${ssize}${sunit}" </dev/urandom) > "${f}"  ;;
      -b)  head -c "${fsize}${sunit}" <(head -c "${ssize}${sunit}" </dev/urandom | tr -dc 0-1) > "${f}" ;;
  esac
  ls -alh "${f}"
}

# animated gifs from any video - https://gist.github.com/SlexAxton/4989674
gifify() { 
  if [[ -n "$1" ]]; then
    if [[ $2 == '--good' ]]; then
      ffmpeg -i "$1" -r 10 -vcodec png out-static-%05d.png
      time convert -verbose +dither -layers Optimize -resize 600x600\> out-static*.png  GIF:- | gifsicle --colors 128 --delay=5 --loop --optimize=3 --multifile - > "$1".gif
      rm out-static*.png
    else
      ffmpeg -i "$1" -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > "$1".gif
    fi
  else
    echo "proper usage: gifify <input_movie.mov>. You DO need to include extension."
  fi
}

usbmodem() {
  modem=$(for i in /dev/cu.*; do grep -vi bluetooth | tail -1; done)
  baud=${1:-9600}
  if [ -n "$modem" ]; then
    minicom -D "$modem"  -b "$baud"
  else
    printf '%s' "No USB modem device found in /dev"
  fi
}

tree_size() {
	du -a ./* | sort -r -n | head -20
}

# Apple Protection On/Off (only available on mac running bash, outdated)
appleProtection() {
  case "$1" in
     on)       sudo spctl --master-enable ;;
    off)       sudo spctl --master-disable ;;
      *)       printf '%s' "Must input on or off; exiting" ;;
  esac
}

videotag() {
  if [ $# -lt 1 ]; then
    echo "Examples of usage:"
    echo -e "\t tag_remove <path_to_file> - remove all tags from video"
    echo -e "\t tag_remove -t [--tag] <path_to_file> <title> <comment>"
  fi

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Examples of usage:"
    echo -e "\t tag_remove <path_to_file> - remove all tags from video"
    echo -e "\t tag_remove -t [--tag] <path_to_file> <title> <comment>"
  fi


  if [[ "$1" == "-t" || "$1" == "--tag" ]]; then
    if [ "$#" -ne 4 ]; then
      echo "Examples of usage:"
      echo -e "\t tag_remove <path_to_file> - remove all tags from video"
      echo -e "\t tag_remove -t [--tag] <path_to_file> <title> <comment>"
    else	

    FILEFULL=$2
    FILE="${FILEFULL%.*}"
    EXT="${FILEFULL##*.}"
    OUTPUT="$FILE.$$.$EXT"

    ffmpeg -i "$FILEFULL" -vcodec copy -acodec copy -map_metadata -1 -metadata title="$3" -metadata comment="$4" "$OUTPUT"
      fi
  else

    FILEFULL="$1"
    FILE="${FILEFULL%.*}"
    EXT="${FILEFULL##*.}"
    OUTPUT="$FILE.$$.$EXT"

    if [ -f "$FILEFULL" ]; then
      ffmpeg -i "$FILEFULL" -vcodec copy -acodec copy -map_metadata -1 -metadata title="F4ck 0ff" -metadata comment="" "$OUTPUT"
    else
      echo "$FILEFULL - does not exist!"
    fi
  fi
}

