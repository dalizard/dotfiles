source ~/.bash/aliases
source ~/.bash/colors
source ~/.bash/prompt

source ~/.bin/git-completion.bash

if [ -r ~/.profile ]; then . ~/.profile; fi
case "$-" in *i*) if [ -r ~/.bashrc ]; then . ~/.bashrc; fi;; esac
