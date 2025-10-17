local utils = {}

utils.project_files = function(theme_name)
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

utils.comment_rubocop = function()
  local error = vim.diagnostic.get()
  local line = vim.fn.line(".")
  local bufnr = vim.fn.bufnr()
  local current_error

  ---@diagnostic disable-next-line: unused-local
  for __, v in ipairs(error) do
    if v.lnum + 1 == line and bufnr == v.bufnr then
      if not current_error then
        current_error = v
      end
    end
  end

  if current_error then
    local current_line = vim.fn.getline(".")
    local real_cop_name = current_error.code

    if string.match(current_line, "# rubocop:disable") then
      vim.cmd("normal! A, " .. real_cop_name)
    else
      vim.cmd("normal! A # rubocop:disable " .. real_cop_name)
    end
  end
end

utils.keymap = function(mode, lhs, rhs, desc, opts)
  -- Modes
  --   normal_mode = "n",
  --   insert_mode = "i",
  --   visual_mode = "v",
  --   visual_block_mode = "x",
  --   term_mode = "t",
  --   command_mode = "c",
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

return utils
