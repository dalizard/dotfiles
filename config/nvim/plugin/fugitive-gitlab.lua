-- ABOUTME: Loads fugitive-gitlab for GitLab integration with fugitive.
-- ABOUTME: Deferred to after startup.

vim.g.fugitive_gitlab_domains = { 'https://gitlab.silverfin.com' }

vim.schedule(function()
  vim.pack.add({ 'https://github.com/shumphrey/fugitive-gitlab.vim' })
end)
