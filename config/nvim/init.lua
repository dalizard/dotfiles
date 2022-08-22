local impatient_loaded, impatient = pcall(require, "impatient")
if impatient_loaded then
  impatient.enable_profile()
end

require "autocommands"

-- This needs to be initialized before LSP
require "user.mason"

require "user.autopairs"
require "user.cmp"
require "user.gitsigns"
require "user.gruvbox"
require "user.keymaps"
require "user.lualine"
require "user.lsp"
require "user.neotest"
require "user.nvim-tree"
require "user.options"
require "user.plugins"
require "user.telescope"
require "user.treesitter"
