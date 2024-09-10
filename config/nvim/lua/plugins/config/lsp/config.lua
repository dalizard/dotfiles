local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

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

local defaults = {
  on_attach = require("plugins.config.lsp.handlers").on_attach,
  capabilities = require("plugins.config.lsp.handlers").capabilities,
}

mason_lspconfig.setup_handlers({
  function(server_name)
    if server_name == "jsonls" then
      defaults = vim.tbl_deep_extend("force", require("plugins.config.lsp.settings.jsonls"), defaults)
    end

    if server_name == "lua_ls" then
      defaults = vim.tbl_deep_extend("force", require("plugins.config.lsp.settings.lua_ls"), defaults)
    end

    if server_name == "solargraph" then
      defaults = vim.tbl_deep_extend("force", require("plugins.config.lsp.settings.solargraph"), defaults)
    end

    lspconfig[server_name].setup(defaults)
  end,
})
