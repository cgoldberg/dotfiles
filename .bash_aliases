# --------------------------------------------------------
# ~/.bash_aliases: sourced in bashrc for non-login shells
# aliases and functions customized for cgoldberg
# --------------------------------------------------------

# enable auto-completion for "g" alias
__git_complete g _git
alias g="git"

alias ls="\ls -lhAFG --color=auto --group-directories-first"
alias l="\ls -AFG --color=auto --group-directories-first"

alias grep="grep --color=auto"

alias less="less --LONG-PROMPT --no-init --quit-at-eof --quit-if-one-screen --quit-on-intr --RAW-CONTROL-CHARS"
alias more='less'

alias x="exit"
alias cls="clear"
alias df="df -Th --total"

# recursive file count from current directory
alias filecount="find . -type f | wc -l"

# display 100 latest modified files under current dir (sorted in reverse)
alias latest="find . -type f -printf '%TY-%Tm-%Td %TR %p\n' 2>/dev/null | sort -n | tail -n 100"

# list desktop trash (on all gvfs mounted volumes)
alias trash-ls="gvfs-ls trash://"

# empty desktop trash (on all gvfs mounted volumes)
alias trash-empty="gvfs-trash --empty"

# disable line wrapping (long lines truncated at terminal width)
alias nowrap="tput rmam"

# enable line wrapping (long lines wrapped at terminal width)
alias wrap="tput smam"

#----------------------------------------------------------------

# display names of all public bash functions and aliases in current shell
function funcs () {
    compgen -a -A function | grep -v ^_ | sort
}

# search command history by regex
# (when called with no args, show last 100 commands)
# usage: h <pattern>
function h () {
    if [ $# -eq 0 ]; then
        history | tail -n 100
    else
        history | grep --color=never $1
    fi
}

# search process info by regex
# (when called with no args, show all processes)
# usage: psgrep <pattern>
function psgrep () {
    if [ $# -eq 0 ]; then
        ps aux | less --chop-long-lines
    else
        ps aux | grep --color=always $1 | grep -v grep | less --chop-long-lines
    fi
}

# search for partially matching file names starting under $HOME
# (creates or updates mlocate database before searching)
# usage: name <pattern>
function name () {
    updatedb --require-visibility 0 --output ~/.locatedb --database-root ~
    locate --database ~/.locatedb $1
}

# launch SciTE (GUI) editor in the background and suppress stdout/stderr
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
}

# purge configuration data from packages marked for removal
function purge-apt-configs () {
    if $(dpkg -l | grep --quiet '^rc'); then
        echo "purging package configs from removed packages..."
        $(dpkg -l | grep '^rc' | awk '{print $2}' | xargs sudo dpkg --purge)
    else
        echo "no package configuration data to remove"
    fi
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
weather() {
    ZIPCODE="02116"
    curl -s "http://www.wunderground.com/q/zmw:$ZIPCODE.1.99999" | grep "og:title" | cut -d\" -f4 | sed 's/&deg;/ degrees F/';
}

# archive extractor
# usage: extract <file>
extract () {
    if [ $# -eq 0 ]; then
        echo "please specify an archive to extract"
        return 1
    fi
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1;;
            *.tar.gz)    tar xzf $1;;
            *.bz2)       bunzip2 $1;;
            *.rar)       unrar e $1;;
            *.gz)        gunzip $1;;
            *.tar)       tar xf $1;;
            *.tbz2)      tar xjf $1;;
            *.tgz)       tar xzf $1;;
            *.zip)       unzip $1;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1;;
            *)           echo "extracting '$1' is not supported";;
        esac
    else
        echo "'$1' is not a valid file"
        return 1
    fi
}
