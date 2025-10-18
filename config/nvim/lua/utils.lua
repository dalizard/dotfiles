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

  for _, v in ipairs(error) do
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

utils.create_autocmds = function(definitions)
  for group_name, autocmds in pairs(definitions) do
    -- Create or clear the augroup
    local group = vim.api.nvim_create_augroup(group_name, { clear = true })

    for _, def in ipairs(autocmds) do
      local events = def[1]
      local pattern = def[2]
      local command = def[3]

      -- Prepare the autocmd options
      local opts = { group = group, pattern = pattern }

      if type(command) == "string" then
        opts.command = command
      elseif type(command) == "function" then
        opts.callback = command
      else
        error("Invalid autocmd definition: expected string or function as 3rd argument")
      end

      -- Support multiple events separated by commas or a table of events
      if type(events) == "string" then
        for event in string.gmatch(events, "([^,]+)") do
          vim.api.nvim_create_autocmd(vim.trim(event), opts)
        end
      elseif type(events) == "table" then
        opts.event = events
        vim.api.nvim_create_autocmd(events, opts)
      else
        error("Invalid events type in autocmd definition")
      end
    end
  end
end

return utils
