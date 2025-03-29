# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)for examples.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# export some environment variables
export PAGER="less"
export VISUAL="vi"
export EDITOR="vi"

# export environment variables for termcap colors
# used by `less` pager for colors
export LESS_TERMCAP_mb=$(printf '\e[01;31m')
export LESS_TERMCAP_md=$(printf '\e[01;38;5;75m')
export LESS_TERMCAP_me=$(printf '\e[0m')
export LESS_TERMCAP_se=$(printf '\e[0m')
export LESS_TERMCAP_so=$(printf '\e[01;33m')
export LESS_TERMCAP_ue=$(printf '\e[0m')
export LESS_TERMCAP_us=$(printf '\e[04;38;5;200m')

# better command history handling
# -------------------------------
# append to history file, don't overwrite it
shopt -s histappend
# edit recalled history line before executing
shopt -s histverify
# save each line of a multi-line command in the same history entry
shopt -s cmdhist
# remove duplicate commands from history
HISTCONTROL=ignoredups:erasedups
# don't add entries to history
HISTIGNORE="x:exit" # we get duplicates of `x` and `exit` because shell is closed immediately
# number of previous commands stored in history file
HISTSIZE=9999
# number of previous commands stored in memory for current session
HISTFILESIZE=9999
# show timestamp [Weekday Month/Day Hour:Min] for each command in history
#HISTTIMEFORMAT="[%a %m/%d %H:%M]  "
# immediately add commands to history instead of waiting for end of session
PROMPT_COMMAND="history -n; history -w; history -c; history -r; ${PROMPT_COMMAND}"

# check the window size after each command and update the values of LINES and COLUMNS
shopt -s checkwinsize

# the pattern "**" used in a pathname expansion context will match
# all files and zero or more directories and subdirectories.
shopt -s globstar

