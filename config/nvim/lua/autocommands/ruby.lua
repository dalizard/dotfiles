vim.api.nvim_create_augroup("_ruby", { clear = true })

-- Disable tree-sitter re-indentation for `.`
vim.api.nvim_create_autocmd({ "FileType"}, {
  group = "_ruby",
  pattern = "ruby",
  callback = function()
    vim.opt_local.indentkeys:remove(".")
  end,
})
