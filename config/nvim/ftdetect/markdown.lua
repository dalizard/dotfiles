vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "filetypedetect",
  pattern = "*.m*down",
  callback = function()
    vim.cmd("setlocal filetype=markdown")
  end
})
