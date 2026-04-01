-- ABOUTME: Configures nvim-colorizer for CSS color highlighting.
-- ABOUTME: Deferred to BufReadPre for faster startup.

vim.api.nvim_create_autocmd('BufReadPre', { once = true, callback = function()
  vim.pack.add({ 'https://github.com/catgoose/nvim-colorizer.lua' })

  require('colorizer').setup({
    options = {
      parsers = {
        css = true,
        css_fn = true,
        names = {
          enable = false
        }
      }
    }
  })
end })
