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
  function(server_name) -- default handler
    require("lspconfig")[server_name].setup(defaults)
  end,

  ["jsonls"] = function()
    local options = vim.tbl_deep_extend("force", require("plugins.config.lsp.settings.jsonls"), defaults)
    lspconfig.jsonls.setup(options)
  end,

  ["lua_ls"] = function()
    local options = vim.tbl_deep_extend("force", require("plugins.config.lsp.settings.lua_ls"), defaults)
    lspconfig.lua_ls.setup(options)
  end,

  ["solargraph"] = function()
    local options = vim.tbl_deep_extend("force", require("plugins.config.lsp.settings.solargraph"), defaults)
    lspconfig.solargraph.setup(options)
  end,

  ["golangci_lint_ls"] = function()
    local configs = require 'lspconfig/configs'
    local options = require("plugins.config.lsp.settings.golangci_lint_ls")
    local config, lsp_config  = unpack(options)

    if not configs.golangcilsp then
      configs.golangcilsp = lsp_config
    end

    lspconfig.golangci_lint_ls.setup(config)
  end
})
