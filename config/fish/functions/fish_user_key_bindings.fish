function fish_user_key_bindings
  # The reverse search in fish works in reverse. You first type what you want to
  # search for, then you press the Up arrow. Rebind it to ^E, so I can remember
  # it better.
  bind \ce history-search-backward
end

fzf_key_bindings
