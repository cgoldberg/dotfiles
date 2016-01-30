#!/usr/bin/env bash


for FILE in .bashrc .bash_aliases .gitconfig
do
    if [ -f ~/$FILE ]
    then
        cp ~/$FILE ~/$FILE.old
        cp ~/code/dotfiles/$FILE ~/$FILE
    fi
done
