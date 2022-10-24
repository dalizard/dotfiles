vim.api.nvim_create_augroup("_general", { clear = true })

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd('BufReadPost', {
  group    = "_general",
  pattern  = "*",
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") and string.match(vim.bo.filetype, 'commit') then
      vim.fn.setpos('.', vim.fn.getpos("'\""))
      vim.cmd("normal! g`\"")
    end
  end
})
