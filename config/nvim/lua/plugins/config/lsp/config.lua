local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = {
    "bashls",
    "clangd",
    "cssls",
    "dockerls",
    "gopls",
    "html",
    "jsonls",
    "lua_ls",
    "pylsp",
    "ruby_ls",
    "rust_analyzer",
    "tailwindcss",
    "tsserver",
    "yamlls",
  }
})

local defaults = {
  on_attach = require("plugins.config.lsp.handlers").on_attach,
  capabilities = require("plugins.config.lsp.handlers").capabilities,
}

lspconfig.bashls.setup(defaults)
lspconfig.clangd.setup(defaults)
lspconfig.cssls.setup(defaults)
lspconfig.dockerls.setup(defaults)
lspconfig.gopls.setup(defaults)
lspconfig.html.setup(defaults)
lspconfig.jsonls.setup(vim.tbl_deep_extend("force", require("plugins.config.lsp.settings.jsonls"), defaults))
lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", require("plugins.config.lsp.settings.lua_ls"), defaults))
lspconfig.pylsp.setup(defaults)
lspconfig.ruby_ls.setup({
  on_attach = function(client, buffer)
    if require("vim.lsp.diagnostic")._enable then
      return
    end
    local timers = {}

    local diagnostic_handler = function()
      local params = vim.lsp.util.make_text_document_params(buffer)
      client.request("textDocument/diagnostic", { textDocument = params }, function(err, result)
        if err then
          local err_msg = string.format("diagnostics error - %s", vim.inspect(err))
          vim.lsp.log.error(err_msg)
        end
        if not result then
          return
        end
        vim.lsp.diagnostic.on_publish_diagnostics(
          nil,
          vim.tbl_extend("keep", params, { diagnostics = result.items }),
          { client_id = client.id }
        )
      end)
    end

    diagnostic_handler() -- to request diagnostics on buffer when first attaching

    vim.api.nvim_buf_attach(buffer, false, {
      on_lines = function()
        if timers[buffer] then
          vim.fn.timer_stop(timers[buffer])
        end
        timers[buffer] = vim.fn.timer_start(200, diagnostic_handler)
      end,
      on_detach = function()
        if timers[buffer] then
          vim.fn.timer_stop(timers[buffer])
        end
      end,
    })
    local opts = { silent = true, remap = false, buffer = buffer }
    vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, opts)
  end,
})
lspconfig.rust_analyzer.setup(defaults)
lspconfig.tsserver.setup(defaults)
lspconfig.yamlls.setup(defaults)
