function change_background
  switch $COLOR_THEME
    case light
      set COLOR_THEME dark
    case dark
      set COLOR_THEME light
  end

  kitty_theme $COLOR_THEME

  if tmux has-session 2> /dev/null
    tmux source-file ~/.tmux-gruvbox-$COLOR_THEME.conf
  end

  source ~/.config/fish/colors/$COLOR_THEME.fish

  if test $OS_NAME = 'openbsd'
    pkill -USR1 vim
  else
    killall -USR1 vim
  end
end
