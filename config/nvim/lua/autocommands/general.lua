vim.api.nvim_create_augroup("_general", { clear = true })

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group    = "_general",
  pattern  = "*",
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") and
        string.match(vim.bo.filetype, 'gitcommit') == nil then
      print "Hello!!"
      vim.fn.setpos('.', vim.fn.getpos("'\""))
      vim.cmd("normal! g`\"")
    end
  end
})
