-- ABOUTME: Configures mason and mason-lspconfig for LSP server management.
-- ABOUTME: Auto-installs and enables language servers.

vim.pack.add({
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
})

require('mason').setup({
  registries = {
    "github:mason-org/mason-registry",
  },
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require('mason-lspconfig').setup({
  automatic_enable = {
    exclude = {
      "copilot"
    }
  },
  ensure_installed = {
    "bashls",
    "clangd",
    "copilot",
    "cssls",
    "dockerls",
    "golangci_lint_ls",
    "eslint",
    "gopls",
    "html",
    "jsonls",
    "lua_ls",
    "pylsp",
    "ruby_lsp",
    "rust_analyzer",
    "tailwindcss",
    "ts_ls",
    "vue_ls",
    "yamlls",
  }
})
