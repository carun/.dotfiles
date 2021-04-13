# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

RCol='\[\e[m\]'    # Text Reset

# Regular            Bold                  Underline             High Intensity        BoldHigh Intens        Background            High Intensity Backgrounds
Bla='\[\e[0;30m\]';  BBla='\[\e[1;30m\]';  UBla='\[\e[4;30m\]';  IBla='\[\e[0;90m\]';  BIBla='\[\e[1;90m\]';  On_Bla='\[\e[40m\]';  On_IBla='\[\e[0;100m\]';
Red='\[\e[0;31m\]';  BRed='\[\e[1;31m\]';  URed='\[\e[4;31m\]';  IRed='\[\e[0;91m\]';  BIRed='\[\e[1;91m\]';  On_Red='\[\e[41m\]';  On_IRed='\[\e[0;101m\]';
Gre='\[\e[0;32m\]';  BGre='\[\e[1;32m\]';  UGre='\[\e[4;32m\]';  IGre='\[\e[0;92m\]';  BIGre='\[\e[1;92m\]';  On_Gre='\[\e[42m\]';  On_IGre='\[\e[0;102m\]';
Yel='\[\e[0;33m\]';  BYel='\[\e[1;33m\]';  UYel='\[\e[4;33m\]';  IYel='\[\e[0;93m\]';  BIYel='\[\e[1;93m\]';  On_Yel='\[\e[43m\]';  On_IYel='\[\e[0;103m\]';
Blu='\[\e[0;34m\]';  BBlu='\[\e[1;34m\]';  UBlu='\[\e[4;34m\]';  IBlu='\[\e[0;94m\]';  BIBlu='\[\e[1;94m\]';  On_Blu='\[\e[44m\]';  On_IBlu='\[\e[0;104m\]';
Pur='\[\e[0;35m\]';  BPur='\[\e[1;35m\]';  UPur='\[\e[4;35m\]';  IPur='\[\e[0;95m\]';  BIPur='\[\e[1;95m\]';  On_Pur='\[\e[45m\]';  On_IPur='\[\e[0;105m\]';
Cya='\[\e[0;36m\]';  BCya='\[\e[1;36m\]';  UCya='\[\e[4;36m\]';  ICya='\[\e[0;96m\]';  BICya='\[\e[1;96m\]';  On_Cya='\[\e[46m\]';  On_ICya='\[\e[0;106m\]';
Whi='\[\e[0;37m\]';  BWhi='\[\e[1;37m\]';  UWhi='\[\e[4;37m\]';  IWhi='\[\e[0;97m\]';  BIWhi='\[\e[1;97m\]';  On_Whi='\[\e[47m\]';  On_IWhi='\[\e[0;107m\]';

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *);;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode - red
export LESS_TERMCAP_md=$(printf '\e[01;35m') # enter double-bright mode - bold, magenta
export LESS_TERMCAP_me=$(printf '\e[0m') # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m') # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode - yellow
export LESS_TERMCAP_ue=$(printf '\e[0m') # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode - cyan

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ls='ls --color=tty'
alias ll='ls -lrt --color=tty'

if [ -f ~/.alias ]; then
    . ~/.alias
fi

export PATH=/opt/dev-setup/ldc2-linux/bin:~/.bin:$PATH
export SETUP=/opt/dev-setup
export CATALINA_HOME=$SETUP/apache-tomcat-8.0.14
export M2_HOME=$SETUP/apache-maven-3.1.1
export TERM=screen-256color
export CORE_LIB_PATH=/opt/Corelibs
export JSON_ROOT=$SETUP/json-3.9.1
export SBH_AZ_DEV=aimesdev.azurecr.io/sbh-aimes
export TFS_DOCKER=tfsdocker.ids.com/v2/sbh-es
export CMAKE_GENERATOR=Ninja
export OpenCV_DIR=/opt/dev-setup/opencv-4.5.0
export CURL_ROOT=$SETUP/curl-7.73.0
export CURL_INCLUDE_DIR=$CURL_ROOT/include
export PKG_CONFIG_PATH=$CURL_ROOT/lib/pkgconfig

# Disable TCP flow control
stty -ixon
# Disable bash escaping the variable $ sign in terminal autocomplete
shopt -s direxpand

# From https://gist.github.com/Ragnoroct/c4c3bf37913afb9469d8fc8cffea5b2f
# Simple PS1 without colors using format arg. Feel free to use PROMPT_COMMAND
export PS1="$BBla\D{%Y-%m-%d} \t$RCol $BPur\w$RCol $BBlu\$(__fastgit_ps1 '(%s)')\$(k8s_ctx '(%s)')$RCol\n$BYel\$$RCol "
export PS2="$BGre\t$RCol $BBlu\w$RCol$Gre>$Rcol "