# make `less` more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# add colored user@host:dir and git branch to prompt
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\033[0;34m$(__git_ps1 " (%s) ")\033[0m\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# set the title to user@host
PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h\]$PS1"

# enable color support for `grep`
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias grep="\grep --color=auto"
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# navigate up the directory tree
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ........="cd ../../../../../../.."
alias cd..="cd .."
alias cd...="cd ../.."
alias cd....="cd ../../.."
alias cd.....="cd ../../../.."
alias cd......="cd ../../../../.."
alias cd.......="cd ../../../../../.."
alias cd........="cd ../../../../../../.."

# expand aliases when running sudo
alias sudo="sudo "

# expand aliases when running watch
alias watch="watch "

# go back to previous directory
alias bk="cd ${OLDPWD}"

# show TCP and UDP sockets that are actively listening
alias listening="sudo netstat --listening --program --symbolic --tcp --udp"

# default browser
alias web="sensible-browser"

# version control
alias g="git"
if [ -x "$(command -v gh)" ]; then
    alias preview="gh markdown-preview --light-mode"
fi

# sublime editor
if [ -f  "/usr/bin/subl" ]; then
    alias subl="\subl --new-window"
    alias edit="subl"
    alias ed="subl"
fi

# pagers
alias less="\less --LONG-PROMPT --no-init --quit-at-eof --quit-if-one-screen --quit-on-intr --RAW-CONTROL-CHARS"
alias more="less"

# extract a tarball
alias untar="tar zxvf"

# disk space
alias df="\df --human-readable --sync"
alias ds="\df --human-readable --sync | \grep --extended-regexp '(/dev/kvm)|(Filesystem)'"
alias diskspace="ds"

# exit shell
alias x="exit"

# open ~/.bashrc for editing with sublime
if [ -f  "/usr/bin/subl" ]; then
    alias ebrc="subl ${HOME}/.bashrc"
else
    alias ebrc="vi ${HOME}/.bashrc"
fi

# clear screen and scrollback buffer
alias cls="clear"
alias c="clear"

# list dirs/files in tree format
alias tree="tree -ash -CF --du"

# python
alias python="python3"
alias py="python3"
alias activate="source ./venv/bin/activate"
alias act="activate"
alias deact="deactivate"

# python - create a virtual env and activate it if none exists, otherwise just activate it
alias venv="[ ! -d './venv' ] && python3 -m venv --upgrade-deps venv && activate || activate"

# list directory contents
alias ls="LC_COLLATE=C \ls --almost-all --classify --group-directories-first --color=always"
alias ll="LC_COLLATE=C \ls -l --almost-all --classify --group-directories-first --human-readable --no-group --color=always"
alias l="ll"

# colored diffs
if [ -x /usr/bin/dircolors ]; then
    alias diff="colordiff --report-identical-files"
fi

# sync branch in forked git repo with upstream and push to origin
# to run this, you must first add the upstream repo:
#     git remote add upstream git@github.com:<username>/<repo>.git
# usage: sync-repo <branch>
sync-repo() {
    if [ -z "$1" ]; then
        echo "usage: sync-repo <branch>"
        return 1
    fi
    if [ ! -d ".git" ]; then
        echo "not in a top-level directory of a git repo"
        return 1
    fi
    git checkout "$1"
    if [ $? -ne 0 ]; then
        return 1
    fi
    git fetch upstream
    if [ $? -ne 0 ]; then
        echo && echo "upstream not set"
        return 1
    else
        git pull upstream "$1"
        if [ $? -ne 0 ]; then
            return 1
        else
            git push origin "$1"
        fi
    fi
}

# grep recursively for pattern (case-insensitive)
# usage: rg <pattern>
rg () {
    if [ -z "$1" ]; then
        echo "please enter a search pattern"
        return 1
    fi
    \rgrep \
    --binary-files=without-match \
    --color=auto \
    --devices=skip \
    --ignore-case \
    --line-number \
    --no-messages \
    --with-filename \
    --exclude-dir=.git \
    --exclude-dir=.tox \
    --exclude-dir=venv \
    --exclude=*.css \
    --exclude=*.js \
    --exclude=*.svg \
    "$1"
}
alias rgrep="rg"

# kill Jekyll server running blog
killblog () {
    local blog_dir="${HOME}/code/cgoldberg.github.io"
    local jekyll_proc="jekyll s"
    local jekyll_server="127.0.0.1:4000"
    if [ -d "${blog_dir}" ]; then
        if [[ $(psgrep "${jekyll_proc}") ]]; then
            echo "killing server at: ${jekyll_server}"
            pkill -9 -f "${jekyll_proc}" && pidwait -f "${jekyll_proc}"
            psgrep "${jekyll_proc}"
        fi
    else
        echo "${blog_dir} not found. no server running"
    fi
}

# run Jekyll server for blog and open local url in browser
blog () {
    local blog_dir="${HOME}/code/cgoldberg.github.io"
    local jekyll_server="127.0.0.1:4000"
    if [ -d "${blog_dir}" ]; then
        killblog
        echo "running server at: ${jekyll_server}"
        cd "${blog_dir}"
        bundle exec jekyll s >/dev/null & disown # silence stdout
        sleep 3.5
        echo "opening browser at: http://${jekyll_server}"
        xdg-open "http://${jekyll_server}"
    else
        echo "${blog_dir} not found"
    fi
}

# search command history by regex (case-insensitive) show last n matches
# usage: h <pattern>
h () {
    local num="150"
    history | \grep --ignore-case --color=always "$1" | tail -n "${num}"
}

# create directory (make parent directories as needed)
makedir () {
    mkdir --parents --verbose "$1"
    cd "$1"
}
alias md="makedir"

# reload shell configuration
re-source () {
    echo 'sourcing ~/.bashrc ...'
    source "${HOME}/.bashrc"
    # if a virtual env is active, reactivate it, since the prompt prefix gets clobbered
    if [ ! -z "${VIRTUAL_ENV}" ]; then
        source "${VIRTUAL_ENV}/bin/activate"
    fi
}

# clean pip and pipx cache
clean-pip () {
    echo "cleaning pip and pipx cache ..."
    local dirs=(
        "${HOME}/.cache/pip/"
        "${HOME}/.cache/pip-tools/"
        "${HOME}/.local/pipx/.cache/"
    )
    for d in ${dirs[@]}; do
        if [ -d  "${d}" ]; then
            echo "deleting ${d}"
            rm -rf ${d}
        fi
    done
}

# clean Python dev/temp files from local directory
clean-py () {
    echo "cleaning Python dev/temp files ..."
    local dirs=(
        ".mypy_cache/"
        ".pytest_cache/"
        ".tox/"
        "*.egg-info/"
        "build/"
        "dist/"
        "venv/"
    )
    if [ ! -z "${VIRTUAL_ENV}" ]; then
        echo "deactivating venv"
        deactivate
    fi
    echo "recursively deleting __pycache__/ directories"
    rm -rf ./**/__pycache__/
    for d in ${dirs[@]}; do
        if [ -d  "${d}" ]; then
            echo "deleting ${d}"
            rm -rf ${d}
        fi
    done
}

# clean selenium dev environment
clean-selenium-dev () {
    local sel_home="${HOME}/code/selenium"
    local dirs=(
        "${sel_home}/py/build/"
        "${sel_home}/py/selenium.egg-info/"
    )
    if [ -d  "${sel_home}" ]; then
        echo "cleaning up selenium dev environment ..."
        if [ ! -z "${VIRTUAL_ENV}" ]; then
            echo "deactivating venv ..."
            deactivate
        fi
        echo "recursively deleting __pycache__/ directories"
        rm -rf ${sel_home}/py/**/__pycache__/
        echo "recursively deleting .pytest_cache/ directories"
        rm -rf ${sel_home}/**/.pytest_cache/
        echo "recursively deleting .tox/ directories"
        rm -rf ${sel_home}/**/.tox/
        echo "recursively deleting venv/ directories"
        rm -rf ${sel_home}/**/venv/
        for d in ${dirs[@]}; do
            if [ -d  "${d}" ]; then
                echo "deleting ${d}"
                rm -rf ${d}
            fi
        done
    else
        echo "can't find ${sel_home}!"
    fi
}

# clean selenium dev environment, cache, browsers, webdrivers, build artifacts
clean-selenium-dev-full () {
    clean-selenium-dev
    local sel_home="${HOME}/code/selenium"
    local symlinks=(
        "${sel_home}/bazel-bin"
        "${sel_home}/bazel-genfiles"
        "${sel_home}/bazel-out"
        "${sel_home}/bazel-selenium"
        "${sel_home}/bazel-testlogs"
    )
    local dot_dirs=(
        "${HOME}/.cache/bazel/"
        "${HOME}/.cache/bazelisk/"
        "${HOME}/.cache/google-chrome-for-testing/"
        "${HOME}/.cache/Microsoft/"
        "${HOME}/.cache/mozilla/"
        "${HOME}/.cache/pnpm/"
        "${HOME}/.cache/selenium/"
        "${HOME}/.mozilla/"
    )
    local sel_dirs=(
        "${sel_home}/build/"
        "${sel_home}/dist/"
        "${sel_home}/java/build/"
        "${sel_home}/py/selenium/webdriver/common/devtools/"
        "${sel_home}/py/selenium/webdriver/common/linux/"
        "${sel_home}/py/selenium/webdriver/common/macos/"
        "${sel_home}/py/selenium/webdriver/common/windows/"
    )
    echo "cleaning up selenium cache, browsers, webdrivers, build artifacts ..."
    if [ -d  "${sel_home}" ]; then
        for s in ${symlinks[@]}; do
            if [ -L  "${s}" ]; then
                echo "deleting ${s}"
                rm -rf ${s}
            fi
        done
    fi
    for d in ${dot_dirs[@]}; do
        if [ -d  "${d}" ]; then
            echo "deleting ${d}"
            sudo rm -rf ${d}
        fi
    done
    if [ -d  "${sel_home}" ]; then
        for d in ${sel_dirs[@]}; do
            if [ -d  "${d}" ]; then
                echo "deleting ${d}"
                rm -rf ${d}
            fi
        done
    fi
}

# chop lines at screen width
nowrap () {
    cut -c-$(tput cols)
}

# search active processes for pattern (case-insensitive)
# usage: psgrep <pattern>
psgrep () {
    if [ ! -z "$1" ]; then
        ps -ef | \grep --extended-regexp --ignore-case "$1" | \grep -v "grep" | \
        sort -n -r | less | nowrap
    else
        ps -ef
    fi
}

# search recursively under the current directory for filenames matching pattern (case-insensitive)
# usage: findfiles <pattern>
findfiles () {
    if [ -z "$1" ]; then
        echo "usage: findfiles <pattern>"
        return 1
    fi
    find . -xdev \
           -iname "*$1*" \
           ! -path "*/.git/*" \
           ! -path "*/.tox/*" \
           ! -path "*/venv/*" |
           \grep --ignore-case --color=always "$1"
}
alias ff="findfiles"

# package maintenance
apt-up () {
    # reload package index files from sources
    sudo apt --no-allow-insecure-repositories update && echo &&
    # upgrade installed packages
    sudo apt full-upgrade && echo &&
    # check for broken dependencies
    sudo apt-get check && echo &&
    # fix broken dependencies
    sudo apt --fix-broken install && echo &&
    # fix missing dependencies
    sudo apt --fix-missing install && echo &&
    # purge packages that are no longer needed
    sudo apt --purge autoremove && echo &&
    # remove cached packages
    sudo apt clean && echo &&
    # purge orphaned configs from removed packages
    purge-apt-configs && echo &&
    # reload package index files from sources
    sudo apt --no-allow-insecure-repositories update && echo
}

# purge configuration data from packages marked as removed
purge-apt-configs () {
    if dpkg -l | grep --quiet '^rc'; then
        echo "$(dpkg -l | grep '^rc' | wc -l) packages have orphaned configs"
        echo "purging package configs from removed packages..."
        dpkg -l | grep '^rc' | awk '{print $2}' | xargs sudo dpkg --purge
    fi
}

# count tests found under current directory by running pytest discovery
# usage: count-tests <path> (no arg counts everything under current directory)
count-tests () {
    if [ -x "$(command -v pytest)" ]; then
        echo "running test discovery ..."
        local num_tests=$(pytest --collect-only -q $1 | head -n -2 | wc -l)
        echo "tests found: ${num_tests}"
    else
        echo "pytest not found"
    fi
}

# enable programmable completion features (you don't need to enable this, if it's
# already enabled in /etc/bash.bashrc and /etc/profile sources /etc/bash.bashrc)
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

# pipx
eval "$(register-python-argcomplete pipx)"
