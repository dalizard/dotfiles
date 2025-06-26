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
    "vue_ls",
    "yamlls",
  }
})

vim.lsp.config("*", {
  capabilities = require("plugins.config.lsp.handlers").capabilities,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach-config", { clear = true }),
  callback = function(ev)
    require("plugins.config.lsp.handlers").on_attach(ev.buf)
  end
})
