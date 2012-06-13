source ~/.bash/aliases
source ~/.bash/bash_prompt
source ~/.bash/git-completion.bash

if [ -r ~/.profile ]; then . ~/.profile; fi
case "$-" in *i*) if [ -r ~/.bashrc ]; then . ~/.bashrc; fi;; esac
