#!/bin/bash
#
# ~/.bashrc: executed by bash(1) for non-login shells.
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source /usr/share/git/git-prompt.sh

# Default umask. A umask of 022 prevents new files from being created group and world writable.
# file permissions: rwxr-xr-x
#
umask 022

# search path for cd(1)
CDPATH=:$HOME

# Enable the builtin emacs(1) command line editor in sh(1), e.g. C-a -> beginning-of-line.
set -o emacs

# Enable the builtin vi(1) command line editor in sh(1), e.g. ESC to go into visual mode.
# set -o vi

# Set ksh93 visual editing mode:
if [ "$SHELL" = "/bin/ksh" ]; then
  VISUAL=emacs
fi

# Check for user bin $HOME/.local/bin and add to path if it exists and isnt in path
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  PATH="$HOME/.local/bin${PATH:+":$PATH"}"
fi

## Check for user bin $HOME/bin and add to path if it exists and isnt in path
if [ -d "$HOME/bin" ] && [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
  PATH="$HOME/bin${PATH:+":$PATH"}"
fi

#### check for pspdev toolchain and add to path if exists
if [ -d "$HOME/pspdev" ] && [[ ":$PATH:" != *":$HOME/$PSPDEV/bin:"* ]]; then
  export PSPDEV=~/pspdev
  PATH="$HOME/$PSPDEV/bin${PATH:+":$PATH"}"
fi

#### Check for openjdk and add to env variable
if [ -f /etc/profile.d/jre.sh ] && [[ ":$PATH:" != *":/usr/lib/jvm/default/bin:"* ]]; then
  PATH="/usr/lib/jvm/default/bin${PATH:+":$PATH"}"
fi

#### check for ruby gems & add ruby gems to path
if command -v gem &> /dev/null && [ -d "$(gem env user_gemhome)" ] && [[ ":$PATH:" != *":$GEM_HOME/bin:"* ]]; then
  GEM_HOME="$(gem env user_gemhome)"
  export GEM_HOME
  PATH="$GEM_HOME/bin${PATH:+":$PATH"}"
fi

#### Check for go bin and add to path
if [ -d "$(go env GOPATH)" ] && [[ ":$PATH:" != *":$(go env GOBIN):$(go env GOPATH)/bin:"* ]]; then
  PATH="$(go env GOBIN):$(go env GOPATH)/bin${PATH:+":$PATH"}"
fi

#### Check for dotnet and add to path
if command -v dotnet &> /dev/null && [ -d "$HOME/.dotnet/tools"  ] && [[ ":$PATH:" != *":$HOME/.dotnet/tools:"* ]]; then
  PATH="$HOME/.dotnet/tools${PATH:+"$PATH"}"
  export DOTNET_CLI_TELEMETRY_OPTOUT=1
fi

# Set Environment Variables
export EDITOR=nvim
export VISUAL=code-oss
export LD_PRELOAD=""
export HISTSIZE=8192
export HISTCONTROL=ignorespace
#export HISTCONTROL=ignoreboth:erasedups:ignorespace
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export RANGER_LOAD_DEFAULT_RC=FALSE
#export PAGER='less'

shopt -s autocd # Enable auto cd when typing directories 
shopt -s checkwinsize # check the terminal size when it regains control - check winsize when resize
shopt -s histappend # append to the history file, don't overwrite it
shopt -s globstar # the pattern "**" used in a pathname expansion context will match all files and zero or more directories and subdirectories.
shopt -s promptvars # prompt strings undergo parameter expansion, command substitution, arithmetic expansion, and quote removal after being expanded.
#shopt -s no_empty_cmd_completion # Disable completion when the input buffer is empty

bind "set completion-ignore-case on" #ignore upper and lowercase when TAB completion

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Change the window title of X terminals 
case ${TERM} in
	[aEkx]term*|rxvt*|gnome*|konsole*|interix|tmux*|alacritty*)
		PS1='\[\033]0;\u@\h:\w\007\]'
		;;
	screen*)
		PS1='\[\033k\u@\h:\w\033\\\]'
		;;
	*)
		unset PS1
		;;
