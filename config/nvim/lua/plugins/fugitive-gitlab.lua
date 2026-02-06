return {
  "shumphrey/fugitive-gitlab.vim",
  event = "VeryLazy",
  config = function()
    vim.g.fugitive_gitlab_domains = { 'https://gitlab.silverfin.com' }
  end
}