if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

ktx()
{
    local f=$SETUP/kube-config/$1.yaml
    if [ "$1" = "" ]; then
        echo "Usage: ktx <env>"
        echo "== Available envs =="
        ls /opt/dev-setup/kube-config/ | xargs -L1 -I{} basename {} .yaml
        export KUBECONFIG=
        return
    elif [ ! -f $f ]; then
        echo "Unknown k8s env '$1'"
        return
    fi

    export KUBECONFIG=$SETUP/kube-config/$1.yaml
    echo "Switched to '$1'"
}

k8s_ctx()
{
    if [ "$KUBECONFIG" = "" ]; then
        return
    fi

    printf "\n\e[6;90m%s\e[m@\e[6;90m%s\n" $(kubens -c) $(kubectx -c)
}

# 100% pure Bash (no forking) function to determine the name of the current git branch
__fastgit_ps1()
{
    local headfile head branch
    local dir="$PWD"

    while [ -n "$dir" ]; do
        if [ -e "$dir/.git/HEAD" ]; then
            headfile="$dir/.git/HEAD"
            break
        fi
        dir="${dir%/*}"
    done

    if [ -e "$headfile" ]; then
        read -r head < "$headfile" || return
        case "$head" in
            ref:*) branch="${head##*refs/heads/}" ;;
            "") branch="" ;;
            *) branch="${head:0:7}" ;;  #Detached head. You can change the format for this too.
        esac
    fi

    if [ -z "$branch" ]; then
        return 0
    fi

    if [ -z "$1" ]; then
        # Default format
        printf "%s" "$branch"
    else
        # Use passed format string
        printf "$1" "$branch"
    fi
}

