local M = {}

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "󰅚" },
    { name = "DiagnosticSignWarn", text = "󰀪" },
    { name = "DiagnosticSignHint", text = "󰙎" },
    { name = "DiagnosticSignInfo", text = "󰋽" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  vim.diagnostic.config({
    virtual_text = {
      prefix = "",
    },
    signs = { active = signs },
    update_in_insert = false,
    underline = true,
    severity_sort = false,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = true,
      header = "",
      prefix = "",
    },
  })
end

local function lsp_keymaps(bufnr)
  local opts = { silent = true, remap = false, buffer = bufnr }

  -- Generate LSP functionality
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<cr>", opts)
  vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, opts)

  -- Navigate diagnotis errors/mesages
  vim.keymap.set("n", "]g", function() vim.diagnostic.jump({ count = 1, float = false }) end, opts)
  vim.keymap.set("n", "[g", function() vim.diagnostic.jump({ count = -1, float = false }) end, opts)

  -- Telescope helpers for listing symbols and diagnostics
  vim.keymap.set("n", "<leader>gs", "<cmd>Telescope lsp_document_symbols<cr>", opts)
  vim.keymap.set("n", "<leader>gd", "<cmd>Telescope diagnostics<cr>", opts)
end

M.on_attach = function(bufnr)
  lsp_keymaps(bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_lsp_loaded, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_lsp_loaded then
  M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

return M
