source ~/.sources

export TERM="xterm-256color"
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"
export JRUBY_OPTS="--1.9 -J-Xmx2048m -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1"
export EDITOR="vim"
export PATH="$HOME/.bin:/usr/local/bin:$PATH"

chruby 2.0.0-rc2