esac

# # set variable identifying the chroot you work in (used in the prompt below)
# if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
#     debian_chroot=$(cat /etc/debian_chroot)
# fi

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database instead of using /etc/DIR_COLORS. Try to use the external file first to take advantage of user additions.
# We run dircolors directly due to its changes in file syntax and terminal name patching.
use_color=false
if type -P dircolors >/dev/null ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	LS_COLORS=
	if [[ -f ~/.dir_colors ]] ; then
		eval "$(dircolors -b ~/.dir_colors)"
	elif [[ -f /etc/DIR_COLORS ]] ; then
		eval "$(dircolors -b /etc/DIR_COLORS)"
	else
		eval "$(dircolors -b)"
	fi
	# Note: We always evaluate the LS_COLORS setting even when it's the default. 
	#If it isn't set, then `ls` will only colorize by default based on file attributes and ignore extensions (even the compiled in defaults of dircolors). #583814
	if [[ -n ${LS_COLORS:+set} ]]; then
		use_color=true
	else
		# Delete it if it's empty as it's useless in that case.
		unset LS_COLORS
	fi
else
	# Some systems (e.g. BSD & embedded) don't typically come with
	# dircolors so we need to hardcode some terminals in here.
	case ${TERM} in
	[aEkx]term*|rxvt*|gnome*|konsole*|screen|tmux|cons25|*color) use_color=true;;
	esac
fi

# 'Safe' version of __git_ps1 to avoid errors on systems that don't have it, shows git status within bash prompt
gitPrompt () {
  command -v __git_ps1 > /dev/null && __git_ps1 " (%s)"
}

# Set PS1 prompt display
if ${use_color} ; then 
	if [[ ${EUID} == 0 ]] ; then # set root PS1
    PS1+='\[\033[01;32m\]\T \[\033[01;36m\]\w\[\033[01;33m\]$(gitPrompt)\[\033[01;34m\] \$\[\033[00m\]$(if ! [ $(jobs | wc -l) -eq 0 ]; then jobs | wc -l;fi) ' # custom with inline git branch status
	else # set user PS1
    PS1+='\[\033[01;32m\]\T \[\033[01;36m\]\w\[\033[01;33m\]$(gitPrompt)\[\033[01;34m\] \$\[\033[00m\]$(if ! [ $(jobs | wc -l) -eq 0 ]; then jobs | wc -l;fi) ' # custom with inline git branch status
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
# Start bash PS1 prompt on newline if none within previous EOT (FIX, breaks multiple term in tiled wm)
#PS1='$(printf "%$((`tput cols`-1))s\r")'$PS1

# Set 'man' colors
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

# Import colorscheme from 'wal' asynchronously. 
(cat ~/.cache/wal/sequences &)

# You may want to put all your additions into a separate file like ~/.bash_aliases, instead of adding them here directly.
#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# Try to keep environment pollution down, EPA loves us.
unset use_color sh

# Set Aliases
alias ll='ls -lh'
alias la='ls -lha'
alias l='ls -CF'
alias less='less -FR --use-color'
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
alias updaterepo='sudo reflector --verbose -c "United States" --latest 30 --fastest 30 --score 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'
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

# flatpak aliases
if command -v flatpak run org.winehq.Wine &> /dev/null && ! command -v wine &> /dev/null; then alias wine='flatpak run org.winehq.Wine'; fi
if command -v com.openwall.John &> /dev/null && ! command -v john &> /dev/null; then alias john='com.openwall.John'; fi

