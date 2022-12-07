-- Disable the netrw plugin
vim.g.loaded_netrwPlugin = 1

local impatient_loaded, impatient = pcall(require, "impatient")
if impatient_loaded then
  impatient.enable_profile()
end

require "autocommands"
require "keymaps"
require "options"
require "plugins"
require "globals"
