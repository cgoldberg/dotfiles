# --------------------------------------------------------
# ~/.bash_aliases: sourced in .bashrc for non-login shells
#
# aliases and functions customized for cgoldberg
#
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
alias more="most"
alias less="\less --LONG-PROMPT --no-init --quit-at-eof --quit-if-one-screen --quit-on-intr --RAW-CONTROL-CHARS"

# run git with command auto-completion enabled
alias g="git"
__git_complete g _git

# colored directory listings
alias ls="\ls -lhAFG --color=auto --group-directories-first"
alias l="\ls -AFG --color=auto --group-directories-first"

# colored grep
alias grep="\grep --color=auto"

# halt, power off, and restart via systemd
alias reboot="systemctl reboot"

# halt and power off via systemd
alias shutdown="systemctl poweroff"

# clear terminal
alias cls="clear"
alias c="clear"

# exit terminal
alias x="exit"

# disk space available on local ext4 and samba mounted filesystems
alias diskspace="df -hT --total --type=ext4 --type=cifs --sync"

# disk space usage under current directory, grouped and sorted by directory size
alias diskused="du -S | sort -nr | most"

# serve current directory over HTTP on port 8000
alias webserver='python -m SimpleHTTPServer'

# count files recursively under current directory
alias filecount="find . -type f | wc -l"

# last modified files under current dir (100 entries, sorted in reverse)
alias latest="find . -type f -printf '%TY-%Tm-%Td %TR %p\n' 2>/dev/null | sort -n | tail -n 100"

# purge desktop trash on all gvfs mounted volumes
alias purge-trash="gvfs-trash --empty"

# install package from repo
alias apt-install="sudo apt-get update && sudo apt-get install"

# package description
alias apt-show="apt-cache show"

# package installation status and repository it belongs to
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

# show diffs in side-by-side mode, with colors and automatic column widths
# (requires colordiff package)
alias diff="colordiff -yW`tput cols`"

# navigate up the directory tree using dots
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# make yourself look all busy and fancy to non-technical people
alias busy="cat /dev/urandom | hexdump -C | grep 'ca fe'"


#----------------------------------------------------------------


# list public bash functions and aliases defined in the current shell
function funcs () {
    compgen -a -A function | grep -v ^_ | sort
}


# reload shell configurations
function re-source () {
    if [ -f ~/.profile ]; then
        . ~/.profile
    fi
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


# show directory tree with individual file/dir sizes
# (hidden files and colors enabled, `.git` directories ignored)
# usage: tre [dir]
function tre() {
	\tree -ahCF -I '.git' --dirsfirst "$@" | most
}


# search entire filesystem for filenames matching glob pattern
# (case insensitive, skips any filesystems mount under /mnt, updates the mlocate database before searching)
# usage: name <pattern>
function name () {
    if [ $# -eq 0 ]; then
        echo "usage: name <pattern>"
    else
        updatedb --require-visibility 0 --output ~/.locatedb --database-root / --prunepaths /mnt
        locate --existing --ignore-case --database ~/.locatedb $1
    fi
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
    if ! $(dropbox running); then
        dropbox stop
    fi
    cache_dir=~/Dropbox/.dropbox.cache/
    du -h $cache_dir
    rm -rf $cache_dir
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
# usage: weather [zipcode]
function weather () {
    if [ $# -eq 0 ]; then
        zipcode="02116"
    else
        zipcode=$1
    fi
    curl -sL "http://www.wunderground.com/q/zmw:$zipcode.1.99999" | \
        grep "og:title" | cut -d\" -f4 | sed 's/&deg;/ degrees F/'
}


# extract any archive into a new directory
function extract () {
    if [ $# -eq 0 ]; then
        echo "usage: extract <file>"
    else
        dtrx -v $1
    fi
}


# share a file
# (upload file to https://transfer.sh/ and display the public url for download)
# usage: transfer <file>
function transfer () {
    if [ $# -eq 0 ]; then
        echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
        return 1
    fi
    tmpfile=$(mktemp -t transferXXX)
    if tty -s; then
        basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g')
        curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile
    else
        curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile
    fi
    cat $tmpfile
    rm -f $tmpfile
}
