# cgoldberg
# bash alias definitions and functions
# ------------------------------------

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="\ls -AFGl --color=auto"
    alias l="\ls -F --color=auto"
    alias lsl="\ls -AFGl --color=always | more"
    alias grep="grep --color=auto"
fi

alias cls="clear"
alias clear_dropbox_cache="rm -rf ~/Dropbox/.dropbox.cache/*"
alias count_files_recursively="find . -type f | wc -l"
alias strip_jpgs="exiv2 -d a *.jpg"

# search history
alias h="history | grep "

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
    sudo apt-get autoremove --show-progress
    # remove all packages from the package cache
    sudo apt-get clean
}

# purge all configuration data from removed packages
function apt-purge-configs () {
    dpkg -l | grep '^rc' | awk '{print $2}' | xargs sudo dpkg --purge
}

function scoreboard () {
    git log | grep Author | sort | uniq -ci | sort -hr
}
