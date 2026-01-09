return {
  {
    "williamboman/mason.nvim",
    opts = {
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
    }
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "mason.nvim",
    opts = {
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
    }
  },
}
