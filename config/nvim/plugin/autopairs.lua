-- ABOUTME: Configures nvim-autopairs for automatic bracket/quote pairing.
-- ABOUTME: Deferred to InsertEnter for faster startup.

vim.api.nvim_create_autocmd('InsertEnter', { once = true, callback = function()
  vim.pack.add({ 'https://github.com/windwp/nvim-autopairs' })

  require('nvim-autopairs').setup({
    check_ts = true,
    ts_config = {
      lua = { "string", "source" },
      javascript = { "string", "template_string" },
      java = false,
    },
    disable_filetype = { "spectre_panel", "snacks_picker_input" },
    enable_moveright = true,
    fast_wrap = {
      map = "<M-e>",
      chars = { "{", "[", "(", '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
      offset = 0,
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "PmenuSel",
      highlight_grey = "LineNr",
    },
  })
end })
