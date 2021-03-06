function ct --description 'Generate ctags'
  ctags -R -f ./.git/tags .
end

function gl --description 'Git fuzzy find and checkout local branch'
	if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
		git branch | fzf-tmux | sed "s/.* //" | read -l branch;
    and git checkout $branch
	else
		echo Not a git repo.
	end
end

function gr --description 'Git fuzzy-find and checkout remote branch'
  test -n "$FZF_TMUX_HEIGHT"; or set FZF_TMUX_HEIGHT 10%
  begin
    set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS $FZF_CTRL_R_OPTS"

    if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
      git branch -r | grep -v HEAD | eval (__fzfcmd) | sed "s/.* //" | sed "s#origin/##" | read -l branch
      and git checkout $branch
      commandline -f repaint
    else
      echo Not a git repo.
    end
  end
  commandline -f repaint
end

function fkill --description 'Fuzzy kill by PID'
	ps -ef | sed 1d | fzf-tmux | awk '{print $2}' | read -l pid
  if [ "x$pid" != "x" ]
    kill -9 $pid
  end
end


function gir --description 'Git fuzzy-find commit SHA and interactively rebase'
	if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
    git log --color=always --pretty=format:"%C(yellow)%h %Cblue%>(12)%ar %Cgreen%<(7)%aN%Cred%d %Creset%s" --abbrev-commit --reverse | fzf --tac +s -e --ansi | awk '{print $1;}' | read -l commit
    if test -n "$commit"
      git rebase -i $commit^
    end
  else
    echo Not a git repo.
  end
end

function fssh --description "Fuzzy-find ssh host and ssh into it"
  rg '^Host [^*]' ~/.ssh/config | cut -d ' ' -f 2 | fzf --height 10% | xargs -o ssh
end

function tunup --description "Initialize SSH tunnel for exposing local web servers"
  set port $argv
	echo "Forwarding rb.forebits.com:5000 to local port $port"
	ssh -R 5000:127.0.0.1:$port gollum
end
