vim.api.nvim_create_augroup("_general", { clear = true })

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd('BufReadPost', {
  group    = "_general",
  pattern  = "*",
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.fn.setpos('.', vim.fn.getpos("'\""))
      vim.cmd("normal! g`\"")
    end
  end
})

-- Only show cursorline in the current window and in normal mode
vim.api.nvim_create_autocmd({ "WinLeave", "InsertEnter" }, {
  group = "_general",
  pattern = "*",
  callback = function()
    vim.cmd("set nocursorline")
  end,
})
vim.api.nvim_create_autocmd({ "WinEnter", "InsertLeave" }, {
  group = "_general",
  pattern = "*",
  callback = function()
    vim.cmd("set cursorline")
  end,
})
