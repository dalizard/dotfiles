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

	test $SSH_TTY
    and printf (set_color red)$USER(set_color brwhite)'@'(set_color yellow)(prompt_hostname)' '
    test $USER = 'root'
    and echo (set_color red)"#"

    echo -n (set_color red)'❯'(set_color yellow)'❯'(set_color green)'❯ '
end
