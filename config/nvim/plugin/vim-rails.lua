-- ABOUTME: Loads vim-rails for Ruby on Rails development support.
-- ABOUTME: Deferred to after startup.

vim.schedule(function()
  vim.pack.add({ 'https://github.com/tpope/vim-rails' })
end)
