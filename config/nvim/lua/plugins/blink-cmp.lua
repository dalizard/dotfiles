return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '1.*',
  opts = {
    keymap = { preset = 'default' },

    appearance = {
      nerd_font_variant = 'mono'
    },

    completion = {
      documentation = {
        treesitter_highlighting = true,
        window = { border = "rounded" },
      },
      menu = {
        border = "rounded",
      }
    },
    fuzzy = {
      implementation = "rust",
      use_proximity = true,
      frecency = {
        enabled = true,
      }
    },
  },
  opts_extend = { "sources.default" },
}
