return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      ruby = { "rubocop" },
    },
    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 3000,
      lsp_format = "fallback",
    },
  }
}