gitsync()
{
    if [ $# -lt 2 ]; then
        echo "Usage: gitsync <from> <to>"
        return 0
    fi

    local from=$1
    local to=$2
    echo "Fetching from $from"
    git fetch $from
    echo "Pushing to $to"
    git push $to --tags refs/remotes/*:refs/heads/*
}

get-bt()
{
    if [ $# -lt 2 ]; then
        echo "Usage: get-bt <exe-with-path> <core-file> [<0><1><2><3>]"
        return 0
    fi

    local exe=$1
    local core=$2
    if [ "$3" == "0" ]; then
        local var="bt"
    elif [ "$3" == "1" ]; then
        local var="bt full"
    elif [ "$3" == "2" ]; then
        local var="thread apply all bt"
    else
        local var="thread apply all bt full"
    fi

    if [ -z $3 ]; then
        var="bt full"
    fi

    gdb ${exe} \
        --core ${core} \
        --batch \
        -ex "set pagination off" \
        -ex ${var} \
        -ex "quit"
}

se()
{
    local path=$1
    local search_string="$2"

    find $path -name "*.cc" -o -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" | xargs grep -nH --color=tty "$search_string"
}

# Diff a git repo
gd()
{
    for file in $(git diff --name-only --relative)
    do
        echo "$file"
        git difftool --no-prompt $file
        echo -n "Quit? (y/n) "
        read -N1 ans
        if [ "$ans" == "y" -o "$ans" == "Y" ]; then
            echo
            return
        fi
    done
}

# Diff a hg repo
hd()
{
    for file in $(hg st -mard $1 | awk '{print $2}')
    do
        echo "$file"
        hg vimdiff $file
        echo -n "Quit? (y/n) "
        read -N1 ans
        if [ "$ans" == "y" -o "$ans" == "Y" ]; then
            echo
            return
        fi
    done
}

hgrevd()
{
    if [ "$1" == "" -o "$2" == "" ]; then
        echo "Usage: hgrevd rev1 rev2"
        return
    fi
    echo "Total files: " $(hg stat -m --rev $1:$2 | awk -F" "  '{print $2}' | wc -l)
    for file in $(hg stat -m --rev $1:$2 | awk -F" "  '{print $2}')
    do
        echo "$file"
        hg vimdiff $file -r $1 -r $2
        echo -n "Quit? (y/n) "
        read -N1 ans
        if [ "$ans" == "y" -o "$ans" == "Y" ]; then
            echo
            return
        fi
    done
}

gitd()
{
    if [ "$1" == "" -o "$2" == "" ]; then
        echo "Usage: gitd rev1 rev2"
        return
    fi
    echo "Total files: " $(git diff --name-only $1 $2 | wc -l)
    for file in $(git diff --name-only $1 $2)
    do
        echo "$file"
        git difftool --no-prompt $1 $2 -- $file
        echo -n "Quit? (y/n) "
        read -N1 ans
        if [ "$ans" == "y" -o "$ans" == "Y" ]; then
            echo
            return
        fi
    done
}

cover()
{
    if [ $# -ne 1 ]; then
        echo "Usage: codecov <-z/-c>"
        return
    fi
    echo "Collecting coverage" $1
    lcov $1 --no-external -d $UFC_HOME/video-analyzer -d $UFC_HOME/global-common -d $UFC_HOME/frame-analyzer -d $UFC_HOME/result-consolidator -o /tmp/1.info >/dev/null 2>&1
    if [ $1 = "-c" ]; then
        rm -rf /tmp/codecov
        echo "Generating HTML"
        genhtml -s --legend --rc lcov_branch_coverage=1 /tmp/1.info -o /tmp/codecov >/dev/null 2>&1
        firefox /tmp/codecov/index.html
    fi
}

old_cover()
{
    lcov --no-external -c -d .obj -b . -o SDK.info
    genhtml -s --legend SDK.info -o out
    rm -f SDK.info

:<<COMM
    local opt=$1
    local arg=$2
    if [ "$opt" = "-h" -o $# -eq 0 ]; then
        echo "Usage: cover <[-h] [-l test-no] [-o out-dir]>"
    fi

    if [ "$opt" = "-l" ]; then
        lcov -c -d src -b . -o SDK${arg}.info
        lcov -c -d sample -b sample -o SAMPLE${arg}.info
    elif [ "$opt" = "-o" ]; then
        genhtml -s --legend -o $arg
    elif [ "$opt" = "-c" ]; then
        rm -f SDK*.info SAMPLE*.info
    fi
    return 0
COMM
}

7za()
{
    7z a -t7z $@ > /dev/null
}

gettime()
{
    (cd $FFMPEG_ROOT/bin && \
        export LD_LIBRARY_PATH=$FFMPEG_ROOT/lib && \
        ./ffmpeg -i $1 2>&1 | grep -E "^|Duration|fps")
}

md()
{
    mkdir $1 && cd $1
}

mypid()
{
    ps -ef | /bin/grep $1 | /bin/grep $(whoami) | /bin/grep $1 | grep -v grep | awk '{print $2}'
}

json()
{
    python -m json.tool
}

del_nexus()
{
    if [ $# -lt 1 ]; then
        echo "Usage: del_nexus <url1 ... urlN>"
        return
    fi
    local urls=( "$@" )
    for i in $(seq 0 $#); do
        if [ ! -z ${urls[$i]} ]; then
            curl -u admin:admin123 -X DELETE ${urls[$i]}
        fi
    done
}

upload_nexus ()
{
    if [ $# -lt 2 ]; then
        echo "Usage: upload_nexus <remote-url> [<local-file-1> ... <local-file-N>]";
        return;
    fi;
    local url=$1;
    local args=("$@");
    for i in $(seq 1 $#);
    do
        if [ ! -z "${args[$i]}" ]; then
            echo == Uploading "${args[$i]}" ==;
            curl -u admin:admin123 --upload-file "${args[$i]}" $url;
        fi;
    done
}

fatcommits()
{
    git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | sed -n 's/^blob //p' | sort --numeric-sort --key=2 | cut -c 1-12,41- | $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
}

mem_monitor()
{
    if [ "$1" == "" -o "$1" == "-h" ]; then
        echo "Usage: ${FUNCNAME[0]} <pid>"
        echo "Monitors the virual and physical memory usage of a process"
        return
    fi
    while :; do grep -E "VmSize|RSS" /proc/$1/status | awk '{print $2}' | tr '\n' ',' && date "+%Y-%m-%d %H:%M:%S"; sleep 1; done
}

function pss()
{
    comm=comm
    if [ "$1" = "f" ]; then
        $1=
        comm=command
    fi

    if [ "$1" = "" ]; then
        v=pcpu
    fi

    ps axo pid,ppid,user:15,vsz:10,rss:10,pcpu:5,pmem:5,stat,tty,time,$comm k -$v
}

function pst()
{
    if [ $# -ne 1 ]; then
        echo "Usage: pst <pid>"
        echo
        echo "Print the threads of a process."
        echo "Use pss/pps/phead to find the required pid and pass it to this command."
        return
    fi

    ps axH o lwp,pid,ppid,user:15,vsz:10,rss:10,pcpu:5,pmem:5,stat,tty,time,comm -q $1
}

function pps()
{
    if [ $# -ne 1 ]; then
        echo "Usage: pps <process-name>"
        echo
        echo "Print details matching process name."
        return
    fi

    ps o pid,ppid,user:15,vsz:10,rss:10,pcpu:5,pmem:5,stat,tty,time,lstart,comm -C $1
}

