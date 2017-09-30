# --------------------------------------------------------
# ~/.bash_aliases: sourced in .bashrc for non-login shells
#
# shell aliases and functions (Ubuntu) for cgoldberg
# --------------------------------------------------------

# expand aliases when run with sudo
alias sudo="sudo "

# expand aliases when running watch command
alias watch="watch "

# text editors
alias sublime="subl"
alias edit="subl"
alias ed="subl"
alias e="subl -n ."
alias vi="vim"
alias v="vim"

# text pagers
alias less="\less --LONG-PROMPT --no-init --quit-at-eof --quit-if-one-screen --quit-on-intr --RAW-CONTROL-CHARS"
alias more="less"

# enable auto-completion for git commands
alias g="git"
__git_complete g _git

# colored directory listings
alias ls="\ls -hlAFG --group-directories-first --color=auto"
alias l="\ls -AF --group-directories-first --color=auto"

# colored grep output
alias grep="\grep --color=auto"

# system shutdown
alias sd="sudo \poweroff"
alias shutdown="sudo \poweroff"

# system reboot
alias rb="sudo \reboot"
alias reboot="sudo \reboot"

# clear terminal
alias cls="clear"
alias c="clear"

# exit terminal
alias ex="exit"
alias x="exit"

# ip addresses
alias externalip="curl icanhazip.com"
alias localip="hostname -I"
alias ips="echo -n 'local IP: ' && localip && echo -n 'external IP: ' && externalip"

# show disk space available on all mounted ext4 filesystems
alias df="\df --sync --human-readable --total --type=ext4"
alias diskfree="df"
alias diskspace="df"

# show disk space used by files and directories under the current directory on current filesystem
alias du="\du --all --human-readable --one-file-system . | sort -h"
alias diskused="du"

# watch disk space used by largest directories under the current directory on current filesystem
alias dw="watch --precise --interval=3 '\du -hx . | sort -h | tail -n 25'"
alias diskwatch="dw"

# serve current directory over HTTP on port 8000
alias webserver="python -m SimpleHTTPServer"

# count installed packages
alias countpackages="dpkg -l | grep '^ii' | wc -l"

# count files recursively under current directory
alias countfiles="find . -type f 2>/dev/null | wc -l"

# show last modified files under current dir
alias latestfiles="find . -type f -printf '%TY-%Tm-%Td %TR %p\n' 2>/dev/null | sort -n | tail -n 50"

# purge desktop trash on all gvfs mounted volumes
alias purge-trash="gvfs-trash --empty"

# install package from repo
alias apt-install="sudo apt-get update && sudo apt-get install"

# remove package and it's config files
alias apt-remove="sudo apt-get update && sudo apt-get remove --purge"

# show package description
alias apt-show="apt-cache show"

# show package installation status and repository it belongs to
alias apt-policy="sudo apt-get update && apt-cache policy"

# enable auto-completion of package names for apt-* aliases
_pkg_completion () {
    _init_completion || return
    mapfile -t COMPREPLY < <(apt-cache --no-generate pkgnames "${COMP_WORDS[COMP_CWORD]}")
}
complete -F _pkg_completion apt-install
complete -F _pkg_completion apt-remove
complete -F _pkg_completion apt-show
complete -F _pkg_completion apt-policy


# disable line wrapping in terminal (long lines truncated at terminal width)
alias nowrap="tput rmam"

# enable line wrapping in terminal (long lines wrapped at terminal width)
alias wrap="tput smam"

# color diff output (requires colordiff package)
alias diff="colordiff -s"

# make yourself look all busy and fancy to non-technical people
alias busy="cat /dev/urandom | hexdump -C | grep --color=always 'ca fe'"

# change directory to wd-green mount point
alias hdd="cd /mnt/wd-green"

# navigate up the directory tree using dots
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."


#----------------------------------------------------------------


# list public bash functions and aliases defined in the current shell
funcs () {
    compgen -a -A function | grep -v ^_ | sort
}


# reload shell configurations
re-source () {
    if [[ -f ~/.bashrc ]]; then
        source ~/.bashrc
    fi
}


