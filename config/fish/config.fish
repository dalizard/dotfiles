# Do not show the greeting message
set fish_greeting

# Add color support for terminals pretending to be xterm
test $TERM = xterm; and set -x TERM xterm-256color

# Add .bin to PATH
set -x PATH ~/.bin /usr/local/sbin $PATH

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

# Enable Erlang shell history
set -x ERL_AFLAGS '-kernel shell_history enabled'

# Search hightlight color
set fish_color_search_match --background=771503

# Shortcuts
alias g='git'
alias ll='ls -alGF'
alias gg='git status'
alias be='bundle exec'
alias gh="git log --pretty=format:'%h' -n 1 | pbcopy"
alias gb="git rev-parse --abbrev-ref HEAD | pbcopy"

# hub is aliased as git
eval (hub alias -s)

# Disable tab titles
function fish_title; end

# User defined functions
source ~/.config/fish/functions/user_defined.fish

# Set ag as the default source for fzf
set -x FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# Stick with PostgreSQL 9.6
set -g fish_user_paths '/usr/local/opt/postgresql@9.6/bin' $fish_user_paths

# Ruby manager
source /usr/local/share/chruby/chruby.fish
source /usr/local/share/chruby/auto.fish
