return {
  settings = {
    Solargraph = {
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern("Foovar", ".git")(fname) or vim.fn.getcwd()
      end
    },
  },
}
