# --------------------------------------------------------
# ~/.bash_aliases: sourced in .bashrc for non-login shells
#
# shell aliases and functions for use on Ubuntu
# customized for cgoldberg
# --------------------------------------------------------

# allow aliases to run with sudo
# (if the last character of an alias is a blank, the next command is also checked for alias expansion)
alias sudo="sudo "

# shortcuts for editors
alias edit="scite"
alias ed="scite"
alias vi="\vim"
alias v="\vim"

# shortcuts for text pagers
alias more="less"
alias less="\less --LONG-PROMPT --no-init --quit-at-eof --quit-if-one-screen --quit-on-intr --RAW-CONTROL-CHARS"

# run git with command auto-completion enabled
alias g="git"
__git_complete g _git

# color directory listings
alias ls="\ls -lhAFG --color=auto --group-directories-first"
alias l="\ls -AFG --color=auto --group-directories-first"

# color grep output
alias grep="\grep --color=auto"

# system shutdown
alias sd="sudo poweroff"
alias poweroff="sudo poweroff"
alias shutdown="sudo poweroff"
alias rb="sudo reboot"
alias reboot="sudo reboot"

# clear terminal
alias cls="clear"
alias c="clear"

# exit terminal
alias x="exit"

# disk space available on local ext4 and samba filesystems
alias diskspace="df -hT --total --type=ext4 --type=cifs --sync"

# disk space used under current directory, grouped and sorted by directory size
alias diskused="du -S | grep -v .git | sort -nr | less"

# serve current directory over HTTP on port 8000
alias webserver='python -m SimpleHTTPServer'

# count files recursively under current directory
alias filecount="find . -type f | wc -l"

# show last modified files under current dir (100 entries, sorted in reverse)
alias latest="find . -type f -printf '%TY-%Tm-%Td %TR %p\n' 2>/dev/null | sort -n | tail -n 100"

# purge desktop trash on all gvfs mounted volumes
alias purge-trash="gvfs-trash --empty"

# install package from repo
alias apt-install="sudo apt-get update && sudo apt-get install"

# show package description
alias apt-show="apt-cache show"

# show package installation status and repository it belongs to
alias apt-policy="apt-cache policy"

# enable auto-completion of package names for apt-* aliases
_pkg_completion() {
    _init_completion || return
    mapfile -t COMPREPLY < <(apt-cache --no-generate pkgnames "${COMP_WORDS[COMP_CWORD]}")
}
complete -F _pkg_completion apt-show
complete -F _pkg_completion apt-policy
complete -F _pkg_completion apt-install

# disable line wrapping in terminal (long lines truncated at terminal width)
alias nowrap="tput rmam"

# enable line wrapping in terminal (long lines wrapped at terminal width)
alias wrap="tput smam"

# color diff output
# (requires colordiff package)
alias diff="\colordiff -s"

# navigate up the directory tree using dots
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# make yourself look all busy and fancy to non-technical people
alias busy="cat /dev/urandom | hexdump -C | grep --color=always 'ca fe'"


#----------------------------------------------------------------


# list public bash functions and aliases defined in the current shell
function funcs () {
    compgen -a -A function | grep -v ^_ | sort
}


# reload shell configurations
function re-source () {
    if [ -f ~/.bashrc ]; then
        . ~/.bashrc
    fi
    if [ -f ~/.bash_profile ]; then
        . ~/.bash_profile
    fi
}


# search command history by regex (case-insensitive)
# (when called with no args, show last 100 commands)
# usage: h <pattern>
function h () {
    if [ $# -eq 0 ]; then
        history | tail -n 100
    else
        history | grep -i --color=always "$1"
    fi
}


# search process info by regex (case-insensitive)
# (when called with no args, show all processes)
# usage: psgrep <pattern>
function psgrep () {
    if [ $# -eq 0 ]; then
        ps aux | less
    else
        ps aux | grep -i --color=always "$1" | grep -v grep | less
    fi
}


# convert all PNG images in current directory to JPG format and delete originals
function convert_png_to_jpg () {
    find . -type f -iname "*.png" -prune | parallel convert -quality 95% {} {.}.jpg
    find . -type f -iname "*.png" -prune | parallel rm {}

}


# search recursively for text file content by regex (case-insensitive)
# in files under current directory
# usage: rgrep <pattern>
function rgrep () {
    fgrep -iInr --color=always --exclude-dir=".git" "$1" . | less
}


# search entire filesystem for filenames matching glob pattern
# (case insensitive, skip any filesystems mounted under /mnt)
# update the mlocate database before searching
# usage: name <pattern>
function name () {
    updatedb --require-visibility 0 --output ~/.locatedb --database-root / --prunepaths /mnt
    locate --existing --ignore-case --database ~/.locatedb $1
}


# launch SciTE (GTK) editor in the background and suppress stdout/stderr
# (keeps running after the shell session ends and doesn't appear in jobs list)
# usage: scite <file>
function scite () {
    nohup scite "$@" > /dev/null 2>&1 & disown
}


# package maintenance
function apt-maintain () {
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
    # display number of packages installed
    echo "$(dpkg -l | grep '^ii' | wc -l) packages currently installed"
}


# purge configuration data from packages marked for removal
function purge-apt-configs () {
    if $(dpkg -l | grep --quiet '^rc'); then
        echo "$(dpkg -l | grep '^rc' | wc -l) packages have orphaned configs"
        echo "purging package configs from removed packages..."
        dpkg -l | grep '^rc' | awk '{print $2}' | xargs sudo dpkg --purge
    else
        echo "no package configuration data to remove"
    fi
    echo "$(dpkg -l | grep '^ii' | wc -l) packages currently installed"
}


# purge local Dropbox cache
function purge-dropbox-cache () {
    dropbox stop
    cache_dir=~/Dropbox/.dropbox.cache/
    if [ -e $cache_dir ]; then
        du -h $cache_dir
        rm -rf $cache_dir
    fi
    dropbox start
}


# print all 256 terminal colors as both foreground and background
function print-colors () {
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


# display one-line weather report
# accepts an optional zipcode
# defaults to weather in Boston, MA
# usage: weather [zipcode]
function weather () {
    if [[ $# -eq 0 ]]; then
        zipcode="02116"
    else
        zipcode=$1
    fi
    curl -sL "http://www.wunderground.com/q/zmw:$zipcode.1.99999" | \
        grep "og:title" | cut -d\" -f4 | sed 's/&deg;/ degrees F/'
}


# extract any archive into a new directory
# usage: extract <archive>
function extract () {
    dtrx -v $1
}


# send an HTTP GET and display timings (poor man's http profiler)
function http_profile () {
    curl "$@" -s -o /dev/null -w \
"response_code: %{http_code}
dns_time: %{time_namelookup}
connect_time: %{time_connect}
pretransfer_time: %{time_pretransfer}
starttransfer_time: %{time_starttransfer}
total_time: %{time_total}"
}
