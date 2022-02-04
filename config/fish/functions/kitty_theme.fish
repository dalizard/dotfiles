function kitty_theme -d "Change kitty theme" -a theme_name
  # Do nothing if there is no theme specified
  if [ -z "$theme_name" ]
    return
  end

  set -l _theme_name (string replace -r '^.' (string sub -l 1 $theme_name | string upper) $theme_name)

  if test $OS_NAME = 'darwin'
    kitty +kitten themes --reload-in=all $_theme_name
  else
    # Path to search for theme conf files
    set -l theme_folder (realpath ~/.dotfiles/config/kitty/themes)

    # Full path to theme
    set -l theme_path "$theme_folder/$theme_name.conf"

    # If theme exists, change theme
    if [ -e "$theme_path" ]
      # Change for current session
      cat ~/.config/kitty/themes/$theme_name.conf > ~/.config/kitty/current-theme.conf
      kitty @ set-colors --all --configured $theme_path
    end
  end
end
