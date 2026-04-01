-- ABOUTME: Loads vim-fugitive for Git integration.
-- ABOUTME: Deferred to after startup.

vim.schedule(function()
  vim.pack.add({ 'https://github.com/tpope/vim-fugitive' })
end)
