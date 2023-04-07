#
# ~/.bashrc: executed by bash(1) for non-login shells.
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source /usr/share/git/git-prompt.sh

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

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

# 'Safe' version of __git_ps1 to avoid errors on systems that don't have it
gitPrompt () {
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
  export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01' # colored GCC warnings and errors
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

alias openports='netstat -nape --inet'
alias ns='netstat -alnp --protocol=inet | grep -v CLOSE_WAIT | cut -c-6,21-94 | tail +2'
alias da='date "+%Y-%m-%d %A    %T %Z"'
alias rsync='rsync -P'
alias sb='source ~/.bashrc'
alias free="free -mth"
alias ports='echo -e "\n${ECHOR}Open connections :$NC "; netstat -pan --inet;'
alias qwd='printf "%q\n" "$(pwd)"'
alias localip='ifconfig | sed -rn "s/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p"' # Show local primary IP address
alias publicip='wget http://ipecho.net/plain -O - -q ; echo' # Show public (Internet) IP address
alias memwatch='watch -d vmstat -sSM' # Watch memory usage in real time
alias xip='echo; curl -s tput; echo;' # Quickly find out external IP address for your device by typing 'xip'
alias intercept="sudo strace -ff -e trace=write -e write=1,2 -p" #given a PID, intercept the stdout and stderr
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e" # search processes (find PID easily)
alias psf="ps auxfww" # show all processes

whatsmy_public_ip() {
  curl --silent 'https://jsonip.com/' | json_val '["ip"]'
}

# Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

pskill() { # kill a given process by name
    pgrep "$1" | grep -v grep | awk '{ print $1 }' | xargs kill
}

ask() { # See 'killps' for example of use.
  echo -n "$@" '[y/n] ' ; read -r ans
  case "$ans" in
      y*|Y*) return 0 ;;
      *) return 1 ;;
  esac
}

utime() { # Convert unix time to human readable - Usage: utime unixtime "utime 23454236" 
  if [ -n "$1" ]; then
      printf '%(%F %T)T\n' "$1"
  fi
}

