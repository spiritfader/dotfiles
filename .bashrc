# ~/.bashrc: executed by bash(1) for non-login shells.

source /usr/share/git/git-prompt.sh

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s autocd # Enable auto cd when typing directories 
shopt -s checkwinsize # check the terminal size when it regains control - check winsize when resize
shopt -s histappend # append to the history file, don't overwrite it
shopt -s globstar # the pattern "**" used in a pathname expansion context will match all files and zero or more directories and subdirectories.
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

# parse_git_branch() { # display git branch status in PS1
#      git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
# }

# 'Safe' version of __git_ps1 to avoid errors on systems that don't have it
function gitPrompt {
  command -v __git_ps1 > /dev/null && __git_ps1 " (%s)"
}

# Set PS1 prompt display
if ${use_color} ; then 
	if [[ ${EUID} == 0 ]] ; then # set root PS1
		PS1+='\[\033[01;31m\]\h\[\033[01;34m\] \w \$\[\033[00m\] '
	else # set user PS1
  	#PS1+='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] ' # default
		#PS1+='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\033[33m\]$(parse_git_branch)\033[01;34m\] \$\[\033[00m\] ' # default with inline git branch status
    #PS1+='\[\033[01;34m\]\w \$\[\033[00m\] ' # custom
    PS1+='\[\033[01;34m\]\w\[\033[33m\]$(gitPrompt)\[\033[01;34m\] \$\[\033[00m\] ' # custom with inline git branch status
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
else
	# show root@ when we don't have colors
	PS1+='\u@\h \w \$ '
fi

# default Athena OS PS1 (broken, not working lol)
#PS1="\e[1;32m┌──[HQ🚀\e[1;31m$(ip -4 addr | grep -v 127.0.0.1 | grep -v secondary | grep -Po "inet \K[\d.]+" | sed -z "s/\n/|/g;s/|$/\n/")⚔️\u\e[1;32m]\n└──╼[👾]\[\e[1;36m\]\$(pwd) $ \[\e[0m\]"

# modified Athena OS PS1 (fixed, universal)
#PS1="\e[1;32m┌──[HQ🚀\e[1;31m$(ip -4 addr | grep -v 127.0.0.1 | grep -v secondary | grep "inet" | awk '{print $2}' | cut -d'/' -f1)⚔️\u\e[1;32m]\n└──╼[👾]\[\e[1;36m\]\$(pwd) $ \[\e[0m\]"

# default Parrot OS PS1
#if [ "$color_prompt" = yes ]; then
#  PS1="\[\033[0;31m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[0;31m\]\342\234\227\[\033[0;37m\]]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then printf '\[\033[01;31m\]root\[\033[01;33m\]@\[\033[01;96m\]\h'; else printf '\[\033[0;39m\]\u\[\033[01;33m\]@\[\033[01;96m\]\h'; fi)\[\033[0;31m\]]\342\224\200[\[\033[0;32m\]\w\[\033[0;31m\]]\n\[\033[0;31m\]\342\224\224\342\224\200\342\224\200\342\225\274 \[\033[0m\]\[\e[01;33m\]\\$\[\e[0m\]"
#else
#  PS1='┌──[\u@\h]─[\w]\n└──╼ \$ '
#fi

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

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
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
alias less='less -FR'
alias dd='dd status=progress'
alias _='sudo'
alias _i='sudo -i'
alias shred="shred -zf"
alias wget="wget -U 'noleak'"
alias curl="curl --user-agent 'noleak'"
alias count='find . -type f | wc -l'
alias empty_trash='rm -rf ~/.local/share/Trash/*'
alias infgears='vblank_mode=0 glxgears'
alias updaterepo='sudo reflector --verbose -c "United States" --age 12 --latest 10 --score 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'
alias awesomeerr='tail -f .cache/awesome/stderr'
alias awesomeout='tail -f .cache/awesome/stdout'
alias scrubstart='sudo btrfs scrub start'
alias scrubstatus='sudo btrfs scrub status'
alias scrublive='sudo btrfs scrub start /; watch -n 1 sudo btrfs scrub status /'
alias balancestart='sudo btrfs balance start'
alias balancestatus='sudo btrfs balance status'
alias balancelive='sudo btrfs balance status /; watch -n 1 sudo btrfs balance status /'
alias largesthome='btrfs fi du ~/ | sort -h'
alias largestroot='sudo btrfs fi du / | sort -h'
alias threads='ps --no-headers -Leo user | sort | uniq --count'
alias setuid='find /usr/bin -perm "/u=s,g=s"'
alias smart='sudo smartctl -a /dev/nvme0'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias trim='sudo fstrim -av'  

# Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# report disk usage of directory and sort files by size
function dusort(){
  find "$@" -mindepth 1 -maxdepth 1 -exec du -sch {} + | sort -h
}

# Change up a variable number of directories
#   cu   -> cd ../
#   cu 2 -> cd ../../
#   cu 3 -> cd ../../../
function cu { 
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
function nvimod {
    nvim -p "$(git status -suall | awk '{print $2}')"
}

# Open files modified in a git commit in nvim tabs; defaults to HEAD. Pop it in your .bashrc
# Examples: 
#     virev 49808d5
#     virev HEAD~3
function virev {
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

# ex = EXtractor for all kinds of archives - usage: ex <file>
ex ()
{
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"   ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1";;
      *.deb)       ar x "$1"      ;;
      *.tar.xz)    tar xf "$1"    ;;
      *.tar.zst)   tar xf "$1"    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

function extract { #Author: Vitalii Tereshchuk, 2013
 SAVEIFS=$IFS      #Github: https://github.com/xvoland/Extract
 IFS="$(printf '\n\t')"
 if [ $# -eq 0 ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz|.zlib|.cso>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 fi
    for n in "$@"; do
        if [ ! -f "$n" ]; then
            echo "'$n' - file doesn't exist"
            return 1
        fi

        case "${n##*.}" in
          *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                       tar xvf -p "$n"    ;;
          *.lzma)      unlzma ./"$n"      ;;
          *.bz2)       bunzip2 ./"$n"     ;;
          *.cbr|*.rar) unrar x -ad ./"$n" ;;
          *.gz)        gunzip ./"$n"      ;;
          *.cbz|*.epub|*.zip) unzip ./"$n"   ;;
          *.z)         uncompress ./"$n"  ;;
          *.7z|*.apk|*.arj|*.cab|*.cb7|*.chm|*.deb|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar|*.vhd)
                       7z x ./"$n"        ;;
          *.xz)        unxz ./"$n"        ;;
          *.exe)       cabextract ./"$n"  ;;
          *.cpio)      cpio -id < ./"$n"  ;;
          *.cba|*.ace) unace x ./"$n"     ;;
          *.zpaq)      zpaq x ./"$n"      ;;
          *.arc)       arc e ./"$n"       ;;
          *.cso)       ciso 0 ./"$n" ./"$n.iso" && \
                            extract "$n.iso" && \rm -f "$n" ;;
          *.zlib)      zlib-flate -uncompress < ./"$n" > ./"$n.tmp" && \
                            mv ./"$n.tmp" ./"${n%.*zlib}" && rm -f "$n"   ;;
          *.dmg)
                      hdiutil mount ./"$n" -mountpoint "./$n.mounted" ;;
          *)
                      echo "extract: '$n' - unknown archive method"
                      return 1
                      ;;
        esac
    done
 IFS=$SAVEIFS
}

buffer_clean(){
	free -h && sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches' && free -h
}

# Set Environment Variables
export EDITOR=nvim
export VISUAL=code-oss
export LD_PRELOAD=""
export HISTSIZE=2500
export HISTCONTROL=ignorespace
#export HISTCONTROL=ignoreboth:erasedups:ignorespace
export MANPAGER="less -R --use-color -Dd+r -Du+b"
#export RANGER_LOAD_DEFAULT_RC=FALSE
#export PAGER='less'

#if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
#fi
#if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
#    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
#fi

for sh in /etc/bash/bashrc.d/* ; do
	[[ -r ${sh} ]] && source "${sh}"
done