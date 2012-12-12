source "`brew --prefix grc`/etc/grc.bashrc"

export TERM="xterm-256color"
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"
export PATH="$HOME/.bin:/usr/local/bin:$PATH"

eval "$(rbenv init -)"

export JRUBY_OPTS="--1.9"
