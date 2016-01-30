# --------------------------------------------------------
# ~/.bash_asliases: sourced in bashrc for non-login shells
# aliases and functions customized for cgoldberg
# --------------------------------------------------------

# enable auto-completion for "g" alias
__git_complete g _git
alias g="git"

# enable color support (when available) for ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="\ls -AFGl --color=auto"
    alias l="\ls -F --color=auto"
    alias lsl="\ls -AFGl --color=always | more"
    alias grep="grep --color=auto"
fi

alias x="exit"
alias cls="clear"
alias count-files-recursively="find . -type f | wc -l"
alias strip-jpgs="exiv2 -d a *.jpg"

# list desktop trash (works against all gvfs mounted volumes)
alias trash-list="gvfs-ls trash://"

# empty desktop trash (works against all gvfs mounted volumes)
alias trash-empty="gvfs-trash --empty"

# disable line wrapping in the terminal (long lines truncated at terminal width)
alias nowrap="tput rmam"

# enable line wrapping in the terminal (long lines wrapped at terminal width)
alias wrap="tput smam"

#----------------------------------------------------------------

# search command history
function h () {
    history | grep $1
}

# search process info
function psgrep () {
    ps aux | grep --color=always $1 | grep -v grep | more
}

# recursively search for file names, partially matching, starting from user HOME
# (creates or updates mlocate database before searching)
function name () {
    updatedb --require-visibility 0 --output ~/locatedb --database-root ~
    locate --database ~/locatedb $1
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
        $(dpkg -l | grep '^rc' | awk '{print $2}' | xargs sudo dpkg --purge)
    else
        echo "no package configuration data to remove"
    fi
}

# purge thumbnail cache
function purge-thumbnail-cache () {
    CACHED_DIR=~/.cache/thumbnails/
    echo "size before purge:"
    du -sh $CACHED_DIR
    find $CACHED_DIR -type f -exec rm -rf {} \;
    echo "size after purge:"
    du -sh $CACHED_DIR
}

# purge local Dropbox cache
function purge-dropbox-cache () {
    CACHED_DIR=~/Dropbox/.dropbox.cache/
    echo "size before purge:"
    du -sh $CACHED_DIR
    find $CACHED_DIR -type f -exec rm -rf {} \;
    echo "size after purge:"
    du -sh $CACHED_DIR
}
