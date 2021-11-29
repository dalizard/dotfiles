function fkill --description 'Fuzzy kill by PID'
	ps -ef | sed 1d | fzf-tmux | awk '{print $2}' | read -l pid
  if [ "x$pid" != "x" ]
    kill -9 $pid
  end
end
