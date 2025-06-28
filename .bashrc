# ~/.bashrc
# =========================
#  bash shell configuration
# =========================
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
    *i*);;
      *) return;;
esac


# set PATH so it includes private bins if they exist
if [ -d "${HOME}/bin" ]; then
    export PATH="${PATH}:${HOME}/bin"
fi
if [ -d "${HOME}/.local/bin" ]; then
    export PATH="${PATH}:${HOME}/.local/bin"
fi


# enable programmable completion features
# if not available, download it and put it in ~/etc
# https://salsa.debian.org/debian/bash-completion/-/raw/master/bash_completion
load-bash-completions () {
    local completion_paths=(
        "/usr/share/bash-completion/bash_completion"
        "/etc/bash_completion"
        "${HOME}/etc/bash_completion"
    )
    local completion_loader_funcs=(
        "_completion_loader"
        "_comp_complete_load"
    )
    for completion_path in ${completion_paths[@]}; do
        if [ -f "${completion_path}" ]; then
            source "${completion_path}"
        fi
    done
    for completion_loader_func in ${completion_loader_funcs[@]}; do
        if declare -f "${completion_loader_func}" >/dev/null; then
            "${completion_loader_func}" git
            complete -o bashdefault -o default -o nospace -F __git_wrap__git_main git
        fi
    done
}
load-bash-completions


# export environment variables
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export PAGER="less"
export EDITOR="vi"
if [ -x "$(command -v subl)" ]; then
    export VISUAL="subl --new-window --wait"
else
    export VISUAL="vi"
fi


# set global variables
GITHUB_USERNAME="cgoldberg"


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


# version control
alias g="git"
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g


# disk usage (directory sizes)
alias du="\du --human-readable --time --max-depth=1"


# extract a tarball
alias untar="tar zxvf"


# count all files in current directory (recursive)
alias countfiles=" find . -type f ! -path './.git/*' | wc -l"


# clear screen and scrollback buffer
alias cls="clear"
alias c="clear"


# python
alias py="python"


# create a python virtual environment and activate it if none exists, otherwise just activate it
alias venv="[ ! -d venv/ ] && python3 -m venv --upgrade-deps venv && activate || activate"


# deactivate a python virtual environment
alias deact="deactivate"


# show the zen of python
alias zen="python3 -c 'import this'"


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
    tput civis
    exec {doSpinner}> >(spinner "$@")
}


# stop spinner background task
stop_spinner () {
    echo >&"${doSpinner}" && exec {doSpinner}>&-
    tput cnorm
    echo
}


# colored diffs
dff () {
    if [ -z "$1" ] || [ -z "$2" ]; then
        err "please enter 2 files to diff"
        return 1
    fi
    \diff --color=always --report-identical-files "$1" "$2" | less
}
alias diff="dff"


# rename all files under the current directory to replace spaces with underscores (recursive)
# if inside a git repo, file renames will be tracked by git
remove-whitespace-from-filenames () {
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        find . -path ./.git -prune -o -type f -name "* *" -exec bash -c 'git mv "$0" "${0// /_}"' {} \;
    else
        find . -type f -name "* *" -exec bash -c 'mv "$0" "${0// /_}"' {} \;
    fi
}


# search recursively for files or directories matching pattern (case-insensitive unless pattern contains an uppercase)
# - https://github.com/sharkdp/fd (install .deb from releases)
# usage: findfiles <regex>
findit () {
    if [ ! -x "$(command -v fd)" ]; then
        err "fd not found"
        return 1
    fi
    local command_name="\fd --hidden --no-ignore "
    local exclude_patterns=(
        ".git/"
        ".tox/"
        ".venv/"
        "__pycache__/"
        "venv/"
    )
    for pattern in ${exclude_patterns[@]}; do
        command_name+=" --exclude=${pattern}"
    done
    if [ ! -z "$1" ]; then
        command_name+=" $1"
    fi
    eval "${command_name}"
}
alias ff="findit"


