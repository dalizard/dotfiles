vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = "filetypedetect",
  pattern = "*.slim",
  callback = function()
    vim.cmd("setlocal filetype=slim")
  end
})
