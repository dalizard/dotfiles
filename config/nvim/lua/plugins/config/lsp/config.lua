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
    "lua_ls",
    "pylsp",
    "rust_analyzer",
    "solargraph",
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
lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", require("plugins.config.lsp.settings.lua_ls"), defaults))
lspconfig.pylsp.setup(defaults)
lspconfig.rust_analyzer.setup(defaults)
lspconfig.solargraph.setup(defaults)
lspconfig.tsserver.setup(defaults)
lspconfig.yamlls.setup(defaults)