# search recursively in files for pattern (case-insensitive)
# use ripgrep if available
# usage: rg <pattern>
rg () {
    if [ -z "$1" ]; then
        err "please specify a search pattern"
        return 1
    fi
    if [ -f /usr/bin/rg ]; then # ripgrep
        eval /usr/bin/rg \
            --hidden \
            --ignore-case \
            --line-number \
            --no-heading \
            --no-ignore \
            --no-messages \
            --one-file-system \
            --with-filename \
            --color=always \
            --glob='!.git/' \
            --glob='!.tox/' \
            --glob='!.venv/' \
            --glob='!__pycache__/' \
            --glob='!venv/' \
            $1 \
            | less
    else
        \grep -r \
            --ignore-case \
            --line-number \
            --no-messages \
            --with-filename \
            --binary-files=without-match \
            --color=always \
            --devices=skip \
            --exclude-dir=.git \
            --exclude-dir=.tox \
            --exclude-dir=.venv \
            --exclude-dir=__pycache__ \
            --exclude-dir="venv" \
            "$1" \
            | less
    fi
}


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
        activate
    fi
}


# search active processes for pattern (case-insensitive)
# usage: psgrep <pattern>
psgrep () {
    if [ ! -z "$1" ]; then
        ps -ef \
            | \grep --color=always --extended-regexp --ignore-case "$1" \
            | nowrap
    else
        ps -ef
    fi
}


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
            --disable FURB173 \
            --disable FURB183 \
            --disable FURB184
}


# clean pip, pipx cache
clean-pip () {
    echo "cleaning pip and pipx cache ..."
    pip cache purge
    local dirs=(
        "${HOME}/.cache/pip-tools/"
        "${HOME}/.local/pipx/.cache/"
        "${HOME}/pipx/.cache/"
    )
    for d in ${dirs[@]}; do
        if [ -d "${d}" ]; then
            echo "deleting ${d}"
            rm -rf "${d}"
        fi
    done
}


# clean python dev/temp files from current directory and subdirectories
clean-py () {
    echo "cleaning python dev/temp files ..."
    local dirs=(
        ".tox/"
        ".venv/"
        ".mypy_cache/"
        ".pytest_cache/"
        ".ruff_cache/"
        "*.egg-info/"
        "build/"
        "dist/"
        "venv/"
    )
    local recurse_dirs=(
        "__pycache__/"
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
    for rd in ${recurse_dirs[@]}; do
        echo "recursively deleting ${rd}"
        rm -rf ./**/${rd}/
    done
}


# install python application in isoloated environment with current python interpreter
# usage: pipx-install <package>
pipx-install () {
    if [ -z "$1" ]; then
        err "please specify a package"
        return 1
    fi
    if [ ! -x "$(command -v pipx)" ]; then
        err "pipx not installed"
        return 1
    fi
    pipx uninstall "$1" >/dev/null
    if [ -d "${HOME}/.pyenv" ]; then
        rm -rf "${HOME}/.pyenv/shims/${1}"
        pipx install "${1}" --python $(pyenv which python)
    else
        pipx install "${1}"
    fi
}


# upgrade all pipx applications
# reinstall them if they don't match the current python interpreter version
pipx-upgrade-all () {
    if [ ! -x "$(command -v pipx)" ]; then
        err "pipx not installed"
        return 1
    fi
    if [ ! -z "${VIRTUAL_ENV}" ]; then
        echo "deactivating venv"
        deactivate
    fi
    local py_version=$(python3 --version)
    local output=$(pipx list)
    if [[ "${output}" == *"${py_version}"* ]]; then
        pipx upgrade-all
    else
        echo "package versions don't match python version. reinstalling packages ..."
        echo
        if [ -d "${HOME}/.pyenv" ]; then
            pipx reinstall-all --python $(pyenv which python)
        else
            pipx reinstall-all
        fi
    fi
    echo
    pipx list
}


# preview markdown with github cli
# requires github cli and gh-markdown-preview extension
#   - folow installation instructions at: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
#   - run: gh extension install yusukebe/gh-markdown-preview
preview-md () {
    if [ ! -x "$(command -v gh)" ]; then
        echo "github cli is not installed"
        return 1
    fi
    gh markdown-preview --light-mode "$1"
}


# load additional bash configurations if they exist
load-bash-configs () {
    local config_files=(
        "${HOME}/.bashrc_linux"
        "${HOME}/.bashrc_linux_selenium"
        "${HOME}/.bashrc_windows"
    )
    for config_file in ${config_files[@]}; do
        if [ -f "${config_file}" ]; then
            source "${config_file}"
        fi
    done
}
load-bash-configs
