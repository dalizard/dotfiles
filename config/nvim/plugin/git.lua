-- ABOUTME: Loads Git integration plugins (fugitive, rhubarb, fugitive-gitlab).
-- ABOUTME: Deferred to after startup.

vim.g.fugitive_gitlab_domains = { 'https://gitlab.silverfin.com' }

vim.schedule(function()
  vim.pack.add({
    'https://github.com/tpope/vim-fugitive',
    'https://github.com/tpope/vim-rhubarb',
    'https://github.com/shumphrey/fugitive-gitlab.vim',
  })
end)
