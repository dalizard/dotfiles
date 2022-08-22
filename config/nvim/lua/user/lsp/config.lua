local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = {
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
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}

lspconfig.cssls.setup(defaults)
lspconfig.dockerls.setup(defaults)
lspconfig.gopls.setup(defaults)
lspconfig.html.setup(defaults)
lspconfig.jsonls.setup(vim.tbl_deep_extend("force", require("user.lsp.settings.jsonls"), defaults))
lspconfig.rust_analyzer.setup(defaults)
lspconfig.solargraph.setup(vim.tbl_deep_extend("force", require("user.lsp.settings.solargraph"), defaults))
lspconfig.sqlls.setup(defaults)
lspconfig.sumneko_lua.setup(vim.tbl_deep_extend("force", require("user.lsp.settings.sumneko_lua"), defaults))
lspconfig.tsserver.setup(defaults)
lspconfig.yamlls.setup(defaults)
