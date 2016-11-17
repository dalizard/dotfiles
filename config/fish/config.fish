# Do not show the greeting message
set fish_greeting

# Add color support for terminals pretending to be xterm
test $TERM = xterm; and set -x TERM xterm-256color

# Set PATH
set -x PATH /usr/local/sbin $PATH

# Don't let fish masquerade itself as other shells
set -x SHELL (which fish)

# Help out programs spawning editors based on $EDITOR.
# The same for pagers, just use less for them.
set -x EDITOR vim
set -x PAGER less
set -x BROWSER open

# Make sure we have a unicode capable LANG and LC_CTYPE so the unicode
# # characters does not look like crap on OSX and other environments.
set -x LANG en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8

# Search hightlight color
set fish_color_search_match --background=771503

# Shortcuts
alias g='git'
alias ll='ls -alGF'
alias gg='git status'
alias be='bundle exec'

# hub is aliased as git
eval (hub alias -s)

# Disable tab titles
function fish_title; end

# User defined functions
source ~/.config/fish/functions/user_defined.fish

# Ruby manager
source /usr/local/share/chruby/chruby.fish
source /usr/local/share/chruby/auto.fish
