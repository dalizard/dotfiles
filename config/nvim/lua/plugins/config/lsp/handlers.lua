local M = {}

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  vim.diagnostic.config({
    virtual_text = false,
    signs = { active = signs },
    update_in_insert = true,
    underline = false,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

local function lsp_keymaps(bufnr)
  local opts = { silent = true, remap = false, buffer = bufnr }

  -- Generate LSP functionality
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, opts)

  -- Navigate diagnotis errors/mesages
  vim.keymap.set("n", "]g", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, opts)

  -- Telescope helpers for listing symbols and diagnostics
  vim.keymap.set("n", "<leader>gs", "<cmd>Telescope lsp_document_symbols<cr>", opts)
  vim.keymap.set("n", "<leader>gd", "<cmd>Telescope diagnostics<cr>", opts)
end

M.on_attach = function(_, bufnr)
  lsp_keymaps(bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_lsp_loaded, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_lsp_loaded then
  M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

return M
