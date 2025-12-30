return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      ruby = { "rubocop" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      vue = { "prettierd", "prettier", stop_after_first = true },
    },
    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 3000,
      lsp_format = "fallback",
    },
  }
}
