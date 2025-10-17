return {
  'saghen/blink.cmp',
  dependencies = {
    'rafamadriz/friendly-snippets',
    "fang2hou/blink-copilot",
  },
  version = '1.*',
  opts = {
    cmdline = { enabled = false },
    keymap = { preset = 'default' },
    appearance = {
      nerd_font_variant = 'mono',
      kind_icons = {
        Copilot = "",
        Class = "󰠱",
        Color = "󰏘",
        Constant = "󰏿",
        Constructor = "",
        Enum = "",
        EnumMember = "",
        Event = "",
        Field = "󰇽",
        File = "󰈙",
        Folder = "󰉋",
        Function = "󰊕",
        Interface = "",
        Keyword = "󰌋",
        Method = "󰆧",
        Module = "",
        Operator = "󰆕",
        Property = "󰜢",
        Reference = "",
        Snippet = "",
        Struct = "",
        Text = "",
        TypeParameter = "󰅲",
        Unit = "",
        Value = "󰎠",
        Variable = "󰂡",
      },
    },
    completion = {
      documentation = {
        treesitter_highlighting = true,
        window = { border = "rounded" },
      },
      menu = {
        border = "rounded",
      },
      ghost_text = { enabled = true },
    },
    fuzzy = {
      implementation = "rust",
      use_proximity = true,
      frecency = {
        enabled = true,
      }
    },
    sources = {
      default = { 'copilot', 'lsp', 'buffer', 'snippets', 'path' },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
          opts = {
            max_completions = 3,
          }
        },
      },
    },
  },
  opts_extend = { "sources.default" },
}
