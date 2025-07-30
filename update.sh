#!/usr/bin/env bash
#
# Corey Goldberg (https://github.com/cgoldberg)
#
# update.sh - install or update local dotfiles and ~/bin scripts from github

set -e

DOTFILES_HOME="${HOME}/code/dotfiles"
BIN_DIR="${HOME}/bin"
CONFIGS=(
    ".bashrc"
    ".profile"
    ".gitconfig"
)
LINUX_CONFIGS=(
    ".bashrc_linux"
    ".bashrc_linux_selenium"
)
WIN_CONFIGS=(
    ".bashrc_windows"
    ".gitconfig_win"
    ".minttyrc"
)
SCRIPTS=(
    "./bin/colors"
    "./bin/prettyping"
)
LINUX_SCRIPTS=(
    "./bin/now"
    "./bin/sysinfo"
)
GIT_SCRIPTS=(
    "git-clean-untracked"
    "git-info"
    "git-obliterate-repo"
    "git-score"
    "git-stat"
    "git-sync"
    "git-syncrepo"
    "git-track-branches"
)

die() {
    tput setaf 1; echo -en "\u2717  "; tput sgr0
    tput bold; echo "$*" 1>&2; tput sgr0
    exit 1
}

if [ ! -d "${DOTFILES_HOME}" ]; then
    die "fatal: can't find dotfiles repo"
fi

if [ ! -x "$(command -v git)" ]; then
    die "fatal: can't find git"
fi

if [ ! -x "$(command -v curl)" ]; then
    die "fatal: can't find curl"
fi

echo "updating local dotfiles and ~/bin scripts from github ..."
echo

mkdir --parents "${BIN_DIR}"

cd "${DOTFILES_HOME}"

current_branch=$(git branch --show-current)
default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's/.*\///')

echo "syncing local branches in ${DOTFILES_HOME} ..."
git sync
echo
git checkout "${default_branch}" >/dev/null 2>&1

echo "copying configs from dotfiles repo master branch to ${HOME}"
for config in "${CONFIGS[@]}"; do
    cp "${config}" "${HOME}"
done
if [[ "${OSTYPE}" == "linux"* ]]; then
    echo "copying linux configs from dotfiles repo master branch to ${HOME}"
    for config in "${LINUX_CONFIGS[@]}"; do
        cp "${config}" "${HOME}"
    done
elif [[ "${OSTYPE}" == "msys" ]]; then
    echo "copying windows configs from dotfiles repo master branch to ${HOME}"
    for config in "${WIN_CONFIGS[@]}"; do
        cp "${config}" "${HOME}"
    done
fi

echo "copying scripts from dotfiles repo master branch to ${BIN_DIR}"
for script in "${SCRIPTS[@]}"; do
    cp "${script}" "${BIN_DIR}"
done
if [[ "${OSTYPE}" == "linux"* ]]; then
    echo "copying linux scripts from dotfiles repo master branch to ${BIN_DIR}"
    for script in "${SCRIPTS[@]}"; do
        cp "${script}" "${BIN_DIR}"
    done
fi

git checkout "${current_branch}" >/dev/null 2>&1

echo "downloading git scripts from github to ${BIN_DIR}"
for script in "${GIT_SCRIPTS[@]}"; do
    url="https://raw.githubusercontent.com/cgoldberg/git-scripts/refs/heads/main/${script}"
    curl -fsS --output "${BIN_DIR}/${script}" "${url}"
    chmod +x "${BIN_DIR}/${script}"
    if [[ "${OSTYPE}" == "msys" ]]; then
        unix2dos "${BIN_DIR}/${script}" >/dev/null 2>&1
    fi
done

echo
tput setaf 10; echo -en "\u2714  "; tput sgr0
echo "done updating configs and scripts"
