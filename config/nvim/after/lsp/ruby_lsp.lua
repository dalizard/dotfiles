return {
  filetypes = { "ruby" },

  cmd = { "mise x -- ruby-lsp" },

  root_markers = { "Gemfile", ".git" },

  init_options = {
    formatter = 'standard',
    linters = { 'standard' },
    addonSettings = {
      ["Ruby LSP Rails"] = {
        enablePendingMigrationsPrompt = false,
      },
    },
  },
}
