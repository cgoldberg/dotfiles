# cgoldberg
# alias definitions
# -----------------

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

alias h="history | grep"

# see: https://help.ubuntu.com/community/AptGet/Howto
alias apt-all="sudo apt-get update; sudo apt-get dist-upgrade; sudo apt-get -f install; sudo apt-get autoremove; sudo apt-get autoclean; sudo apt-get clean; sudo apt-get check"

alias apt-purge-old-configs="dpkg -l | grep '^rc' | awk '{print $2}' | sudo xargs dpkg --purge"
