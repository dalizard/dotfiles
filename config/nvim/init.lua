-- Disable the netrw plugin
vim.g.loaded_netrwPlugin = 1

local impatient_loaded, impatient = pcall(require, "impatient")
if impatient_loaded then
  impatient.enable_profile()
end

-- This needs to be initialized before LSP
require "user.mason"

--require "user.neotest"
require "user.autocommands"
require "user.autopairs"
require "user.cmp"
require "user.gitsigns"
require "user.gruvbox"
require "user.lsp"
require "user.lualine"
require "user.nvim-tree"
require "user.options"
require "user.plugins"
require "user.telescope"
require "user.treesitter"
require "user.vim-test"
require "user.keymaps"
