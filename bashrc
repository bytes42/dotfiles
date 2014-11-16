# If not running interactively, don't do anything
[ -z "$PS1"  ] && return


#-------------------------------------------------------------
# Source global definitions (if any)
#-------------------------------------------------------------
if [ -f /etc/bashrc  ]; then
	. /etc/bashrc
fi


#-------------------------------------------------------------
# Source local definitions (if any)
#-------------------------------------------------------------
if [ -f ~/.bashrc_optiver ]; then
	. ~/.bashrc_optiver
elif [ -f ~/.bashrc_macbook ]; then
	. ~/.bashrc_macbook
fi


#-------------------------------------------------------------
# Display - doesn't support remote host, yet
#-------------------------------------------------------------
export DISLPAY=":0.0"


#-------------------------------------------------------------
# shell options
#-------------------------------------------------------------
set -o vi

shopt -s cdspell
shopt -s checkhash
shopt -s checkwinsize
shopt -s cmdhist
shopt -s extglob
shopt -s histappend histreedit histverify
shopt -s no_empty_cmd_completion
shopt -s nocaseglob


#-------------------------------------------------------------
# Colors
#-------------------------------------------------------------
#   Color definitions (taken from Color Bash Prompt HowTo).
#   Some colors might look different of some terminals.
#   For example, I see 'Bold Red' as 'orange' on my screen,
#   hence the 'Green' 'BRed' 'Red' sequence I often use in my prompt.

# Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset

ALERT=${BWhite}${On_Red} # Bold White on red background

#-------------------------------------------------------------
# Shell Prompt: [TIME USER@HOST PWD]\n$
#-------------------------------------------------------------

# Test user type:
#    Green     == normal user
#    Yellow    == SU to user
#    Red       == root
if [[ ${USER} == "root" ]]; then
    SU=${Red}
elif [[ ${USER} != $(logname) ]]; then
    SU=${Yellow}
else
    SU=${Green}
fi

PS1="\n\[${Yellow}\]\t\[${NC}\] "							# time
PS1=${PS1}"\[${SU}\]\u\[${NC}\]@\[${Red}\]\h\[${NS}\] "		# user@host
PS1=${PS1}"\[${Cyan}\]\w\[${NS}\]"							# pwd
PS1=${PS1}"\n\[${White}\]$ "								# cmd line

export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'


#-------------------------------------------------------------
# history
#-------------------------------------------------------------
export HISTIGNORE="&:bg:fg:ll:h"
export HISTTIMEFORMAT="$(echo -e ${BCyan})[%d/%m %H:%M:%S]$(echo -e ${NC}) "
export HISTCONTROL=ignoredups
export HISTSIZE=100000
export HISTFILESIZE=100000


#-------------------------------------------------------------
# aliases
#-------------------------------------------------------------
alias rm='rm -v'
alias cp='cp -iv'
alias mv='mv -iv'

alias h='history'
alias j='jobs -l'

alias du='du -kh'
alias df='df -kTh'

alias sl='ls'
alias ll='ls -lv'
alias lk='ll -S'	# Sort by size, smallest last
alias lt='ll -tc'	# Sort by date, oldest last

alias grep='grep --color=auto'
alias egrep='grep --color=auto -E'
alias pgrep='pgrep -l'

alias bigfiles="ncdu"

#-------------------------------------------------------------
# Tailoring 'less'
#-------------------------------------------------------------

alias more='less'
export PAGER=less
export LESS='-n -w  -z-4 -g -M -P%t?f%f :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'


#-------------------------------------------------------------
# File & strings related functions:
#-------------------------------------------------------------

# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'"$*"'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
function fe() { find . -type f -iname '*'"${1:-}"'*' \
-exec ${2:-file} {} \;  ; }

#  Find a pattern in a set of files and highlight them:
#+ (needs a recent version of egrep).
function fstr()
{
    OPTIND=1
    local mycase=""
    local usage="fstr: find string in files. Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "
    while getopts :it opt
    do
        case "$opt" in
           i) mycase="-i " ;;
           *) echo "$usage"; return ;;
        esac
    done
    shift $(( $OPTIND - 1 ))
    if [ "$#" -lt 1 ]; then
        echo "$usage"
        return;
    fi
    find . -type f -name "${2:-*}" -print0 | xargs -0 egrep --color=always -sn ${case} "$1" 2>&- | more
}

function extract()      # Handy Extract Program
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}


# Creates an archive (*.tar.gz) from given directory.
function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }


#-------------------------------------------------------------
# Process/system related functions:
#-------------------------------------------------------------
function myps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }


