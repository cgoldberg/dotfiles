# ~/.bashrc
# - bash shell configuration
#
# ============================================================================
#
#    bbbbbbbb
#    b::::::b                                             hhhhhhh
#    b::::::b                                             h:::::h
#    b::::::b                                             h:::::h
#     b:::::b                                             h:::::h
#     b:::::bbbbbbbbb      aaaaaaaaaaaaa      ssssssssss   h::::h hhhhh
#     b::::::::::::::bb    a::::::::::::a   ss::::::::::s  h::::hh:::::hhh
#     b::::::::::::::::b   aaaaaaaaa:::::ass:::::::::::::s h::::::::::::::hh
#     b:::::bbbbb:::::::b           a::::as::::::ssss:::::sh:::::::hhh::::::h
#     b:::::b    b::::::b    aaaaaaa:::::a s:::::s  ssssss h::::::h   h::::::h
#     b:::::b     b:::::b  aa::::::::::::a   s::::::s      h:::::h     h:::::h
#     b:::::b     b:::::b a::::aaaa::::::a      s::::::s   h:::::h     h:::::h
#     b:::::b     b:::::ba::::a    a:::::assssss   s:::::s h:::::h     h:::::h
#     b:::::bbbbbb::::::ba::::a    a:::::as:::::ssss::::::sh:::::h     h:::::h
#     b::::::::::::::::b a:::::aaaa::::::as::::::::::::::s h:::::h     h:::::h
#     b:::::::::::::::b   a::::::::::aa:::as:::::::::::ss  h:::::h     h:::::h
#     bbbbbbbbbbbbbbbb     aaaaaaaaaa  aaaa sssssssssss    hhhhhhh     hhhhhhh
#
# ============================================================================


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# set PATH so it includes private bins if they exist
if [ -d "${HOME}/bin" ] ; then
    export PATH="${PATH}:${HOME}/bin"
fi
if [ -d "${HOME}/.local/bin" ] ; then
    export PATH="${PATH}:${HOME}/.local/bin"
fi


# export environment variables
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export PAGER="less"
export EDITOR="vi"
export VISUAL="vi"
if [ -f /usr/bin/subl ]; then
    export VISUAL="subl --new-window --wait"
fi


# don't leave .lesshst files in home directory
export LESSHISTFILE=-


# set termcap colors (used by less pager)
export LESS_TERMCAP_mb=$(printf '\e[01;31m')
export LESS_TERMCAP_md=$(printf '\e[01;38;5;75m')
export LESS_TERMCAP_me=$(printf '\e[0m')
export LESS_TERMCAP_se=$(printf '\e[0m')
export LESS_TERMCAP_so=$(printf '\e[01;33m')
export LESS_TERMCAP_ue=$(printf '\e[0m')
export LESS_TERMCAP_us=$(printf '\e[04;38;5;200m')


# enable programmable completion features (you don't need to enable this, if it's
# already enabled in /etc/bash.bashrc and /etc/profile sources /etc/bash.bashrc)
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    fi
fi


# check window size after each command and update the values of LINES and COLUMNS
shopt -s checkwinsize


# the pattern "**" used in a pathname expansion context will match
# all files and zero or more directories and subdirectories.
shopt -s globstar


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
HISTIGNORE="x:exit" # we get duplicates of 'x' and 'exit' because shell is closed immediately
# number of previous commands stored in memory for current session
HISTSIZE=999
# number of previous commands stored in history file
HISTFILESIZE=999
# immediately add commands to history instead of waiting for end of session
PROMPT_COMMAND="history -n; history -w; history -c; history -r; ${PROMPT_COMMAND}"


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


# enable color support for grep
alias grep="\grep --color=always"


# pagers
alias less="\less --LONG-PROMPT --no-init --quit-at-eof --quit-if-one-screen --quit-on-intr --RAW-CONTROL-CHARS"
alias more="less"


# show how a command would be interpreted (includes: aliases, builtins, functions, scripts/executables on path)
alias which="type"


# version control
alias g="git"


