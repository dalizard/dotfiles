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

function gr --description 'Git fuzzy find and checkout remote branch'
	if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
		git branch -r | grep -v HEAD | fzf-tmux | sed "s/.* //" | sed "s#origin/##" | read -l branch;
    and git checkout $branch
	else
		echo Not a git repo.
	end
end

function fkill --description 'Fuzzy kill by PID'
	ps -ef | sed 1d | fzf-tmux | awk '{print $2}' | read -l pid
  if [ "x$pid" != "x" ]
    kill -9 $pid
  end
end