# search command history by regex (case-insensitive)
# (when called with no args, show last 100 commands)
# usage: h <pattern>
h () {
    if [[ $# -eq 0 ]]; then
        history | tail -n 100
    else
        history | grep -i --color=always "$1"
    fi
}


# search process info by regex (case-insensitive)
# (when called with no args, show all processes)
# usage: psgrep <pattern>
psgrep () {
    if [[ $# -eq 0 ]]; then
        ps aux | less
    else
        ps aux | grep -i --color=always "$1" | grep -v 'grep' | less
    fi
}


# convert all .png to .jpg in current directory and rename file extensions
convert_pngs_to_jpgs () {
    findpngs () {
        find . -maxdepth 1 -type f -iname "*.png" -prune
    }
    if [[ -n $(find_pngs) ]]; then
        findpngs | parallel convert -quality 95% {} {.}.jpg
        findpngs | parallel rm {}
    else
        echo 'nothing to convert'
    fi
}


# search recursively under current directory for text file contents containing regex (case-insensitive)
rgrep () {
    fgrep -iInr --color=always --exclude-dir='.git' "$1" . | less -R
}



# search entire filesystem for filenames matching glob pattern (case-insensitive)
# update the mlocate database before searching
locatefiles () {
    updatedb --require-visibility 0 --output ~/.locatedb
    locate --existing --ignore-case --database ~/.locatedb "$@"
}


# search recursively under current directory for filenames matching pattern (case-insensitive).
# results are sorted by date
# usage: findfiles <pattern>
findfiles () {
    find .  -iname "*$1*" -type f -print0 | xargs -0 ls -flrt | awk '{print $6, $7, $9}'
}


# change directory to NAS mount point
# mount the filesystem first if needed
nas () {
    local share="public"
    local server="bytez"
    local user="admin"
    local mount_dir=/run/user/"${UID}"/gvfs/smb-share:server="${server}",share="${share}",user="${user}"
    if [[ ! -d "$mount_dir" ]]; then
        gvfs-mount smb://"${user}"@"${server}"/"${share}"
    fi
    cd "$mount_dir"
}


# package maintenance
apt-up () {
    # reload package index files from sources
    sudo apt-get update
    # upgrade all installed packages using smart conflict resolution
    sudo apt-get dist-upgrade
    # check for broken dependencies
    sudo apt-get check
    # fix broken dependencies
    sudo apt-get install --fix-broken
    # remove packages installed by other packages that are no longer needed
    sudo apt-get autoremove --purge
    # remove all packages from the package cache
    sudo apt-get clean
    echo "$(countpackages) packages currently installed"
}


# purge configuration data from packages marked for removal
purge-apt-configs () {
    if $(dpkg -l | grep --quiet '^rc'); then
        echo "$(dpkg -l | grep '^rc' | wc -l) packages have orphaned configs"
        echo "purging package configs from removed packages..."
        dpkg -l | grep '^rc' | awk '{print $2}' | xargs sudo dpkg --purge
    else
        echo "no package configuration data to remove"
    fi
    echo "$(countpackages) packages currently installed"
}


# stop Dropbox and purge local cache
purge-dropbox-cache () {
    dropbox stop
    sleep 1
    cache_dir=~/Dropbox/.dropbox.cache/
    if [[ -e "$cache_dir" ]]; then
        \du -ah "$cache_dir"
        rm -rf "$cache_dir"
    fi
}


# show all 256 terminal colors (foreground and background)
show-colors () {
    for fgbg in 38 48; do
        for color in {0..256}; do
            echo -en "\e[${fgbg};5;${color}m ${color}\t\e[0m"
            if [ $((($color + 1) % 10)) == 0 ]; then
                echo
            fi
        done
        echo
    done
}


# send an HTTP GET and display timings (poor man's http profiler)
# usage: http-profile <url>
http-profile () {
    if [[ $# -lt 1 ]]; then
        echo "no URL specified!" && return 1
    else
        w="\n"
        w+="URL:\t\t$1\n"
        w+="Local IP:\t%{local_ip}\n"
        w+="Remote IP:\t%{remote_ip}\n\n"
        w+="Status code:\t%{http_code}\n"
        w+="Response size:\t%{size_download}\n\n"
        w+="DNS time:\t%{time_namelookup}\n"
        w+="Connect time:\t%{time_connect}\n"
        w+="PretXfer time:\t%{time_pretransfer}\n"
        w+="StartXfer time:\t%{time_starttransfer}\n"
        w+="Total time:\t%{time_total}\n\n"
        curl -sS --compressed -o /dev/null -w "$w" "$1"
    fi
}
