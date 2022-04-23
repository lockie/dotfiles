#!/usr/bin/env sh

if [ -f ~/.bash_aliases ]; then
 . ~/.bash_aliases
fi
alias | awk -F'[ =]' '{print $1}'