#-------------------------------------------------------------
# cmd line navigation
#-------------------------------------------------------------
export MARKPATH=$HOME/.marks
function jump {
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
alias j="jump"
function mark {
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark {
    rm -i "$MARKPATH/$1"
}
function marks {
    ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}
 
_completemarks() {
        local curw=${COMP_WORDS[COMP_CWORD]}
        local wordlist=$(find $MARKPATH -type l -printf "%f\n")
        COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
        return 0
}
 
complete -F _completemarks jump unmark
 

#-------------------------------------------------------------
# general utils
#-------------------------------------------------------------
find_largest()  { du -ah $HOME | sort -n -r | head -n 10; }
hgt()           { history | grep "$@" | tail -n 40; }
 
hc() {
    if [ "$#" -eq 1 ]; then
        sed -e "s/\($1\)/\x1B[31m&\x1b[0m/g"
    elif [ "$#" -eq 2 ]; then
        sed -e "s/\($1\)/\x1B[31m&\x1b[0m/g" |\
        sed -e "s/\($2\)/\x1B[32m&\x1b[0m/g"
    elif [ "$#" -eq 3 ]; then
        sed -e "s/\($1\)/\x1B[31m&\x1b[0m/g" |\
        sed -e "s/\($2\)/\x1B[32m&\x1b[0m/g" |\
        sed -e "s/\($3\)/\x1B[33m&\x1b[0m/g"
    elif [ "$#" -eq 4 ]; then
        sed -e "s/\($1\)/\x1B[31m&\x1b[0m/g" |\
        sed -e "s/\($2\)/\x1B[32m&\x1b[0m/g" |\
        sed -e "s/\($3\)/\x1B[33m&\x1b[0m/g" |\
        sed -e "s/\($4\)/\x1B[35m&\x1b[0m/g"
    elif [ "$#" -eq 5 ]; then
        sed -e "s/\($1\)/\x1B[31m&\x1b[0m/g" |\
        sed -e "s/\($2\)/\x1B[32m&\x1b[0m/g" |\
        sed -e "s/\($3\)/\x1B[33m&\x1b[0m/g" |\
        sed -e "s/\($4\)/\x1B[35m&\x1b[0m/g" |\
        sed -e "s/\($5\)/\x1B[36m&\x1b[0m/g"
    elif [ "$#" -eq 6 ]; then
        sed -e "s/\($1\)/\x1B[31m&\x1b[0m/g" |\
        sed -e "s/\($2\)/\x1B[32m&\x1b[0m/g" |\
        sed -e "s/\($3\)/\x1B[33m&\x1b[0m/g" |\
        sed -e "s/\($4\)/\x1B[35m&\x1b[0m/g" |\
        sed -e "s/\($5\)/\x1B[36m&\x1b[0m/g" |\
        sed -e "s/\($5\)/\x1B[37m&\x1b[0m/g"
    fi
}


#-------------------------------------------------------------
# programmable completions
#-------------------------------------------------------------
complete -A hostname   rsh rcp telnet rlogin ftp ping disk ssh gssh pssh
complete -A export     printenv
complete -A variable   export local readonly unset
complete -A enabled    builtin
complete -A alias      alias unalias
complete -A function   function
complete -A user       su mail finger

complete -A helptopic  help     # Currently same as builtins.
complete -A shopt      shopt
complete -A stopped -P '%' bg
complete -A job -P '%'     fg jobs disown

complete -A directory  mkdir rmdir
complete -A directory   -o default cd

# Compression
complete -f -o default -X '*.+(zip|ZIP)'  zip
complete -f -o default -X '!*.+(zip|ZIP)' unzip
complete -f -o default -X '*.+(z|Z)'      compress
complete -f -o default -X '!*.+(z|Z)'     uncompress
complete -f -o default -X '*.+(gz|GZ)'    gzip
complete -f -o default -X '!*.+(gz|GZ)'   gunzip
complete -f -o default -X '*.+(bz2|BZ2)'  bzip2
complete -f -o default -X '!*.+(bz2|BZ2)' bunzip2
complete -f -o default -X '!*.+(zip|ZIP|z|Z|gz|GZ|bz2|BZ2)' extract

complete -f -o default -X '!*.pl'  perl perl5
complete -f -o default -X '!*.py'  python pythong26

 
#-------------------------------------------------------------
# programmable completions
#-------------------------------------------------------------
export GTAGSFORCECPP=y

alias findbracketerror="find . -name "*.h" | xargs -n1 indent -st >/dev/null"
 
tagme() {
    gtags
    ctags -R --languages=C,C++ --c++-kinds=+p --fields=+iaS --extra=+qf `pwd`
}
