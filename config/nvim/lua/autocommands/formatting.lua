vim.api.nvim_create_augroup("_formatting", { clear = true })

-- Only show cursorline in the current window and in normal mode
vim.api.nvim_create_autocmd({ "WinLeave", "InsertEnter" }, {
  group = "_formatting",
  pattern = "*",
  callback = function()
    vim.opt_local.cursorline = false
  end,
})
vim.api.nvim_create_autocmd({ "WinEnter", "InsertLeave" }, {
  group = "_formatting",
  pattern = "*",
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

-- Disable automatic comment insertion
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = "_formatting",
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})
