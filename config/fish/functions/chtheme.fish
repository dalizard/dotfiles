function chtheme --description 'Toggle background color'
  switch $COLOR_THEME
    case light
      set COLOR_THEME dark
    case dark
      set COLOR_THEME light
  end

  kitty +kitten themes --reload-in=all $COLOR_THEME

  source ~/.config/fish/colors/$COLOR_THEME.fish

  if tmux has-session 2> /dev/null
    tmux source-file ~/.tmux-gruvbox-$COLOR_THEME.conf
  end

  for f in {$TMPDIR}nvim.{$USER}/*/nvim.*.0
    nvim --server $f --remote-send "<C-\><C-n>:set background=$COLOR_THEME<cr>"
  end
end
