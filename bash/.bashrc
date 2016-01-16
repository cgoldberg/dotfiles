# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ****************************************************************

# add auto-completion support for git commands
# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
if [ -f ~/bin/git-completion.bash ]; then
    . ~/bin/git-completion.bash
    # aslias "g" for "git" and still have auto-completion
    __git_complete g _git
fi

# show current git branch name in prompt (must also call `__git_ps1` when setting PS1)
# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
if [ -f ~/bin/git-prompt.sh ]; then
    . ~/bin/git-prompt.sh
fi

# customize and color the prompt
PS1='\[$(tput bold)\]\[\033[38;5;10m\]\u\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]\h\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\]\[$(tput sgr0)\]\[\033[38;5;14m\][\w]\[$(tput sgr0)\]\[\033[38;5;15m\]\[$(tput sgr0)\]$(__git_ps1 "(%s)")\$ '

# add title to new terminal windows
#__git_ps1
PROMPT_COMMAND='echo -ne "\033]0; ${PWD}\007"'

# disable terminal suspend and resume feature
stty -ixon

# command history handling
# ------------------------
# append to the history file, don't overwrite it
shopt -s histappend
# save each line of a multi-line command in the same history entry
shopt -s cmdhist
# don't show duplicate commands in history
HISTCONTROL=ignoredups
# immediately add commands to history instead of waiting for end of session
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
# number of previous commands stored in history file
HISTSIZE=2000
# number of previous commands stored in memory for current session
HISTFILESIZE=2000
# don't store these commands in history
HISTIGNORE='ls:exit'

# include shell aliases and functions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# display ubuntu logo and system info
# https://raw.githubusercontent.com/cgoldberg/screenfetch-ubuntu/master/screenfetch-ubuntu.sh
if [ -f  ~/bin/screenfetch-ubuntu.sh ]; then
    bash ~/bin/screenfetch-ubuntu.sh
fi
