# Initialize completion
autoload -U compinit
compinit

# Initialize colors
autoload -U colors
colors

# Add paths
export PATH="/usr/local/bin:$PATH"

# Colorize terminal
export GREP_OPTIONS="--color"
export TERM="xterm-256color"

# Aliases
alias ll='ls -laG'
alias gg='git status'
alias be='bundle exec'
alias test_env='export CUCUMBER_SUFFIX=_cucumber && export RAILS_ENV=test && export RACK_ENV=test'

# Nicer history
HISTFILE=$HOME/.history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

# Use vim as the editor
export EDITOR=vim

# By default, zsh considers many characters part of a word (e.g., _ and -).
# Narrow that down to allow easier skipping through words via M-f and M-b.
export WORDCHARS='*?[]~&;!$%^<>'

# JRuby Optimizations
export JRUBY_OPTS="-J-Xmx2048m -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1"

# chruby
source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

# Promt
setopt PROMPT_SUBST

function update_current_git_vars() {
  local gitstatus=~/.zsh/git-prompt/gitstatus.py
  _GIT_STATUS=`python ${gitstatus}`
  __CURRENT_GIT_STATUS=("${(@f)_GIT_STATUS}")

  GIT_BRANCH=$__CURRENT_GIT_STATUS[1]
  GIT_REMOTE=$__CURRENT_GIT_STATUS[2]
  GIT_STAGED=$__CURRENT_GIT_STATUS[3]
  GIT_CONFLICTS=$__CURRENT_GIT_STATUS[4]
  GIT_CHANGED=$__CURRENT_GIT_STATUS[5]
  GIT_UNTRACKED=$__CURRENT_GIT_STATUS[6]
  GIT_CLEAN=$__CURRENT_GIT_STATUS[7]
}

function git_super_status() {
  local gitdir="$(git rev-parse --git-dir 2>/dev/null)"

  if [ $? -ne 0 ] || [ -z "$gitdir" ]; then
    return
  fi

	update_current_git_vars

  if [ -n "$__CURRENT_GIT_STATUS" ]; then
	  STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH%{${reset_color}%}"
	  if [ -n "$GIT_REMOTE" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_REMOTE$GIT_REMOTE%{${reset_color}%}"
	  fi
	  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
	  if [ "$GIT_STAGED" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED$GIT_STAGED%{${reset_color}%}"
	  fi
	  if [ "$GIT_CONFLICTS" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CONFLICTS$GIT_CONFLICTS%{${reset_color}%}"
	  fi
	  if [ "$GIT_CHANGED" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CHANGED$GIT_CHANGED%{${reset_color}%}"
	  fi
	  if [ "$GIT_UNTRACKED" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED%{${reset_color}%}"
	  fi
	  if [ "$GIT_CLEAN" -eq "1" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
	  fi
	  STATUS="$STATUS%{${reset_color}%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
	  echo "$STATUS "
	fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}●"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}✚"
ZSH_THEME_GIT_PROMPT_REMOTE=""
ZSH_THEME_GIT_PROMPT_UNTRACKED="…"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔"

PROMPT=$'%{$fg[yellow]%}%m%{$reset_color%}:%{$fg[red]%}%n%{$reset_color%} %1~ $(git_super_status)\n%# '
