return {
  "shumphrey/fugitive-gitlab.vim",
  config = function()
    vim.cmd([[
      let g:fugitive_gitlab_domains = ['https://gitlab.silverfin.com']
    ]])
  end
}
