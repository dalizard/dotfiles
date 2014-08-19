# Set PATH
set -gx PATH /usr/local/bin $PATH

# Do not show the greeting message
set fish_greeting

# Add color support for terminals pretending to be xterm.
test $TERM = xterm; and set -x TERM xterm-256color

# Don't let fish masquerade itself as other shells.
set -x SHELL (which fish)

# Help out programs spawning editors based on $EDITOR. The same for pagers,
# just use less for them.
set -x EDITOR vim
set -x PAGER less
set -x BROWSER open

# JRuby Optimization
set -x JRUBY_OPTS '-J-Xmx2048m -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1'

# Aliases
alias g   'git';                     complete_like g   'git'
alias ll  'ls -laG';                 complete_like ll  'ls -laG'
alias gg  'git status';              complete_like gg  'git status'
alias be  'bundle exec';             complete_like be  'bundle exec'
alias cuc 'bundle exec cucumber -c'; complete_like cuc 'bundle exec cucumber -c'

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
chruby ruby-2.1.2
