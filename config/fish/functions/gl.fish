function gl --description 'Git fuzzy find and checkout local branch'
	if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
		git branch --sort=-committerdate | fzf-tmux | sed "s/.* //" | read -l branch;
    and git checkout $branch
	else
		echo Not a git repo.
	end
end