# exit shell
alias x="exit"


# extract a tarball
alias untar="tar zxvf"


# count all files in current directory (recursive)
alias countfiles="find . -type f | wc -l"


# clear screen and scrollback buffer
alias cls="clear"
alias c="clear"


# python
alias py="python"


# show the zen of python
alias zen="python -c 'import this'"


# uninstall all python packages in current environment
alias pip-uninstall-all="pip freeze | xargs pip uninstall -y"


# serve current directory over HTTP on port 8000 (bind all interfaces)
alias webserver="python3 -m http.server"


# list directory contents
alias ls="LC_COLLATE=C \ls --almost-all --classify --group-directories-first --color=always"
alias ll="LC_COLLATE=C \ls -l --almost-all --classify --group-directories-first --human-readable --no-group --color=always"
alias l="ll"


# editors (sublime/vim)
if [ -x "$(command -v subl)" ]; then
    alias edit="subl"
    alias ed="subl"
    alias e="subl --new-window ."
else
    alias edit="vi"
    alias ed="vi"
    alias e="vi ."
fi


# open ~/.bashrc for editing
alias ebrc="edit ${HOME}/.bashrc"


# --------------------------------- FUNCTIONS ---------------------------------


# print messages to stderr along with date/time
err() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S%z')]: $*" 1>&2
}


# chop lines at screen width
# usage example: echo $really_long_line | nowrap
nowrap () {
    cut -c-$(tput cols)
}


# show spinner for indicating progress
spinner() {
    local shs=( - \\ \| / ) pnt=0
    printf '\e7'
    while ! read -rsn1 -t .2 _; do
        printf '%b\e8' "${shs[pnt++%${#shs[@]}]}"
    done
}


# start spinner background task
start_spinner () {
    tput civis;
    exec {doSpinner}> >(spinner "$@")
}


# stop spinner background task
stop_spinner () {
    echo >&"${doSpinner}" && exec {doSpinner}>&-;
    tput cnorm;
    echo
}


# colored diffs
dff () {
    if [ -z "$1" ]  || [ -z "$2" ]; then
        err "please enter 2 files to diff"
        return 1
    fi
    \diff --color=always --report-identical-files "$1" "$2" | less
}
alias diff="dff"


# grep recursively for pattern (case-insensitive)
# usage: rg <pattern>
rg () {
    if [ -z "$1" ]; then
        err "please enter a search pattern"
        return 1
    fi
    \grep -r \
    --binary-files=without-match \
    --color=always \
    --devices=skip \
    --ignore-case \
    --line-number \
    --no-messages \
    --with-filename \
    --exclude-dir=.git \
    --exclude-dir=.tox \
    --exclude-dir=.pytest_cache \
    --exclude-dir=__pycache__ \
    --exclude-dir=.venv \
    --exclude-dir=venv \
    "$1" | less
}
alias rgrep="rg"


# search command history by regex (case-insensitive) show last n matches
# usage: h <pattern>
h () {
    local num="60"
    history -n; history -w; history -c; history -r;
    history | \grep -v "  h " | \grep --ignore-case --color=always "$1" | tail -n "${num}"
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
    unalias -a # remove all aliases
    source "${HOME}/.bashrc"
    # if a virtual env is active, reactivate it, since the prompt prefix gets clobbered
    if [ ! -z "${VIRTUAL_ENV}" ]; then
        source "${VIRTUAL_ENV}/bin/activate"
    fi
}


# clean pip, pipx, poetry cache
clean-pip () {
    echo "cleaning pip and pipx cache ..."
    local dirs=(
        "${HOME}/.cache/pip/"
        "${HOME}/.cache/pip-tools/"
        "${HOME}/.local/pipx/.cache/"
    )
    for d in ${dirs[@]}; do
        if [ -d "${d}" ]; then
            echo "deleting ${d}"
            rm -rf "${d}"
        fi
    done
}


