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

# Set global Node.js version
if test $OS_NAME = 'darwin'
  set -U nvm_default_version v18.12.0
end

# Shortcuts
alias g='git'
alias ll='ls -alGF'
alias gg='git status'
alias be='bundle exec'
alias n='nnn'
alias myip='curl ipinfo.io'
alias kc='kubectl'

if test $OS_NAME = 'openbsd'
  alias ls='colorls'
end

# Disable tab titles
function fish_title; end

# Set ripgrep as the default source for fzf
set -x FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*" --ignore-file ~/.rgignore'
set -x __fzf_color_light 'fg:#282828,fg+:#282828,bg+:#f2e5bc,hl:#689d6a,hl+:#427b58,prompt:#427b58,pointer:#af3a03,info:#7c6f64'
set -x __fzf_color_dark 'fg:#fbf1c7,fg+:#fbf1c7,bg+:#3c3836,hl:#689d6a,hl+:#427b58,prompt:#427b58,pointer:#af3a03,info:#7c6f64'

set -x FZF_DEFAULT_OPTS --no-bold --color (set __fzf_color_{$COLOR_THEME})

# Erlang libraries
set -x ERL_LIBS /usr/local/opt/proper

# Set GOPATH and add ~/.go/bin to PATH
set -x GOPATH ~/.go
fish_add_path ~/.go/bin

# Start keychain
if test $OS_NAME != 'darwin'; and status --is-interactive
  keychain --eval --quiet -Q github_ed25519 frodo_ed25519 github | source
end

if test $OS_NAME = 'openbsd'
  ~/.cargo/bin/starship init fish | source
else
  starship init fish | source
end
