# --------------------------------------------------------
# ~/.bash_aliases: sourced in .bashrc for non-login shells
#
# aliases and functions customized for cgoldberg
# --------------------------------------------------------


# enable auto-completion for "g" alias
__git_complete g _git
alias g="git"

# defaults for ls
alias ls="\ls -lhAFG --color=auto --group-directories-first"
alias l="\ls -AFG --color=auto --group-directories-first"

# colorize grep
alias grep="grep --color=auto"

# text pager defaults
alias less="\less --LONG-PROMPT --no-init --quit-at-eof --quit-if-one-screen --quit-on-intr --RAW-CONTROL-CHARS"
alias more="most"

# halt and power-off machine via init system, and trigger a reboot
alias reboot="sudo reboot"

# halt and power-off machine via init system
alias shutdown="sudo poweroff"

# clear terminal
alias cls="clear"

# exit terminal
alias x="exit"

# display amount of disk available on all local and samba mounted drives
alias diskfree="df -hT --total --type=ext4 --type=cifs --sync"

# display amount of disk used under current directory, grouped and sorted by directory size
alias diskused="du -S | sort -nr | most"

# serve current dir over HTTP on port 8000
alias webserver='python -m SimpleHTTPServer'

# count files recursively under current directory
alias filecount="find . -type f | wc -l"

# display 100 latest modified files under current dir (sorted in reverse)
alias latest="find . -type f -printf '%TY-%Tm-%Td %TR %p\n' 2>/dev/null | sort -n | tail -n 100"

# purge desktop trash (on all gvfs mounted volumes)
alias purge-trash="gvfs-trash --empty"

# disable line wrapping in terminal (long lines truncated at terminal width)
alias nowrap="tput rmam"

# enable line wrapping in terminal (long lines wrapped at terminal width)
alias wrap="tput smam"


#----------------------------------------------------------------


# display names of all public bash functions and aliases in current shell
function funcs () {
    compgen -a -A function | grep -v ^_ | sort
}


# side-by-side colored diff
# requires colordiff package
function sdiff () {
    if [ $# -ne 2 ]; then
        echo "usage: sdiff <file1> <file2>"
    else
        diff -y $1 $2 | cdiff | most
    fi
}


# search command history by regex (case-insensitive)
# (when called with no args, show last 100 commands)
# usage: h <pattern>
function h () {
    if [ $# -eq 0 ]; then
        history | tail -n 100
    else
        history | grep -i --color=always $1
    fi
}


# search process info by regex
# (when called with no args, show all processes)
# usage: psgrep <pattern>
function psgrep () {
    if [ $# -eq 0 ]; then
        ps aux | most
    else
        ps aux | grep --color=always $1 | grep -v grep | most
    fi
}


# search for partially matching file names starting under $HOME
# (creates or updates mlocate database before searching)
# usage: name <pattern>
function name () {
    updatedb --require-visibility 0 --output ~/.locatedb --database-root ~
    locate --database ~/.locatedb $1
}


# launch SciTE (GTK) editor in the background and suppress stdout/stderr
# (keeps running after the shell session ends and doesn't appear in jobs list)
# usage: scite <file>
function scite () {
    nohup scite "$@" > /dev/null 2>&1 & disown
}


# update all packages and do package maintenance
function apt-all () {
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
    if ! $(dropbox running); then
        dropbox stop
    fi
    CACHE_DIR=~/Dropbox/.dropbox.cache/
    du -h $CACHE_DIR
    rm -rf $CACHE_DIR
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


# get current weather
# (when called with no args, default to Boston weather)
# usage: weather <zipcode>
weather() {
    if [ $# -eq 0 ]; then
        ZIPCODE="02116"
    else
        ZIPCODE = $1
    fi
    curl -s "http://www.wunderground.com/q/zmw:$ZIPCODE.1.99999" | \
        grep "og:title" | cut -d\" -f4 | sed 's/&deg;/ degrees F/'
}


# extract any archive into a new directory
extract() {
    if [ $# -eq 0 ]; then
        echo "usage: extract <file>"
    else
        dtrx -v $1
    fi
}
