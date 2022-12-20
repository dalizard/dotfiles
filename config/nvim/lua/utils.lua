local Utils = {}

Utils.project_files = function(theme_name)
  local theme
  if theme_name then
    theme = require('telescope.themes')[theme_name]()
  end

  vim.fn.system('git rev-parse --is-inside-work-tree')
  if vim.v.shell_error == 0 then
    require "telescope.builtin".git_files(theme)
  else
    require "telescope.builtin".find_files(theme)
  end
end

return Utils
