local lspconfig = require 'lspconfig'

return {
  {
    filetypes = { 'go', 'gomod' },
  },
  {
    default_config = {
      cmd = { 'golangci-lint-langserver' },
      root_dir = lspconfig.util.root_pattern('.git', 'go.mod'),
      init_options = {
        command = { "golangci-lint", "run", "--enable-all", "--disable", "lll", "--out-format", "json", "--issues-exit-code=1" },
      }
    },
  }
}