# pkg manager tools
upd() { # update all system programs
  if command -v pacman &> /dev/null; then # if ARCH LINUX, WIN HUGE
    
    if command -v pacman &> /dev/null; then  tput setaf 2; tput setaf 2; printf '%s\n' "Arch Official Repos (pacman -Syu):"; tput sgr0; sudo pacman -Syu; fi
    
    if command -v paru &> /dev/null; then  tput setaf 2; printf '\n%s\n' "Arch User Repository (paru -Syu):"; tput sgr0; paru -Syu; fi
    
    if command -v yay &> /dev/null; then  tput setaf 2; printf '\n%s\n' "Arch User Repository (paru -Syu):"; tput sgr0; yay -Syua; fi
    
    # add other aur helper eventually for weirdos
        
    if command -v updatedb &> /dev/null; then tput setaf 2; printf '\n%s\n' "Update locate/plocate database..."; tput sgr0; sudo updatedb; fi # update the locate/plocate database
    
    if command -v pkgfile &> /dev/null; then tput setaf 2; printf '\n%s\n' "Update pkgfile database (pkgfile -u):"; tput sgr0; sudo pkgfile -u; fi # update the pkgfile database
        
    if command -v pacman &> /dev/null; then  tput setaf 2; printf '\n%s\n' "Update pacman file database (pacman -Fy):"; tput sgr0; sudo pacman -Fy; fi # update the pacman file database
    
    if command -v pacman-db-upgrade &> /dev/null; then tput setaf 2; printf '\n%s\n' "Upgrade pacman database"; tput sgr0; sudo pacman-db-upgrade; fi # upgrade the local pacman db to a newer format
    
    if command -v pacman &> /dev/null; then tput setaf 2; printf '\n%s\n' "Clear pacman cache:"; tput sgr0; # Remove all files and unused repositories from pacman cache without prompt
      
      yes | sudo pacman -Scc; 
      
      if command -v paru &> /dev/null; then yes | paru -Scc; fi; 
      
      if command -v yay &> /dev/null; then yes | yay -Scc; fi; 
    fi 
  fi
  
  if command -v zypper; then # if OpenSUSE (weird)
    if command -v zypper &> /dev/null; then  tput setaf 2; tput setaf 2; printf '\n%s\n' "OpenSUSE Repos (zypper refresh/zypper dup):"; tput sgr0; sudo zypper refresh; sudo zypper dup; fi
  fi  

  if command -v apt; then # if Debian
    if command -v apt &> /dev/null; then  tput setaf 2; tput setaf 2; printf '\n%s\n' "Debian Repos (apt update/apt upgrade):"; tput sgr0; sudo apt update; sudo apt upgrade; fi
  fi

  if command -v yum; then # if Fedora/RHEL
    if command -v yum &> /dev/null; then  tput setaf 2; tput setaf 2; printf '\n%s\n' "RHEL/Fedora Repos (yum update/yum upgrade):"; tput sgr0; sudo yum update; sudo yum upgrade; fi
  fi

  if command -v pkg; then # Alpine Linux
    if command -v pkg &> /dev/null; then  tput setaf 2; tput setaf 2; printf '\n%s\n' "Alpine Repos (pkg update/pkg upgrade):"; tput sgr0; sudo pkg update; sudo pkg upgrade; fi
  fi

  if command -v flatpak &> /dev/null; then  tput setaf 2; printf '\n\n%s\n' "Flatpak (flatpak --user update):"; tput sgr0; flatpak --user update; flatpak uninstall --unused;fi
  
  if command -v snap &> /dev/null; then  tput setaf 2; printf '\n%s\n' "Snap (snap refresh):"; tput sgr0; sudo snap refresh; fi

  sync && printf '\n'
}
alias reinstall-packages='sudo pacman -Qqn | sudo pacman -S -'
#alias aurlist='sudo pacman -Qqm'
#alias paclist='sudo pacman -Qqn'
alias packagereinstall='sudo pacman -Qqe > packages.txt; sudo pacman -S $(comm -12 <(pacman -Slq | sort) <(sort packages.txt)); rm packages.txt'