load() { # Returns system load as percentage, i.e., '40' rather than '0.40)'.
  local SYSLOAD
  SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')
  # System load of the current host.
  echo $((10#$SYSLOAD))%       # Convert to decimal.
}

quote() { #fix output
	echo
	curl -s https://favqs.com/api/qotd #| jq -r '[.quote.body, .quote.author] | "\(.[0]) -\(.[1])"'
}

repeat() { # Repeat n times command. Usage: "repeat 20 ls"
  local i max
  max=$1; shift;
  for ((i=1; i <= max ; i++)); do  # --> C-like syntax
    "$@";
  done
}

corename() { # Get name of app that created a corefile.
    for file ; do
        echo -n "$file" : ; gdb --core="$file" --batch | head -1
    done
}

unicode='×Ø÷±ÿłŊŋƜɨɷɸΔΣΦΨΩαβγδεζηθκλμνξπρστυφχψωᴀᴃᴕᴖ⚗🗺🌀🌁🌂🌃🌄🌅🌆🌇🌈🌉🌊🌋'
unicode+='🌌🌍🌎🌏🌐🌑🌒🌓🌔🌕🌖🌗🌘🌙🌚🌛🌜🌝🌞🌟🌠🌡🌢🌣🌤🌥🌦🌧🌨🌩🌪🌫🌬🌭🌮🌯🌰🌱🌲🌳🌴🌵🌶'
unicode+='🌷🌸🌹🌺🌻🌼🌽🌾🌿🍀🍁🍂🍃🍄🍅🍆🍇🍈🍉🍊🍋🍌🍍🍎🍏🍐🍑🍒🍓🍔🍕🍖🍗🍘🍙🍚🍛🍜🍝🍞🍟🍠'
unicode+='🍡🍢🍣🍤🍥🍦🍧🍨🍩🍪🍫🍬🍭🍮🍯🍰🍱🍲🍳🍴🍵🍶🍷🍸🍹🍺🍻🍼🍽🍾🍿🎀🎁🎂🎃🎄🎅🎆🎇🎈🎉🎊'
unicode+='🎋🎌🎍🎎🎏🎐🎑🎒🎓🎔🎕🎖🎗🎘🎙🎚🎛🎜🎝🎞🎟🎠🎡🎢🎣🎤🎥🎦🎧🎨🎩🎪🎫🎬🎭🎮🎯🎰🎱🎲🎳🎴'
unicode+='🎵🎶🎷🎸🎹🎺🎻🎼🎽🎾🎿🏀🏁🏂🏃🏄🏅🏆🏇🏈🏉🏊🏋🏌🏍🏎🏏🏐🏑🏒🏓🏔🏕🏖🏗🏘🏙🏚🏛🏜🏝🏞🏟'
unicode+='🏠🏡🏢🏣🏤🏥🏦🏧🏨🏩🏪🏫🏬🏭🏮🏯🏰🏱🏲🏳🏴🏵🏶🏷🏸🏹🏺🏻🏼🏽🏾🏿🐀🐁🐂🐃🐄🐅🐆🐇🐈🐉'
unicode+='🐊🐋🐌🐍🐎🐏🐐🐑🐒🐓🐔🐕🐖🐗🐘🐙🐚🐛🐜🐝🐞🐟🐠🐡🐢🐣🐤🐥🐦🐧🐨🐩🐪🐫🐬🐭🐮🐯🐰🐱🐲'
unicode+='🐳🐴🐵🐶🐷🐸🐹🐺🐻🐼🐽🐾🐿👀👁👂👃👄👅👆👇👈👉👊👋👌👍👎👏👐👑👒👓👔👕👖👗👘👙👚👛'
unicode+='👜👝👞👟👠👡👢👣👤👥👦👧👨👩👪👫👬👭👮👯👰👱👲👳👴👵👶👷👸👹👺👻👼👽👾👿💀💁💂💃💄💅'
unicode+='💆💇💈💉💊💋💌💍💎💏💐💑💒💓💔💕💖💗💘💙💚💛💜💝💞💟💠💡💢💣💤💥💦💧💨💩💪💫💬💭💮'
unicode+='💯💰💱💲💳💴💵💶💷💸💹💺💻💼💽💾💿📀📁📂📃📄📅📆📇📈📉📊📋📌📍📎📏📐📑📒📓📔📕📖📗'
unicode+='📘📙📚📛📜📝📞📟📠📡📢📣📤📥📦📧📨📩📪📫📬📭📮📯📰📱📲📳📴📵📶📷📸📹📺📻📼📽📾📿🔀🔁'
unicode+='🔂🔃🔄🔅🔆🔇🔈🔉🔊🔋🔌🔍🔎🔏🔐🔑🔒🔓🔔🔕🔖🔗🔘🔙🔚🔛🔜🔝🔞🔟🔠🔡🔢🔣🔤🔥🔦🔧🔨🔩🔪🔫'
unicode+='🔬🔭🔮🔯🔰🔱🔲🔳🔴🔵🔶🔷🔸🔹🔺🔻🔼🔽🔾🔿🕀🕁🕂🕃🕄🕅🕆🕇🕈🕉🕊🕋🕌🕍🕎🕏🕐🕑🕒🕓🕔🕕🕖🕗'
unicode+='🕘🕙🕚🕛🕜🕝🕞🕟🕠🕡🕢🕣🕤🕥🕦🕧🕨🕩🕪🕫🕬🕭🕮🕯🕰🕱🕲🕳🕴🕵🕶🕷🕸🕹🕺🕻🕼🕽🕾🕿🖀🖁🖂🖃'
unicode+='🖄🖅🖆🖇🖈🖉🖊🖋🖌🖍🖎🖏🖐🖑🖒🖓🖔🖕🖖🖗🖘🖙🖚🖛🖜🖝🖞🖟🖠🖡🖢🖣🖤🖥🖦🖧🖨🖩🖪🖫🖬🖭🖮🖯🖰🖱🖲'
unicode+='🖳🖴🖵🖶🖷🖸🖹🖺🖻🖼🖽🖾🖿🗀🗁🗂🗃🗄🗅🗆🗇🗈🗉🗊🗋🗌🗍🗎🗏🗐🗑🗒🗓🗔🗕🗖🗗🗘🗙🗚🗛🗜🗝🗞🗟'
unicode+='🗠🗡🗢🗣🗤🗥🗦🗧🗨🗩🗪🗫🗬🗭🗮🗯🗰🗱🗲🗳🗴🗵🗶🗷🗸🗹🗺🗻🗼🗽🗾🗿🗡🖱🖲🖼🗂🏵🏷🐿👁'
unicode+='📽🕉🕊🕯🕰🕳🕴🏕🏖🏗🏘🏙🏚🏛🏜🏝🏞🏟🙐🙑🙒🙓🙔🙕🙖🙗🙘🙙🙚🙛🙜🙝🙞🙟🙠🙡🙢🙣🙤🙥🙦🙧'
unicode+='🙨🙩🙪🙫🙬🙭🙮🙯🙰🙱🙲🙳🙴🙵🙶🙷🙸🙹🙺🙻🙼🙽🙾🙿🏳🕵🗃🗄🗑🗒🗓🗜🗝🗞ᴗᴟᴤᴥᴦᴧᴨᴩᴪ•‣…‰‱※D‼‽⁁'
unicode+='⁂⁃⁄⁅⁆⁇⁈⁉⁎⁏⁐⁑⁰ⁱ⁴⁵⁶⁷⁸⁹⁺⁻⁼⁽⁾ⁿ₀₁₂₃₄₅₆₇₈₉₊₋₌₍₎ℂ℃ℇ℉ℊℋℌℍℎℏℐℑℒℓℕ№ℚℛℜℝ℣ℤΩKÅℬℯℰℱ'
unicode+='ℳ⅋ⅎ⅐⅑⅒⅓⅔⅕⅖⅗⅘⅙⅚⅛⅜⅝⅞⅟ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩⅰⅱⅲⅳⅴⅵⅶⅷⅸⅹ↔↕↝↠↣↦↬↭↮↯'
unicode+='↹↺↻⇎⇏⇒⇛⇝⇢⇶∀∁∂∃∄∅∆∇S∈∉∎∏∐∑−∓∔∕∖∗∘∙√∛∜∝∞∟∠∡∢∣∤∥∦∧∨∩∪∫∬∭∮∯∰∱'
unicode+='∲∳∴∵∶∷∸∹∺∻∼∽∾∿≀≁≂≃≄≅≆≇≈≉≊≋≌≍≎≏≐≑≒≓≔≕≖≗≘≙≚≛≜≝≞≟≠≡≢≣≤≥≦'
unicode+='≧≨≩≪≫≬≭≮≯≰≱≲≳≴≵≶≷≸≹≺≻≼≽≾≿⊀⊁⊂⊃⊄⊅⊆⊇⊈⊉⊊⊋⊌⊍⊎⊏⊐⊑⊒⊓⊔⊕⊖⊗⊘'
unicode+='⊙⊚⊛⊜⊝⊞⊟⊠⊡⊰⊱⊲⊳⊴⊵⊶⊷⊸⊹⊾⊿⋀⋁⋂⋃⋄⋅⋆⋇⋈⋉⋊⋋⋌⋍⋎⋏⋐⋑⋒⋓⋔⋕⋖⋗⋘⋙⋚'
unicode+='⋛⋜⋝⋞⋟⋠⋡⋢⋣⋤⋥⋦⋧⋨⋩⋪⋫⋬⋭⋮⋯⋰⋱⌀⌁⌂⌃⌄⌅⌆⌇⌑⌐⌒⌓⌔⌕⌖⌗⌘⌙⌚⌛⌤⌥⌦⌧⌨'
unicode+='⌫⌬⏏⏚⏛⏰⏱⏲⏳␣╱╲╳▀▁▂▃▄▅▆▇█▉▊▋▌▍▎▏░▒▓▖▗▘▙▚▛▜▝▞▟■□▢▣▤▥▦▧▨'
unicode+='▩▪▫▬▭▮▯▰▱▲△▴▵▶▷▸▹►▻▼▽▾▿◀◁◂◃◄◅◆◇◈◉◊○◌◍◎●◐◑◒◓◔◕◖◗◘◙◚◛◜◝◞◟◠◡'
unicode+='◢◣◤◥◦◧◨◩◪◫◬◭◮◯◰◱◲◳◴◵◶◷◸◹◺◻◼◽◾◿☀☁☂☃☄★☆☇☈☉☊☋☌☍☎☏☐☑'
unicode+='☒☓☔☕☖☗☘☙☚☛☜☝☞☟☠☡☢☣☤☥☦☧☨☩☪☫☬☭☮☯☰☱☲☳☴☵☶☷☸☼☽☾☿♀♁♂♃♄♅'
unicode+='♆♇♔♕♖♗♘♙♚♛♜♝♞♟♠♡♢♣♤♥♦♧♨♩♪♫♬♭♮♯♲♳♴♵♶♷♸♹♺♻♼♽♾⚀⚁⚂⚃⚄⚅'
unicode+='⚐⚑⚒⚓⚔⚕⚖⚗⚘⚙⚚⚛⚜⚝⚞⚟⚠⚡⚢⚣⚤⚥⚦⚧⚨⚩⚪⚫⚬⚭⚮⚯⚰⚱⚲⚳⚴⚵⚶⚷⚸⚹⚺⚻⚼⛀⛁⛂'
unicode+='⛃⛢⛤⛥⛦⛧⛨⛩⛪⛫⛬⛭⛮⛯⛰⛱⛲⛴⛵⛶⛷⛸⛹⛺⛻⛼⛽⛾⛿✁✂✃✄✅✆✇✈✉✊✋✌✍✎✏'
unicode+='✐✑✒✓✔✕✖✗✘✙✚✛✜✝✞✟✠✡✢✣✤✥✦✧✨✩✪✫✬✭✮✯✰✱✲✳✴✵✶✷✸✹✺✻✼✽✾✿❀'
unicode+='❁❂❃❄❅❆❇❈❉❊❋❌❍❎❏❐❑❒❓❔❕❖❗❟❠❡❢❣❤❥❦❧⟴⟿⤀⤁⤐⤑⤔⤕⤖⤗⤘⤨⤩⤪⤫⤬'
unicode+='⤭⤮⤯⤰⤱⤲⤼⤽⤾⤿⥀⥁⥂⥃⥄⥅⥆⥇⥈⥉⥊⥋⥌⥍⥎⥏⥐⥑⬒⬓⬔⬕⬖⬗⬘⬙⬚⸮〃〄﴾﴿︽︾﹁﹂﹃﹄﹅'
unicode+='﹆｟｠⌬⌬⌬⌬◉∰⁂⛃⛁◉∰⁂⛃⛁◉∰⁂⛃⛁◉∰⁂⛃⛁⛇⛓⚛⛇⛓⚛⛇⛓⚛⛇⛓⚛'

# Length of the previous string
unicodelen=${#unicode}

# Get a random character from the previous string
getunicodec() {
    r="$RANDOM"
    from=$((r%unicodelen))
    echo "${unicode:from:1}"
}

# Gets the exit code of the last command executed. Use "printf '%.*s' $? $?" to show only non-zero codes. The characters ✓ and ✗ may also be helpful!
lastexit() {
        EXITSTATUS="$1"
        if [ "$EXITSTATUS" -eq 0 ]; 
        then echo -e "${ESG}${EXITSTATUS}"; 
        else echo -e "${RED}${EXITSTATUS}"; 
        fi;
}

# Returns only a red or green color, depending on exit status
lastexitcolor() {
        EXITSTATUS="$1"
        if [ "$EXITSTATUS" -eq 0 ]; 
        then echo -e "${ESG}";
        else echo -e "${ESR}"; 
        fi;
}

# Returns epoch nanosecond time
timer_now() {
    date +%s%N
}

# Start a timer for the next command, or leave it at its current value if it exists
timer_start() {
    start_time="${start_time:-$(timer_now)}"
}

# Stop a timer if running, and set the timer_show variable to the final value in a human-readable format.
timer_stop() {
    # If no command was run, ignore any elapsed time.
    if [[ $NUM_CALLS -lt 2 ]]; then
        timer_show="␣"
        NUM_CALLS=0
        unset start_time
        return
    fi
    # Unit conversion
    local delta_us=$((($(timer_now)-start_time)/1000))
    local us=$((delta_us%1000))
    local ms=$(((delta_us/1000)%1000))
    local s=$(((delta_us/1000000)%60))
    local m=$(((delta_us/60000000)%60))
    local h=$((delta_us/3600000000))
    # Goal: always show around 3 digits of accuracy
    if ((h>0)); then timer_show=${h}h${m}m
    elif ((m>0)); then timer_show=${m}m${s}s
    elif ((s>=10)); then timer_show=${s}.$((ms/100))s
    elif ((s>0)); then timer_show=${s}.$(printf %03d $ms)s
    elif ((ms>=100)); then timer_show=${ms}ms
    elif ((ms>0)); then timer_show=${ms}.$((us/100))ms
    else timer_show=${us}us
    fi
    unset start_time
    NUM_CALLS=0
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

# check top ten commands executed
topten() { 
    all=$(history | awk '{print $2}' | awk 'BEGIN {FS="|"}{print $1}') 
    echo "$all" | sort | uniq -c | sort -n | tail | sort -nr
}

# returns a bunch of information about the current host, useful when jumping around hosts a lot
ii() {
    echo -e "\nYou are logged on to $HOSTNAME"
    echo -e "\nAdditionnal information: " ; uname -a
    echo -e "\nUsers logged on: " ; w -hs | cut -d " " -f1 | sort | uniq
    echo -e "\nCurrent date : " ; date
    echo -e "\nMachine stats : " ; uptime
    echo -e "\nMemory stats : " ; free
    echo -e "\nDiskspace : " ; df / "$HOME"
    echo -e "\nLocal IP Address :" ; ip -4 addr | grep -v 127.0.0.1 | grep -v secondary | grep "inet" | awk '{print $2}' | cut -d'/' -f1; ip -6 addr | grep -v ::1 | grep -v secondary | grep "inet" | awk '{print $2}' | cut -d'/' -f1
    echo ''
}

# print uptime, host name, number of users, and average load
upinfo() {
    echo -ne "$HOSTNAME uptime is ";
    uptime | awk /'up/ {print $3,$4,$5,$6,$7,$8,$9,$10}'
}

# swap the names/contents of two files
swapname() { # Swap 2 filenames around, if they exist (from Uzi's bashrc).
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
cu() { 
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

# Open files modified in a git commit in nvim tabs; defaults to HEAD. Pop it in your .bashrc
# Examples: "virev 49808d5" or "virev HEAD~3"
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

# ex = EXtractor for all kinds of archives - usage: ex <file>
ex() {
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *.deb)       ar x "$1"      ;;
      *.tar.xz)    tar xf "$1"    ;;
      *.tar.zst)   tar xf "$1"    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

smush() {
    FILE=$1
    case $FILE in
        *.tar.bz2) shift && tar cjf "$FILE" "$*" ;;
        *.tar.gz)  shift && tar czf "$FILE" "$*" ;;
        *.tgz)     shift && tar czf "$FILE" "$*" ;;
        *.zip)         shift && zip "$FILE" "$*" ;;
        *.rar)         shift && rar "$FILE" "$*" ;;
    esac
}

