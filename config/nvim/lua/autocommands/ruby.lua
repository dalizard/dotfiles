vim.api.nvim_create_augroup("_ruby", { clear = true })

-- Set Active Admin .arb files to be ruby files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "_ruby",
  pattern = "*.html.arb,*.html.slim",
  callback = function()
    vim.cmd("setfiletype ruby")
  end,
})

-- Make ? and ! part of the keyword
vim.api.nvim_create_autocmd("FileType", {
  group = "_ruby",
  pattern = "ruby",
  callback = function()
    vim.cmd("setlocal iskeyword+=?,!")
  end,
})
