# Do not show the greeting message
set fish_greeting

# Add color support for terminals pretending to be xterm
test $TERM = xterm; and set -x TERM xterm-256color

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

# JRuby flags
set -x JRUBY_OPTS '--dev --2.0 -J-Xmx2048m'

# Aliases
alias g   'git';                     complete_like g   'git'
alias ll  'ls -laG';                 complete_like ll  'ls -laG'
alias gg  'git status';              complete_like gg  'git status'
alias be  'bundle exec';             complete_like be  'bundle exec'
alias cuc 'bundle exec cucumber -c'; complete_like cuc 'bundle exec cucumber -c'
alias tl  'tmux list-sessions';      complete_like tl  'tmux list-sessions'
alias ta  'tmux -2 attach -t $1';    complete_like ta  'tmux -2 attach -t $1'
alias tk  'tmux kill-session -t $1'; complete_like tk  'tmux kill-session -t $1'

# Secret test helper
function test_env
  set -gx CUCUMBER_SUFFIX _cucumber
  set -gx RAILS_ENV test
  set -gx RACK_ENV test
end

# Disable tab titles
function fish_title; end

# Ruby Manager
source /usr/local/share/chruby/chruby.fish
source /usr/local/share/chruby/auto.fish
