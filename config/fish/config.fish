# Do not show the greeting message
set fish_greeting

# Add .bin to PATH
set -U fish_user_paths ~/.bin $fish_user_paths

# Don't let fish masquerade itself as other shells
set -x SHELL (which fish)

set -x EDITOR vim
set -x VISUAL vim
set -x PAGER less
set -x BROWSER open

# Make sure we have a unicode capable LANG and LC_CTYPE so the unicode
# # characters does not look like crap on OSX and other environments.
set -x LANG en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8

# Enable Erlang shell history
set -x ERL_AFLAGS '-kernel shell_history enabled'

# Set ripgrep config file
set -x RIPGREP_CONFIG_PATH ~/.ripgreprc

# Search hightlight color
set fish_color_search_match --background=771503

# Shortcuts
alias g='git'
alias ll='ls -alGF'
alias gg='git status'
alias be='bundle exec'
alias gh="git log --pretty=format:'%h' -n 1 | xclip -se c -i"
alias gb="git rev-parse --abbrev-ref HEAD | tr -d '\n' | xclip -se c -i"
alias yaegi="rlwrap yaegi"
alias n="nnn"

# hub is aliased as git
eval (hub alias -s)

# Disable tab titles
function fish_title; end

# User defined functions
source ~/.config/fish/functions/user_defined.fish

# Set ripgrep as the default source for fzf
set -x FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*" --ignore-file ~/.rgignore'

# Erlang libraries
set -x ERL_LIBS /usr/local/opt/proper

# Set GOPATH and add ~/.go/bin to PATH
set -x GOPATH ~/.go
set -x PATH $GOPATH/bin $PATH

# Start keychain
if status --is-interactive
  keychain --eval --quiet -Q github_ed25519 frodo_ed25519 | source
end

# Ruby manager
source /usr/local/share/chruby/chruby.fish
source /usr/local/share/chruby/auto.fish
