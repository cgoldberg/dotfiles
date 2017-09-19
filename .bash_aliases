# --------------------------------------------------------
# ~/.bash_aliases: sourced in .bashrc for non-login shells
#
# shell aliases and functions (Ubuntu) for cgoldberg
# --------------------------------------------------------

# expand aliases when run with sudo (following command is checked for alias expansion)
alias sudo="sudo "

# expand aliases when running watch command (following command is checked for alias expansion)
alias watch="watch "

# shortcuts for editors
alias edit="subl"
alias ed="subl"
alias e="subl ."
alias vi="\vim"
alias v="\vim"

# shortcuts for text pagers
alias less="\less --LONG-PROMPT --no-init --quit-at-eof --quit-if-one-screen --quit-on-intr --RAW-CONTROL-CHARS"
alias more="less"

# enable auto-completion for git commands
alias g="git"
__git_complete g _git

# colored directory listings
alias ls="\ls -lhAFG --color=auto --group-directories-first"
alias l="\ls -AFG --color=auto --group-directories-first"

# colored grep output
alias grep="\grep --color=auto"

# system shutdown
alias sd="sudo poweroff"
alias poweroff="sudo poweroff"
alias shutdown="sudo poweroff"

# system reboot
alias rb="sudo reboot"
alias reboot="sudo reboot"

# clear terminal
alias cls="clear"
alias c="clear"

# exit terminal
alias x="exit"

# get external ip address
alias myip="curl icanhazip.com"

# show disk space available on mounted ext4 filesystems
alias diskspace="df --sync --human-readable --total --type=ext4"

# show disk space used by files and directories in the current filesystem
alias diskused="du -ahx | grep -v .git | sort -h"

# watch disk space used by largest subdirectories under current directory
alias diskwatch="watch --precise --interval=1 'du -hx | grep -v .git | tail -n 20 | sort -h'"

# serve current directory over HTTP on port 8000
alias webserver="python -m SimpleHTTPServer"

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

# make yourself look all busy and fancy to non-technical people
alias busy="cat /dev/urandom | hexdump -C | grep --color=always 'ca fe'"

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
h () {
    if [ $# -eq 0 ]; then
        history | tail -n 100
    else
        history | grep -i --color=always "$1"
    fi
}


# search process info by regex (case-insensitive)
# (when called with no args, show all processes)
# usage: psgrep <pattern>
psgrep () {
    if [ $# -eq 0 ]; then
        ps aux | less
    else
        ps aux | grep -i --color=always "$1" | grep -v grep | less
    fi
}


# convert .png images in current directory to .jpg format and rename file extensions
convert_pngs_to_jpgs () {
    find_pngs () {
        find . -type f -iname "*.png" -prune
    }
    if [[ -n $(find_pngs) ]]; then
        (find_pngs | parallel convert -quality 95% {} {.}.jpg) && (find_pngs | parallel rm {})
    else
        echo "nothing to convert"
    fi
}


# search recursively for text file content by regex (case-insensitive)
# in files under current directory
# usage: rgrep <pattern>
rgrep () {
    fgrep -iInr --color=always --exclude-dir=".git" "$1" . | less
}


# search entire filesystem for filenames matching glob pattern
# (case insensitive, skip any filesystems mounted under /mnt)
# update the mlocate database before searching
# usage: name <pattern>
name () {
    updatedb --require-visibility 0 --output ~/.locatedb --database-root / --prunepaths /mnt
    locate --existing --ignore-case --database ~/.locatedb "$1"
}


# launch SciTE (GTK) editor in the background and suppress stdout/stderr
# (keeps running after the shell session ends and doesn't appear in jobs list)
# usage: scite <file>
scite () {
    nohup scite "$@" > /dev/null 2>&1 & disown
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
    # display number of packages installed
    echo "$(dpkg -l | grep '^ii' | wc -l) packages currently installed"
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
    echo "$(dpkg -l | grep '^ii' | wc -l) packages currently installed"
}


# purge local Dropbox cache
purge-dropbox-cache () {
    dropbox stop
    cache_dir=~/Dropbox/.dropbox.cache/
    if [ -e $cache_dir ]; then
        du -h $cache_dir
        rm -rf $cache_dir
    fi
    dropbox start
}


# print all 256 terminal colors as both foreground and background
print-colors () {
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


# display one-line weather report for Boston (02116)
weather () {
    local ZIPCODE=02116
    curl -sL "http://www.wunderground.com/q/zmw:$ZIPCODE.1.99999" | \
    grep "og:title" | \
    cut -d\" -f4 | \
    sed "s/&deg;/° F/"
}


# extract any type of archive into a new directory
extract () {
    dtrx -v $1
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
