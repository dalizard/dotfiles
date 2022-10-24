-- Disable the netrw plugin
vim.g.loaded_netrwPlugin = 1

local impatient_loaded, impatient = pcall(require, "impatient")
if impatient_loaded then
  impatient.enable_profile()
end

-- Remap comma as leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","

require "keymaps"
require "options"
require "plugins"
