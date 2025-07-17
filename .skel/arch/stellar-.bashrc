#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias lzd='lazydocker'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias pcu='podman compose up -d'
alias pcd='podman compose down'
alias updaterepo='sudo reflector --verbose -c "United States" --latest 30 --fastest 30 --score 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'
alias sb='source ~/.bashrc'
alias err='journalctl -b -p err'
alias ports='netstat -nape --inet'
alias services='systemctl --type=service --state=running'

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

  if command -v flatpak &> /dev/null; then  tput setaf 2; printf '\n\n%s\n' "Flatpak (flatpak --user update):"; tput sgr0; flatpak --user update; fi
  if command -v snap &> /dev/null; then  tput setaf 2; printf '\n%s\n' "Snap (snap refresh):"; tput sgr0; sudo snap refresh; fi

  sync && printf '\n'
}

PS1='[\u@\h \W]\$ '
