function ct
  ctags -R -f ./.git/tags .
end

function gl
	if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
		git branch -vv | fzf | awk '{print $1}' | sed "s/.* //" | read -l branch;
    and git checkout $branch
	else
		echo Not a git repo.
	end
end

function gr
	if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
		git branch --all | grep -v HEAD | fzf | sed "s/.* //" | sed "s#remotes/[^/]*/##" | read -l branch;
    and git checkout $branch
	else
		echo Not a git repo.
	end
end

function fkill
	ps -ef | sed 1d | fzf | awk '{print $2}' | read -l pid
  if [ "x$pid" != "x" ]
    kill -9 $pid
  end
end
