vim.api.nvim_create_augroup("_editing", { clear = true })

-- Enable spell check and word wrap for certain file types
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "_editing",
  pattern = { "markdown", "plaintext", "text" },
  callback = function()
    vim.cmd("setlocal spell")
    vim.cmd("setlocal wrap")
  end,
})