# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash if ~/.bash_profile or ~/.bash_login
# exists.


# include .bashrc if running bash and it exists
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi
