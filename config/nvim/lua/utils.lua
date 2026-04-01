local utils = {}

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
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

return utils
