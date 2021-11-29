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