# dfir
alias loginsh='cat /etc/passwd | grep sh$'
alias allcron='for i in $(cat /etc/passwd | grep sh$ | cut -f1 -d: ); do echo $i; sudo crontab -u $i -l; done'
alias loginshcron='for i in $(cat /etc/passwd | grep sh$ | cut -f1 -d: ); do echo $i; sudo crontab -u $i -l; done'

clonedisk2disk() { # clone a hard disk to another, usage: 'clonedisk2disk /dev/sda /dev/sda' clonedisk2disk [source] [destination]
  dd if="$1" of="$2" bs=64K conv=noerror,sync status=progress
}

imagedisk2file() { # image a hard disk to a compressed file, usage: 'imagedisk2file /dev/sda file_to_write_to.img' clonedisk2file [source-disk] [destination-file]
  dd if="$1" conv=sync,noerror bs=64K | gzip -c  > "$2".img.gz
  fdisk -l "$1" > "$2".info
}

# proxmox tools
hugepage() {
  grep -e AnonHugePages  /proc/*/smaps | awk  '{ if($2>4) print $0} ' |  awk -F "/"  '{printf $0; system("ps -fp " $3)} '
}

alias iommugroup='find /sys/kernel/iommu_groups/ -type l | sort -V'
alias iommusupport='sudo dmesg | grep -e DMAR -e IOMMU -e AMD-Vi'
alias pcidsupport="grep ' pcid ' /proc/cpuinfo"
alias cpuvuln='for f in /sys/devices/system/cpu/vulnerabilities/*; do printf '%n%s' "${f##*/}" $(cat "$f"); done'

# git tools
alias gadd='git add'
alias gpush='git push'
alias gshow='git ls-tree --full-tree -r --name-only HEAD'
alias gcom='git commit -am'
alias gstat='git status'
alias gclone='git clone'
alias gpull='git pull'
alias gfetch='git fetch'
alias branch='git branch -a'

pgit(){ # usage pgit https://github.com/username/repo - converts regular github repo link to private link that can be cloned
  git clone "${1/#https:\/\/github.com/git@github.com:}"
}

git_update_all() {
	# ls | xargs -I{} git -C {} pull OR for i in */.git; do ( echo $i; cd $i/..; git pull; ); done
	find . -maxdepth 1 -print0 | xargs -P10 -I{} git -C {} pull
}

alias sysdblame='systemd-analyze plot > $HOME/Pictures/boot.svg'

# Dotfile Management
alias dtf='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dfpush='dtf push origin'
alias dfshow='dtf ls-tree --full-tree -r --name-only HEAD'
alias dfc='dtf commit -am'
alias dfs='dtf status'

dftrack(){   # Loop through ".$HOME/.dotfiles.conf" of files, check to see if file within exists and track it in the bare repo
  untrack+=();

  wdir=$(pwd | sed "s|$HOME|\$HOME|");                                            # initialize array to hold dir/files to be "untracked" and removed from .dotfiles.conf
  
  while IFS="" read -r p || [ -n "$p" ]; do                                       # loop through $HOME/.dotfiles.conf
    if ! [[ $p ]]; then
      untrack+=("$p"); 
      #printf '%s%n' "${untrack[@]}" #for testing purposes
    fi                                                                            # if dir/file does not exist within fs, add to "untracked" array
    if [[ $p ]]; then 
      dtf -C "$HOME" add "${p##\$HOME/}"
    fi                                                                            # if dir/file exists within fs, track it with "git add"
  done < "$HOME/.dotfiles.conf"                    
  
    # remove dir & files from .dotfiles.conf that are in array and untrack from git with "git rm --cached"
  for i in "${untrack[@]}"; do 
    sed -i "\:$i:d" "$HOME/.dotfiles.conf"
    if [[ -e "$p" ]]; then 
      dtf rm -r --cached "$i"; 
    fi; 
  done 

  unset untrack                                                                   # unset "untracked" variable to keep consecutive runs clean
  
  sort -o "$HOME/.dotfiles.conf" "$HOME/.dotfiles.conf"
}

