-- ABOUTME: Loads vim-rhubarb for GitHub integration with fugitive.
-- ABOUTME: Deferred to after startup.

vim.schedule(function()
  vim.pack.add({ 'https://github.com/tpope/vim-rhubarb' })
end)
