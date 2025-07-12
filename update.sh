#!/usr/bin/env bash
#
# Corey Goldberg (https://github.com/cgoldberg)
#
# update.sh - install or update local dotfiles and ~/bin scripts from github

set -e

DOTFILES_HOME="${HOME}/code/dotfiles"
BIN_DIR="${HOME}/bin"

die() { echo "$*" 1>&2 ; exit 1; }

if [ ! -x "$(command -v git)" ]; then
    die "fatal: can't find git"
fi

if [ ! -x "$(command -v curl)" ]; then
    die "fatal: can't find curl"
fi

if [ ! -d "${DOTFILES_HOME}" ]; then
    die "fatal: can't find dotfiles repo"
fi

echo "updating local dotfiles and ~/bin scripts from github ..."
echo

mkdir --parents "${BIN_DIR}"

cd "${DOTFILES_HOME}"

current_branch=$(git branch --show-current)
default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's/.*\///')

echo "syncing local branches in ${DOTFILES_HOME}"
git sync
git checkout "${default_branch}" >/dev/null 2>&1

echo "copying configs from dotfiles repo master branch to ${HOME}"
cp .bashrc "${HOME}"
cp .profile "${HOME}"
cp .gitconfig "${HOME}"

echo "copying scripts from dotfiles repo master branch to ${BIN_DIR}"
cp "${DOTFILES_HOME}/bin/colors" "${BIN_DIR}"
cp "${DOTFILES_HOME}/bin/git-statuses" "${BIN_DIR}"
cp "${DOTFILES_HOME}/bin/prettyping" "${BIN_DIR}"

if [[ "${OSTYPE}" == "linux"* ]]; then
    echo "copying linux configs from dotfiles repo master branch to ${HOME}"
    cp .bashrc_linux "${HOME}"
    cp .bashrc_linux_selenium "${HOME}"
    echo "copying linux scripts from dotfiles repo master branch to ${BIN_DIR}"
    cp "${DOTFILES_HOME}/bin/now" "${BIN_DIR}"
elif [[ "${OSTYPE}" == "msys" ]]; then
    echo "copying windows configs from dotfiles repo master branch to ${HOME}"
    cp .bashrc_windows "${HOME}"
    cp .gitconfig_win "${HOME}"
    cp .minttyrc "${HOME}"
fi

git checkout "${current_branch}" >/dev/null 2>&1

echo "downloading scripts from github to ${BIN_DIR}"
scripts=(
    "git-info"
    "git-score"
    "git-stat"
    "git-sync"
    "git-syncrepo"
    "git-track-branches"
)
for script in "${scripts[@]}"; do
    url="https://raw.githubusercontent.com/cgoldberg/git-scripts/refs/heads/main/${script}"
    curl -fsS --output "${BIN_DIR}/${script}" "${url}"
    chmod +x "${BIN_DIR}/${script}"
    if [[ "${OSTYPE}" == "msys" ]]; then
        unix2dos "${BIN_DIR}/${script}" >/dev/null 2>&1
    fi
done

echo
tput setaf 10; echo -en "\u2714 "; tput sgr0
echo "done"
