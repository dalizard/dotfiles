# Do not show the greeting message
set -g fish_greeting

# Don't let fish masquerade itself as other shells
set -x SHELL (which fish)

set -x OS_NAME (uname -s | string lower)

set -x EDITOR vim
set -x VISUAL vim
set -x PAGER less
set -x BROWSER open

# Set the color theme
if not set -q COLOR_THEME
  set -xU COLOR_THEME dark
  source ~/.config/fish/colors/dark.fish
end

# tmux creates a global variable COLOR_THEME and we need to drop it -- seems like a bug
set -eg COLOR_THEME

# Add .bin to PATH
fish_add_path ~/.bin

# MacPorts paths
if test $OS_NAME = 'darwin'
  fish_add_path /opt/local/bin /opt/local/sbin
end

# Make sure we have a unicode capable LANG and LC_CTYPE so the unicode
# characters do not look like crap on macOS and other environments.
set -x LANG en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8

# Enable Erlang shell history
set -x ERL_AFLAGS '-kernel shell_history enabled'

# Set ripgrep config file
set -x RIPGREP_CONFIG_PATH ~/.ripgreprc

# No bold text in grep
set -x GREP_COLOR '0;31'

# No warnings in Ruby
set -x RUBYOPT '-W0'

# Fish colors
set -x fish_color_search_match --background=294d6d
set -x fish_color_cancel white --italics
set -x fish_pager_color_description ebdbb2
set -x fish_pager_color_prefix magenta
set -x fish_pager_color_progress ebdbb2 --background=294d6d

# Set global Node.js version
set -U nvm_default_version v17.0.1

# Shortcuts
alias g='git'
alias ll='ls -alGF'
alias gg='git status'
alias be='bundle exec'
alias gh="git log --pretty=format:'%h' -n 1 | xclip -se c -i"
alias gb="git rev-parse --abbrev-ref HEAD | tr -d '\n' | xclip -se c -i"
alias n="nnn"
alias myip='curl ipinfo.io'

if test $OS_NAME = 'openbsd'
  alias ls='colorls'
end

# Disable tab titles
function fish_title; end

# Set ripgrep as the default source for fzf
set -x FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*" --ignore-file ~/.rgignore'
set -x FZF_DEFAULT_OPTS '--no-bold'

# Erlang libraries
set -x ERL_LIBS /usr/local/opt/proper

# Set GOPATH and add ~/.go/bin to PATH
set -x GOPATH ~/.go
fish_add_path ~/.go/bin

# Start keychain
if test $OS_NAME != 'darwin'; and status --is-interactive
  keychain --eval --quiet -Q github_ed25519 frodo_ed25519 github | source
end

# User defined functions
source ~/.config/fish/functions/user_defined.fish

if test $OS_NAME != 'openbsd'
  starship init fish | source
end
