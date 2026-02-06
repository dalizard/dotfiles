-- Disable the netrw plugin
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require "config.lazy"
require "keymaps"
require "autocommands"
require "options"
require "globals"
require "commands"
