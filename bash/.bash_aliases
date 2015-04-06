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

alias clear_dropbox_cache="rm -rf ~/Dropbox/.dropbox.cache/*"
alias cls="clear"
alias count_files_recursively="find . -type f | wc -l"
alias strip_jpgs="exiv2 -d a *.jpg"
alias h="history | grep"
alias apt-all="sudo apt-get update; sudo apt-get dist-upgrade; sudo apt-get autoremove; sudo apt-get autoclean; sudo apt-get clean"