dfadd(){ # Add file(s) to tracked dotfiles"
  wdir=$(pwd | sed "s|$HOME|\$HOME|");
  for i in "$@"; do                                                               # Loop through tracked dotfiles (.dotfiles.conf)
    if [[ -e "$(pwd)/$i" ]]; then                                                                                                     
      if grep -q "^$wdir/$i$" "$HOME"/.dotfiles.conf; then 
        printf '%s\n' "dir/file already exists within tracked file, skipping.";
      fi;                                                                         # if dir/file exists and is already in tracked file, do nothing. 
      if ! grep -q "^$wdir/$i$" "$HOME"/.dotfiles.conf; then 
        printf '%s\n' "$wdir/$i" >> "$HOME"/.dotfiles.conf; 
      fi; 
    fi;                                                                           # if dir/file exists but is not in file, add it.
    if ! [[ -e "$(pwd)/$i" ]]; then 
      printf '%s\n' "The dir/file $wdir/$i cannot be located. Skipping.";
    fi                                                                            # if dir/file does not exist, skip and do nothing.
  done;
  sort -o "$HOME/.dotfiles.conf" "$HOME/.dotfiles.conf"      
}

# Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

flacverify() { # verify flac files for corruption - flacverify [dir]
  find -L "$1" -type f -name '.flac' -print0 | while IFS= read -r -d '' file
  do printf '%3d %s\n' "$?" "$(tput sgr0)checking $(realpath "$file")" && flac -wst "$file" 2>/dev/null || printf '%3d %s\n' "$?" "$(tput setaf 1; realpath "$file") is corrupt $(tput sgr0)" | tee -a ~/corruptedFlacsList.txt
  done
}

appendPagination() { # read file in and append pagenumbers to each line 
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

ffs (){ # Search for text in firefox with pre-configured search engine
  firefox -search "$*";exit 
}

pskill() { # kill a given process by name
    pgrep "$1" | grep -v grep | awk '{ print $1 }' | xargs kill
}

ask() { # Wrap in loop to evaluate command, statement, or idea OR use confirm()
  echo -n "$@" '[y/n] ' ; read -r ans
  case "$ans" in
      y*|Y*) return 0 ;;
      *) return 1 ;;
  esac
}

confirm() { # Usage: confirm ls or confirm htop, etc.
  if ask "$1"; then 
    "$1" 
  fi
}

utime() { # Convert unix time to human readable - Usage: utime unixtime "utime 23454236" 
  if [ -n "$1" ]; then
      printf '%(%F %T)T\n' "$1"
  fi
}

quote() { # Pulls quote
	curl -s https://favqs.com/api/qotd | jq -r '[.quote.body, .quote.author] | "\(.[0]) \n~\(.[1])\n"'
}

