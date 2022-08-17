local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Remap comma as leader key
keymap("n", ",", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Use Alt and Ctrl keys in command mode
keymap("c", "<M-b>", "<S-Left>", opts)
keymap("c", "<M-f>", "<S-Right>", opts)
keymap("c", "<C-a>", "<C-b>", opts)
