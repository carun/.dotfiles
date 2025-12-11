# ~/.config/fish/config.fish
# Fish shell configuration converted from bashrc

# Environment variables
set -gx TERM screen-256color
set -gx CMAKE_GENERATOR Ninja
set -gx LESS_TERMCAP_mb (printf '\e[01;31m')
set -gx LESS_TERMCAP_md (printf '\e[01;35m')
set -gx LESS_TERMCAP_me (printf '\e[0m')
set -gx LESS_TERMCAP_se (printf '\e[0m')
set -gx LESS_TERMCAP_so (printf '\e[01;33m')
set -gx LESS_TERMCAP_ue (printf '\e[0m')
set -gx LESS_TERMCAP_us (printf '\e[04;36m')
set -gx GOPRIVATE github.com/bot-kitchen
set -g fish_greeting
# GPG TTY setup - set correctly for each session
set -x GPG_TTY (tty)
set -Ux CHROME_EXECUTABLE /snap/bin/brave
set -Ux ANDROID_HOME ~/.android

# PATH setup
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path /usr/local/go/bin
fish_add_path /opt/oclint/bin
fish_add_path ~/.flutter/flutter/bin

if test -n "$WSL_DISTRO_NAME"
    set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    gpg-connect-agent UPDATESTARTUPTTY /bye > /dev/null
end

# XDG setup
if set -q XDG_DATA_DIRS
    set -gx XDG_DATA_DIRS ~/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:$XDG_DATA_DIRS
else
    set -gx XDG_DATA_DIRS ~/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share
end

# Check for grc
if command -v grc > /dev/null 2>&1
    set -g FOUND_GRC 0
else
    set -g FOUND_GRC 1
end

# Aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ls='ls --color=auto'
alias ll='ls -lrt --color=auto'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
# Basic command aliases
alias grc='grc --colour=on'
alias rm='rm -i'
alias ls='ls --color'
alias ll='ls -lrt'
alias grep='grep --color=auto --exclude-dir=\.git'
alias yum='sudo yum'
alias pls='sudo'
alias tailf='tail -f'
alias gdb='gdb -q'
alias tree='tree --gitignore'
alias I='sudo apt install'
alias R='sudo apt remove'
alias g='git'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Process management
alias pcpu='pss | head'
alias pmem='pss -s pmem | head'
alias pg='ps -ef | grep -v grep | grep'

# Tmux aliases
alias tmuxn='tmux -2 new -s'
alias tmuxa='tmux -2 at -t'

# Kubernetes aliases
alias k='kubectl'
alias kgp='k get pods'
alias ktx='kubectx'

# Source git alias
alias sg='sourcegit'

# Power monitoring
alias power='sudo turbostat --Summary --show power,cpu_use'

# User-specific top
function mtop
    top -u $USER $argv
end

# Kubernetes monitoring functions (converted from while loops)
function kmem
    while true
        clear
        k top pods -A | sort -hk4 | tail
        sleep 2
    end
end

function kcpu
    while true
        clear
        k top pods -A | sort -hk3 | tail
        sleep 2
    end
end

# Complex delete command
function dw
    k delete deployments,services,rs,pods -l appType=extract
    k delete deployments,services,rs,pods -l appType=search
    k delete statefulsets,services,rs,pods -l appType=data
end

# System update function (converted from compound command)
function UP
    sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove -y
end

# ESP IDF function
function __esp_idf_ps1
    if test -n "$ESP_IDF_VERSION"
        printf "IDF-%s" "$ESP_IDF_VERSION"
    end
end

# To load k8s ctx
function k8s_ctx
    if test "$KUBECONFIG" = ""
        return
    end
    printf "\n\e[6;90m%s\e[m@\e[6;90m%s\n" (kubens -c) (kubectx -c)
end

function __fastgit_ps1
    set -l headfile ""
    set -l head ""
    set -l branch ""
    set -l dir $PWD

    while test -n "$dir"
        if test -e "$dir/.git/HEAD"
            set headfile "$dir/.git/HEAD"
            break
        end
        set dir (string replace -r '/[^/]*$' '' $dir)
    end

    if test -e "$headfile"
        set head (cat $headfile)
        switch $head
            case 'ref:*'
                set branch (string replace 'ref: refs/heads/' '' $head)
            case ''
                set branch ""
            case '*'
                set branch (string sub -l 7 $head)
        end
    end

    if test -z "$branch"
        return 0
    end

    if test -z "$argv[1]"
        printf "%s" "$branch"
    else
        printf "$argv[1]" "$branch"
    end
end

