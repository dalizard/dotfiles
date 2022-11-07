local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = {
    "clangd",
    "cssls",
    "dockerls",
    "gopls",
    "html",
    "jsonls",
    "rust_analyzer",
    "solargraph",
    "sqlls",
    "sumneko_lua",
    "tsserver",
    "yamlls",
  }
})

local defaults = {
  on_attach = require("plugins.config.lsp.handlers").on_attach,
  capabilities = require("plugins.config.lsp.handlers").capabilities,
}

lspconfig.clangd.setup(defaults)
lspconfig.cssls.setup(defaults)
lspconfig.dockerls.setup(defaults)
lspconfig.gopls.setup(defaults)
lspconfig.html.setup(defaults)
lspconfig.jsonls.setup(vim.tbl_deep_extend("force", require("plugins.config.lsp.settings.jsonls"), defaults))
lspconfig.rust_analyzer.setup(defaults)
lspconfig.solargraph.setup(defaults)
lspconfig.sqlls.setup(defaults)
lspconfig.sumneko_lua.setup(vim.tbl_deep_extend("force", require("plugins.config.lsp.settings.sumneko_lua"), defaults))
lspconfig.tsserver.setup(defaults)
lspconfig.yamlls.setup(defaults)