repeat() { # Repeat n times command. Usage: "repeat 20 ls"
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
    printf '%s\n%5s\n\n' "Users logged on: " "$(PROCPS_USERLEN=32 w -hs | cut -d " " -f1 | sort | uniq)"
    printf '%s\n%50s\n\n' "Current date: " "$(date)"
    printf '%s\n%5s\n\n' "Machine stats: " "uptime is $(uptime | awk /'up/ {print $3,$4,$5,$6,$7,$8,$9,$10}')"
    printf '%s\n%5s\n\n' "Memory stats: " "$(free)"
    printf '%s\n%5s\n\n' "Diskspace: " "$(df / "$HOME")"
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

# compare the md5 of a file to a known sum
md5check() { 
  md5sum "$1" | grep "$2";
}

# report disk usage of directory and sort files by size
dusort() {
  find "$@" -mindepth 1 -maxdepth 1 -exec du -sch {} + | sort -h
}

# Traverse up a number of directories | cu   -> cd ../ | cu 2 -> cd ../../ |  cu 3 -> cd ../../../
..() { 
  local count=$1
  if [ -z "${count}" ]; then
      count=1
  fi
  local path=""
  for i in $(seq 1 "${count}"); do
      path="${path}../"
  done
  cd $path || exit
}

# Open all modified files in vim tabs
nvimod() {
    nvim -p "$(git status -suall | awk '{print $2}')"
}

# Open files modified in a git commit in nvim tabs; defaults to HEAD. Pop it in your .bashrc - Examples: "virev 49808d5" or "virev HEAD~3"
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
ef() {
  SAVEIFS=$IFS
  IFS="$(printf '\n\t')"
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf "$1"                                   ;;
      *.tar.gz)    tar xzf "$1"                                   ;;
      *.bz2)       bunzip2 "$1"                                   ;;
      *.rar)       7z x -o"${1%.rar}" "$1"                         ;;
      *.gz)        gunzip "$1"                                    ;;
      *.tar)       mkdir "${1%.tar}"; tar -xvf "$1" -C "${1%.tar}";;
      *.tbz2)      tar xjf "$1"                                   ;;
      *.tgz)       tar xzf "$1"                                   ;;
      *.zip)       7z x -o"${1%.zip}" "$1"                        ;; 
      *.Z)         uncompress "$1"                                ;;
      *.7z)        7z x -o"${1%.7z}" "$1"                         ;;
      *.iso)       7z x -o"${1%.iso}" "$1"                        ;;
      *.lzm)       7z x -o"${1%.lzm}" "$1"                        ;;
      *.deb)       ar x "$1"                                      ;;
      *.tar.xz)    tar xf "$1"                                    ;;
      *.tar.zst)   tar xf "$1"                                    ;;
      *)           printf "%s" "$1 cannot be extracted"           ;;
    esac
  else
    printf '%s' "$1 is not a valid file"
  fi
  IFS=$SAVEIFS
}

# [e]tract[h]ere = extracts files loosely into directory - usage: exhere <file>
eh() {
  SAVEIFS=$IFS
  IFS="$(printf '\n\t')"
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)        tar xjf "$1"                         ;;
      *.tar.gz)         tar xzf "$1"                         ;;
      *.bz2)            bunzip2 "$1"                         ;;
      *.rar)            unrar x "$1"                         ;;
      *.gz)             gunzip "$1"                          ;;
      *.tar)            tar xf "$1"                          ;;
      *.tbz2)           tar xjf "$1"                         ;;
      *.tgz)            tar xzf "$1"                         ;;
      *.zip)            unzip "$1"                           ;;
      *.Z)              uncompress "$1"                      ;;
      *.7z|*.iso|.lzm)  7z x "$1"                            ;;
      *.deb)            ar x "$1"                            ;;
      *.tar.xz)         tar xf "$1"                          ;;
      *.tar.zst)        tar xf "$1"                          ;;
      *)                printf "%s" "$1 cannot be extracted" ;;
    esac
  else
    printf '%s' "$1 is not a valid file"
  fi
  IFS=$SAVEIFS
}

smush() { # Usage "smush <file> <tar.gz.>"
    FILE=$1
    case $FILE in
        *.tar.bz2)   shift && tar cjf "$FILE" "$1"                                     ;;
        *.tar.gz)    shift && tar czf "$FILE" "$1"                                     ;;
        *.tgz)       shift && tar czf "$FILE" "$1"                                     ;;
        *.zip)       shift && 7z a -tzip "$FILE" "$1"                                  ;;
        *.rar)       shift && rar "$FILE" "$1"                                         ;;
        *.7z)        shift && 7z a -t7z -m0=lzma2 -mx=9 -mfb=64 -md=64m -ms=on "$FILE" ;;
    esac
}