# clean python dev/temp files from local directory (recurse subdirectories)
clean-py () {
    echo "cleaning python dev/temp files ..."
    local dirs=(
        "build/"
        "dist/"
    )
    local recurse_dirs=(
        "*.egg-info/"
        ".mypy_cache/"
        ".pytest_cache/"
        ".ruff_cache/"
        ".tox/"
        ".venv/"
        "__pycache__/"
        "venv/"
    )
    if [ ! -z "${VIRTUAL_ENV}" ]; then
        echo "deactivating venv"
        deactivate
    fi
    for d in ${dirs[@]}; do
        if [ -d "${d}" ]; then
            echo "deleting ${d}"
            rm -rf "${d}"
        fi
    done
    for d in ${recurse_dirs[@]}; do
        echo "recursively deleting ${d}"
        rm -rf ./**/${d}/
    done
}


# search active processes for pattern (case-insensitive)
# usage: psgrep <pattern>
psgrep () {
    if [ ! -z "$1" ]; then
        ps -ef | \grep -v "grep" \
            | \grep --color=always --extended-regexp --ignore-case "$1" \
            | nowrap
    else
        ps -ef
    fi
}


# search recursively under the current directory for filenames matching pattern (case-insensitive)
# - skips unreadable files/directories
# usage: findfiles <pattern>
findfiles () {
    if [ -z "$1" ]; then
        err "usage: findfiles <pattern>"
        return 1
    fi
    find \
        -xdev \
        ! -readable -prune \
        -o \
        -iname "*$1*" \
        ! -path "*/.git/*" \
        ! -path "*/.tox/*" \
        ! -path "*/.pytest_cache/*" \
        ! -path "*/__pycache__/*" \
        ! -path "*/venv/*" \
        -print \
        | \grep --ignore-case --color=always "$1"
}
alias ff="findfiles"


# run pyupgrade against all python files in current directory (recursive), and fix recommendations in-place
py-upgrade () {
    if [ ! -x "$(command -v pyupgrade)" ]; then
        err "pyupgrade not found"
        return 1
    fi
    find \
        -name "*.py" \
        ! -path "*/.git/*" \
        ! -path "*/.tox/*" \
        ! -path "*/.pytest_cache/*" \
        ! -path "*/__pycache__/*" \
        ! -path "*/selenium/webdriver/common/devtools/*" \
        ! -path "*/venv/*" \
        -print \
        | xargs pyupgrade --py39-plus
}


# run refurb against all python files in current directory (recursive), and display recommendations
py-refurb () {
    if [ ! -x "$(command -v refurb)" ]; then
        err "refurb not found"
        return 1
    fi
    find \
        -name "*.py" \
        ! -path "*/.git/*" \
        ! -path "*/.tox/*" \
        ! -path "*/.pytest_cache/*" \
        ! -path "*/__pycache__/*" \
        ! -path "*/selenium/webdriver/common/devtools/*" \
        ! -path "*/venv/*" \
        -print \
        | xargs refurb \
            --python-version 3.9 \
            --disable FURB101 \
            --disable FURB103 \
            --disable FURB104 \
            --disable FURB107 \
            --disable FURB141 \
            --disable FURB144 \
            --disable FURB146 \
            --disable FURB150 \
            --disable FURB183 \
            --disable FURB184
}


# count tests found under current directory by running pytest discovery
# usage: count-tests <path> (no arg counts everything under current directory)
counttests () {
    if [ -x "$(command -v pytest)" ]; then
        echo "running test discovery ..."
        local num_tests=$(pytest --collect-only -q "$1" | head -n -2 | wc -l)
        echo "tests found: ${num_tests}"
    else
        echo "pytest not found"
    fi
}


# -----------------------------------------------------------------------------


# load additional bash configurations if they exist
load-bash-configs () {
    local config_files=(
        "${HOME}/.bashrc_linux"
        "${HOME}/.bashrc_win"
        "${HOME}/.bashrc_selenium"
    )
    for config_file in ${config_files[@]}; do
        if [ -f "${config_file}" ]; then
            source "${config_file}"
        fi
    done
}
load-bash-configs
