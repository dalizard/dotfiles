# Do not show the greeting message
set -g fish_greeting

# Don't let fish masquerade itself as other shells
set -x SHELL /opt/homebrew/bin/fish

set -x OS_NAME darwin

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

# Homebrew
set -gx HOMEBREW_PREFIX /opt/homebrew
set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
set -gx HOMEBREW_REPOSITORY /opt/homebrew
# Use --path to modify $PATH directly instead of $fish_user_paths, which always
# takes precedence over $PATH and prevents mise activate from prepending tool paths
fish_add_path --global --path /opt/homebrew/bin /opt/homebrew/sbin

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

# Use YJIT
set -x RUBY_YJIT_ENABLE true

# Workaround for macOS forking
set -x OBJC_DISABLE_INITIALIZE_FORK_SAFETY yes

# Workaround for RSpec
set -x PGGSSENCMODE disable

if test -d /opt/homebrew/opt/postgresql@16
  fish_add_path --global --path /opt/homebrew/opt/postgresql@16/bin
  set -gx LDFLAGS "-L/opt/homebrew/opt/postgresql@16/lib"
  set -gx CPPFLAGS "-I/opt/homebrew/opt/postgresql@16/include"
  set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/postgresql@16/lib/pkgconfig"
end

# Shortcuts
alias g='git'
alias ls='eza'
alias ll='ls -1la'
alias gg='git status'
alias be='bundle exec'
alias n='nnn'
alias myip='curl ipinfo.io'
alias kc='kubectl'

# Disable tab titles
function fish_title; end

# Set ripgrep as the default source for fzf
set -x FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*" --ignore-file ~/.rgignore'
set -x __fzf_color_light 'fg:#282828,fg+:#282828,bg+:#f2e5bc,hl:#689d6a,hl+:#427b58,prompt:#427b58,pointer:#af3a03,info:#7c6f64'
set -x __fzf_color_dark 'fg:#fbf1c7,fg+:#fbf1c7,bg+:#3c3836,hl:#689d6a,hl+:#427b58,prompt:#427b58,pointer:#af3a03,info:#7c6f64'

set -x FZF_DEFAULT_OPTS --no-bold --color (set __fzf_color_{$COLOR_THEME})

# Erlang libraries
set -x ERL_LIBS /usr/local/opt/proper

# Set GOPATH and add bin folders
set -x GOPATH ~/.go
fish_add_path --global --path ~/.go/bin ~/.local/bin ~/.bin


# Starship prompt is loaded from conf.d/starship.fish
# After updating starship, regenerate the cache:
#   starship init fish --print-full-init > ~/.config/fish/conf.d/starship.fish

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# Activate mise
mise activate fish | source
