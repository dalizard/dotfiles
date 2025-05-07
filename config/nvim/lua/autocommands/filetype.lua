vim.api.nvim_create_augroup("_filetype", { clear = true })

-- Set filetype for all slim files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group    = "_filetype",
  pattern  = "*.slim",
  command = "set ft=slim",
})
