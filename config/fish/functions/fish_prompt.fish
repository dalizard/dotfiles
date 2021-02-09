set -L
set -U fish_color_normal normal
set -U fish_color_command b294bb
set -U fish_color_quote b5bd68
set -U fish_color_redirection 8abeb7
set -U fish_color_end b294bb
set -U fish_color_error cc6666
set -U fish_color_param 81a2be
set -U fish_color_comment f0c674
set -U fish_color_match --background=brblue
set -U fish_color_selection white --bold --background=brblack
set -U fish_color_search_match bryellow --background=62030C
set -U fish_color_history_current --bold
set -U fish_color_operator 00a6b2
set -U fish_color_escape 00a6b2
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_valid_path --underline
set -U fish_color_autosuggestion 969896
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_cancel -r
set -U fish_pager_color_completion normal
set -U fish_pager_color_description B3A06D yellow
set -U fish_pager_color_prefix white --bold --underline
set -U fish_pager_color_progress brwhite --background=62030C

set -g __fish_git_prompt_show_informative_status 1

set -g __fish_git_prompt_char_upstream_ahead "↑"
set -g __fish_git_prompt_char_upstream_behind "↓"
set -g __fish_git_prompt_char_upstream_prefix ""
set -g __fish_git_prompt_char_stagedstate "●"
set -g __fish_git_prompt_char_dirtystate "✚"
set -g __fish_git_prompt_char_untrackedfiles "…"
set -g __fish_git_prompt_char_conflictedstate "✖"
set -g __fish_git_prompt_char_cleanstate "✔"

set -g __fish_git_prompt_color_branch purple
set -g __fish_git_prompt_color_cleanstate green
set -g __fish_git_prompt_color_dirtystate blue
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal

function fish_prompt --description 'Write out the prompt'

  set -l last_status $status

  if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color normal)
  end

  # PWD
  set_color $fish_color_cwd
  echo -n (prompt_pwd)
  set_color normal

  printf '%s ' (__fish_git_prompt)

  if not test $last_status -eq 0
    set_color $fish_color_error
  end

  echo -n '$ '

end