encryptwholeerase() { # Encrypt and overwrite drive with encrypted cipher for secure erase - Usage: encryptwholeerase "/dev/sdX"
  DEVICE="$1"; PASS=$(tr -cd '[:alnum:]' < /dev/urandom | head -c 1024)
  openssl enc -aes-256-ctr -pass pass:"$PASS" -nosalt < /dev/zero | dd obs=64K ibs=4K of="$DEVICE" oflag=direct status=progress
}

encryptfreeerase() { # Encrypt and overwrite free space with encrypted cipher for secure erase - Usage: encryptfreeerase
  PASS=$(tr -cd '[:alnum:]' < /dev/urandom | head -c 1024)
  openssl enc -pbkdf2 -pass pass:"$PASS" -nosalt < /dev/zero | dd obs=128K ibs=4K of="Eraser" oflag=direct status=progress
  rm -f "Eraser"
}

buffer_clean() { # frees ram buffer
	free -h && sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches' && free -h
}

calc() { # Calculate the input string using bc command (it's a calculator)
  echo "$*" | bc;
}

mktargz() { 
  tar czf "${1%%/}.tar.gz" "${1%%/}/"; 
}

mkown() { # take ownership of file
  sudo chown -R "$(whoami)" "${1:-.}"; 
}

mkgrp() { # change ownership of group on file to self
  sudo chgrp -R "$(whoami)" "${1:-.}"; 
}

mkmv() { # make directory and move file into it - Usage: "mkmv filetobemoved.txt NewDirectory"
    mkdir "$2"
    mv "$1" "$2"
}

md () { # make directory and immediately enter it
  mkdir -p "$@" && cd "$@" || exit
}

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

# Scan subnet for active systems (arp scan) - Usage: subnetscan 192.168.122.1/24
subnetscan() {
  nmap -v -sn "${1}" -oG - | awk '$4=="Status:" && $5=="Up" {print $2}'
}

# Scan subnet for available IPs - Usage: subnetfree 192.168.122.1/24
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

# Stealth syn scan, OS and version detection, verbose output - Usage: portscan-stealth 192.168.122.1/24 or portscan-stealth 192.168.122.137 1-65535
stealthscan-port() {
  sudo nmap -v -p "${2}" -sV -O -sS -T5 "${1}" 
}

# detect if a website is protected by such a web-application firewall - usage: "wafscan url"
wafscan(){
  nmap -p443 --script http-waf-detect --script-args="http-waf-detect.aggro,http-waf-detect.detectBodyChanges" "${1}"
}

pingdrops() { # Detect frame drops using `ping` - Usage: pingdrops 192.168.122.137
  ping "${1}" | grep -oP --line-buffered "(?<=icmp_seq=)[0-9]{1,}(?= )" | awk '$1!=p+1{print p+1"-"$1-1}{p=$1}'
}

urltest() { # Use Curl to check URL connection performance - urltest https://google.com
  URL="$*"
  if [ -n "${URL[0]}" ]; then
    curl -L --write-out "URL,DNS,conn,time,speed,size\n%{url_effective},%{time_namelookup} (s),%{time_connect} (s),%{time_total} (s),%{speed_download} (bps),%{size_download} (bytes)\n" \
-o/dev/null -s "${URL[0]}" | column -s, -t
  fi
}

portproc() { # List processes associated with a port - Usage: "portproc 22"
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

filegen() { # Generate a file of randomized data and certain size - Usage: filegen <size> <location> <(a)lpha, (n)umeric, (r)andom, (b)inary> 
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

gifify() { #  animated gifs from any video - https://gist.github.com/SlexAxton/4989674
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

appleProtection() { # Apple Protection On/Off (only available on mac running bash, outdated)
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

# if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#     ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
# fi
# if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
#     source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
# fi

for sh in /etc/bash/bashrc.d/* ; do
	[[ -r ${sh} ]] && source "${sh}"
done