function gitsync
    if test (count $argv) -lt 2
        echo "Usage: gitsync <from> <to>"
        return 0
    end

    set -l from $argv[1]
    set -l to $argv[2]
    echo "Fetching from $from"
    git fetch $from
    echo "Pushing to $to"
    git push $to --tags refs/remotes/*:refs/heads/*
end

function get-bt
    if test (count $argv) -lt 2
        echo "Usage: get-bt <exe-with-path> <core-file> [<0><1><2><3>]"
        return 0
    end

    set -l exe $argv[1]
    set -l core $argv[2]

    switch $argv[3]
        case "0"
            set -l var "bt"
        case "1"
            set -l var "bt full"
        case "2"
            set -l var "thread apply all bt"
        case "*"
            set -l var "thread apply all bt full"
    end

    if test -z "$argv[3]"
        set var "bt full"
    end

    gdb $exe \
        --core $core \
        --batch \
        -ex "set pagination off" \
        -ex "$var" \
        -ex "quit"
end

function se
    set -l path $argv[1]
    set -l search_string "$argv[2]"

    find $path -name "*.cc" -o -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" | xargs grep -nH --color=auto "$search_string"
end

function gd
    for file in (git diff --name-only --relative)
        echo "$file"
        git difftool --no-prompt $file
        echo -n "Quit? (y/n) "
        read -n1 ans
        if test "$ans" = "y" -o "$ans" = "Y"
            echo
            return
        end
    end
end

function gitd
    if test -z "$argv[1]" -o -z "$argv[2]"
        echo "Usage: gitd rev1 rev2"
        return
    end
    echo "Total files: " (git diff --name-only $argv[1] $argv[2] | wc -l)
    for file in (git diff --name-only $argv[1] $argv[2])
        echo "$file"
        git difftool --no-prompt $argv[1] $argv[2] -- $file
        echo -n "Quit? (y/n) "
        read -n1 ans
        if test "$ans" = "y" -o "$ans" = "Y"
            echo
            return
        end
    end
end

function 7za
    7z a -t7z $argv > /dev/null
end

function md
    mkdir $argv[1] && cd $argv[1]
end

function mypid
    ps -ef | grep $argv[1] | grep (whoami) | grep $argv[1] | grep -v grep | awk '{print $2}'
end

function json
    python -m json.tool
end

function fatcommits
    set -l numfmt_cmd (command -v gnumfmt || echo numfmt)
    git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | sed -n 's/^blob //p' | sort --numeric-sort --key=2 | cut -c 1-12,41- | $numfmt_cmd --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
end

function mem_monitor
    if test -z "$argv[1]" -o "$argv[1]" = "-h"
        echo "Usage: mem_monitor <pid>"
        echo "Monitors the virtual and physical memory usage of a process"
        return
    end
    while true
        grep -E "VmSize|RSS|VmData" /proc/$argv[1]/status | awk '{print $2}' | tr '\n' ','
        date "+%Y-%m-%d %H:%M:%S"
        sleep 5
    end
end

function ke
    if test (count $argv) -lt 1
        echo "Usage: ke <pod-name> [command]"
        echo "Execute the command in the given k8s pod"
        return
    end

    set -l shell $argv[2]
    if test -z "$shell"
        set shell bash
    end

    kubectl exec -it $argv[1] -- $shell
end

function print_esp_idf_versions
    set -l versions (find ~/.esp -maxdepth 1 -mindepth 1 -type d | xargs -L1 basename | cut -dv -f2)
    echo "  Available ESP IDF versions:"
    for ver in $versions
        echo "      $ver"
    end
end

function idf
    if test -z "$argv[1]"
        echo "usage: idf <version>"
        print_esp_idf_versions
        return
    end

    set -l espver $argv[1]
    if test ! -d ~/.esp/v$espver
        echo "Unknown ESP IDF version $espver"
        print_esp_idf_versions
        return
    end

    # Check if export.fish exists, fallback to export.sh
    if test -f ~/.esp/v$espver/esp-idf/export.fish
        source ~/.esp/v$espver/esp-idf/export.fish
    else if test -f ~/.esp/v$espver/esp-idf/export.sh
        bass source ~/.esp/v$espver/esp-idf/export.sh
    end

    set -gx IDF_TOOLS_PATH ~/.espressif

    if test "$espver" = "5.4.1"
        set -gx IDF_COMPILER_PATH "$IDF_TOOLS_PATH/tools/xtensa-esp-elf/esp-14.2.0_20241119/xtensa-esp-elf/bin/xtensa-esp32-elf-gcc"
    else
        set -gx IDF_COMPILER_PATH "$IDF_TOOLS_PATH/tools/xtensa-esp-elf/esp-13.2.0_20240530/xtensa-esp-elf/bin/xtensa-esp32-elf-gcc"
    end
end

# Custom prompt function
function fish_prompt
    set -l last_status $status

    # Date and time
    printf "%s%s %s%s " (set_color brblack) (date +%Y-%m-%d) (date +%T) (set_color normal)

    # ESP IDF version
    set -l esp_info (__esp_idf_ps1)
    if test -n "$esp_info"
        printf "%s%s%s " (set_color -o yellow) $esp_info (set_color normal)
    end

    # Current directory
    printf "%s%s%s " (set_color -o magenta) (prompt_pwd) (set_color normal)

    # Git branch with status color - force fresh check every time
    set -l git_branch (__fastgit_ps1)
    if test -n "$git_branch"
        # Always check git status fresh (no caching)
        if git rev-parse --git-dir >/dev/null 2>&1
            # Check for unstaged changes first
            if not git diff --quiet 2>/dev/null
                # Unstaged changes - red
                printf "%s(%s)%s " (set_color -o red) $git_branch (set_color normal)
            else if not git diff --quiet --cached 2>/dev/null
                # Staged changes - yellow
                printf "%s(%s)%s " (set_color -o yellow) $git_branch (set_color normal)
            else
                # Clean - green
                printf "%s(%s)%s " (set_color -o green) $git_branch (set_color normal)
            end
        end
    end

    echo ""

    # Prompt symbol based on last command's exit status
    if test $last_status -eq 0
        printf "%s\$ %s" (set_color -o yellow) (set_color normal)
    else
        printf "%s\$ %s" (set_color -o red) (set_color normal)
    end
end

# Right prompt for k8s context
function fish_right_prompt
    k8s_ctx
end

# Load additional configuration if it exists
if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
