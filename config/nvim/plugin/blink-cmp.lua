-- ABOUTME: Configures blink.cmp for autocompletion with copilot integration.
-- ABOUTME: Includes LuaSnip and blink-copilot as dependencies.

vim.pack.add({
  { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range('2.x') },
  'https://github.com/fang2hou/blink-copilot',
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') },
})

require('blink.cmp').setup({
  snippets = { preset = 'luasnip' },
  cmdline = { enabled = false },
  keymap = {
    preset = 'default',
    ['<cr>'] = { 'select_and_accept', 'fallback' },
  },
  appearance = {
    nerd_font_variant = 'mono',
    kind_icons = {
      Copilot = "",
      Class = "󰠱",
      Color = "󰏘",
      Constant = "󰏿",
      Constructor = "",
      Enum = "",
      EnumMember = "",
      Event = "",
      Field = "󰇽",
      File = "󰈙",
      Folder = "󰉋",
      Function = "󰊕",
      Interface = "",
      Keyword = "󰌋",
      Method = "󰆧",
      Module = "",
      Operator = "󰆕",
      Property = "󰜢",
      Reference = "",
      Snippet = "",
      Struct = "",
      Text = "",
      TypeParameter = "󰅲",
      Unit = "",
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
    ghost_text = { enabled = false },
  },
  fuzzy = {
    implementation = "rust",
    use_proximity = true,
    frecency = {
      enabled = true,
    }
  },
  sources = {
    default = { 'copilot', 'lsp', 'buffer', 'path' },
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
})
