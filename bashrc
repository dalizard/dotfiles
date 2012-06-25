source "`brew --prefix grc`/etc/grc.bashrc"

export TERM="xterm-color"
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"
export TERM="xterm-256color"
export JAVA_OPTS="-d32"
export PATH="$HOME/.bin:/usr/local/bin:$PATH"

eval "$(rbenv init -)"
