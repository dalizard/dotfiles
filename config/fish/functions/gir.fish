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
