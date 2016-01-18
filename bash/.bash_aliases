# cgoldberg
# bash alias definitions and functions
# ------------------------------------

alias g="git"
alias cls="clear"
alias clear-dropbox-cache="rm -rf ~/Dropbox/.dropbox.cache/*"
alias count-files-recursively="find . -type f | wc -l"
alias strip-jpgs="exiv2 -d a *.jpg"
alias scoreboard="git log | grep Author | sort | uniq -ci | sort -hr"
# search history
alias h="history | grep "

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="\ls -AFGl --color=auto"
    alias l="\ls -F --color=auto"
    alias lsl="\ls -AFGl --color=always | more"
    alias grep="grep --color=auto"
fi

# update packages and do maintenance
function apt-all () {
    # reload package index files from sources
    sudo apt-get update
    # upgrade all installed packages using smart conflict resolution
    sudo apt-get dist-upgrade --show-progress
    # check for broken dependencies
    sudo apt-get check
    # fix broken dependencies
    sudo apt-get install --fix-broken --show-progress
    # remove packages installed by other packages and no longer needed
    sudo apt-get autoremove --purge --show-progress
    # remove all packages from the package cache
    sudo apt-get clean
}

# purge configuration data from packages marked for removal
function clear-apt-configs () {
    if $(dpkg -l | grep --quiet '^rc'); then
        $(dpkg -l | grep '^rc' | awk '{print $2}' | xargs sudo dpkg --purge)
    else
        echo "no package configuration data to remove"
    fi
}

# purge thumbnail cache
function clear-thumbnails () {
    echo "current size of thumbnail cache:"
    du -sh ~/.cache/thumbnails/
    find ~/.cache/thumbnails -type f -exec rm -vf {} \;
    echo "size after purge:"
    du -sh ~/.cache/thumbnails/
}
