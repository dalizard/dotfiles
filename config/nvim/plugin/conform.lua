-- ABOUTME: Configures conform.nvim for code formatting.
-- ABOUTME: Supports rubocop, prettierd/prettier formatters with format-on-save.

vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })

require('conform').setup({
  formatters_by_ft = {
    ruby = { "rubocop" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    vue = { "prettierd", "prettier", stop_after_first = true },
  },
  format_on_save = {
    timeout_ms = 3000,
    lsp_format = "fallback",
  },
})