buffer_clean() {
	free -h && sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches' && free -h
}

calc() { # Calculate the input string using bc command
  echo "$*" | bc;
}

mktar() { 
  tar czf "${1%%/}.tar.gz" "${1%%/}/"; 
}

mkzip() { 
  zip -r "${1%%/}.zip" "$1" ; 
}

mkmine() { # take ownership of file
  sudo chown -R "${USER}" "${1:-.}"; 
}

mkmv() { # make directory and move file into it - Usage: "mkmv filetobemoved.txt NewDirectory"
    mkdir "$2"
    mv "$1" "$2"
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

# Scan subnet for active systems - Usage: ubnetscan 192.168.122.1/24
subnetscan() {
  nmap -sn "${1}" -oG - | awk '$4=="Status:" && $5=="Up" {print $2}'
}

# Scan subnet for available IPs - Usage: subnetfree 192.168.122.1/24
subnetfree() {
  nmap -v -sn -n "${1}" -oG - | awk '/Status: Down/{print $2}'
}

# Quick network port scan of an IP - Usage: portscan 192.168.122.37
portscan() {
  nmap -oG -T4 -F "${1}" | grep "\bopen\b"
}

# Stealth syn scan, OS and version detection, verbose output - Usage: portscan-stealth 192.168.122.1/24 or portscan-stealth 192.168.122.137
portscan-stealth() {
  nmap -v -sV -O -sS -T5 "${1}"
}

# Test port connection - Usage: portcheck 192.168.122.137 22
alias portcheck='nc -v -i1 -w1'

# Detect frame drops using `ping` - Usage: pingdrops 192.168.122.137
pingdrops() {
  ping "${1}" | \
  grep -oP --line-buffered "(?<=icmp_seq=)[0-9]{1,}(?= )" | \
  awk '$1!=p+1{print p+1"-"$1-1}{p=$1}'
}

# Quickly test network throughput between two servers via SSH -  Usage: bandwidth-test 192.168.122.137
bandwidth-test() {
  yes | pv | ssh "${1}" "cat > /dev/null"
}

# Identify local listening ports and services
localports() {
  for i in $(lsof -i -P -n | grep -oP '(?<=\*:)[0-9]{2,}(?= \(LISTEN)' | sort -nu)
  do
    lsof -i :"${i}" | grep -v COMMAND | awk -v i="$i" '{print $1,$3,i}' | sort -u
  done | column -t
}

# Use Curl to check URL connection performance - urltest https://google.com
urltest() {
  URL="$*"
  if [ -n "${URL[0]}" ]; then
    curl -L --write-out "URL,DNS,conn,time,speed,size\n
%{url_effective},%{time_namelookup} (s),%{time_connect} (s),%{time_total} (s),%{speed_download} (bps),%{size_download} (bytes)\n" \
-o/dev/null -s "${URL[0]}" | column -s, -t
  fi
}

# List processes associated with a port
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

# Generate a random alphanumeric file of certain size - Usage: filegen size location
filegen() {
  s="${1}"
  if [ -z "${s}" ]; then s="1M"; fi
  fsize="$(echo "${s}" | grep -Eo '[0-9]{1,}')"
  sunit="$(echo "${s}" | grep -oE '[Aa-Zz]{1,}')"
  (( ssize = fsize * 6 ))
  f="${2}"
  if [ -z "${f}" ] || [ -f "${f}" ]; then f="$(mktemp)"; fi
  head -c "${fsize}${sunit}" <(head -c "${ssize}${sunit}" </dev/urandom | tr -dc A-Za-z0-9) > "${f}"
  ls -alh "${f}"
}

# Set Environment Variables
export EDITOR=nvim
export VISUAL=code-oss
export LD_PRELOAD=""
export HISTSIZE=2500
export HISTCONTROL=ignorespace
#export HISTCONTROL=ignoreboth:erasedups:ignorespace
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export RANGER_LOAD_DEFAULT_RC=FALSE
#export PAGER='less'

# if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#     ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
# fi
# if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
#     source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
# fi

for sh in /etc/bash/bashrc.d/* ; do
	[[ -r ${sh} ]] && source "${sh}"
done