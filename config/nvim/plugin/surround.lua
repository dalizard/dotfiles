-- ABOUTME: Loads nvim-surround for text object surround operations.
-- ABOUTME: Deferred to after startup.

vim.schedule(function()
  vim.pack.add({ 'https://github.com/kylechui/nvim-surround' })
  require('nvim-surround').setup({})
end)
