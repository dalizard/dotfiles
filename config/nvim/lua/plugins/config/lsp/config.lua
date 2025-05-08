local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup()
mason_lspconfig.setup({
  ensure_installed = {
    "bashls",
    "clangd",
    "cssls",
    "dockerls",
    "golangci_lint_ls",
    "gopls",
    "html",
    "jsonls",
    "lua_ls",
    "pylsp",
    "rust_analyzer",
    "solargraph",
    "tailwindcss",
    "ts_ls",
    "yamlls",
  }
})

vim.lsp.config("*", {
  on_attach = require("plugins.config.lsp.handlers").on_attach,
  capabilities = require("plugins.config.lsp.handlers").capabilities,
})
