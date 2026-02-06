return {
  filetypes = { 'go', 'gomod' },
  cmd = { 'golangci-lint-langserver' },
  root_markers = { '.git', 'go.mod' },
  init_options = {
    command = { "golangci-lint", "run", "--enable-all", "--disable", "lll", "--out-format", "json", "--issues-exit-code=1" },
  },
}
