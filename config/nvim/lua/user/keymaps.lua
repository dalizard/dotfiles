local opts = { noremap = true, silent = true }
local command_opts = { noremap = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

local utils = require "user.utils"

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Remap comma as leader key
keymap("", ",", "<nop>", opts)
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Use Alt and Ctrl keys in command mode
keymap("c", "<M-b>", "<S-Left>", command_opts)
keymap("c", "<M-f>", "<S-Right>", command_opts)
keymap("c", "<C-a>", "<C-b>", command_opts)

-- Leave terminal mode
keymap("t", "<esc>", "<C-\\><C-n>", term_opts)

-- Clear highlighted text
keymap("n", "<cr>", ":nohl<cr>", opts)

-- Disable Q
keymap("n", "Q", "<nop>", opts)

-- Forget about the damn arrow keys!
keymap({"n", "i", "v"}, "<Up>", "<nop>", opts)
keymap({"n", "i", "v"}, "<Down>", "<nop>", opts)
keymap({"n", "i", "v"}, "<Left>", "<nop>", opts)
keymap({"n", "i", "v"}, "<Right>", "<nop>", opts)
-- Esc is harder to reach
keymap("i", "<C-c>", "<esc>", opts)

-- Copy to clipboard
keymap("v", "<leader>y", '"+y', opts)
keymap("n", "<leader>y", '"+y', opts)
keymap("n", "<leader>Y", '"+g_', opts)
keymap("n", "<leader>yy", '"+yy', opts)

-- Expand current path
keymap("c", "%%", "<C-R>=expand('%:h').'/'<cr>", command_opts)

-- Telescope
keymap("n", "<C-j>", "<cmd>Telescope git_files<cr>", opts)
keymap("n", "<C-l>", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<C-k>", "<cmd>Telescope find_files no_ignore=true<cr>", opts)
keymap("n", "<C-f>", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<C-h>", "<cmd>Telescope grep_string<cr>", opts)

-- Copy current file path to clipboard
keymap("n", "<leader>yp", "<cmd>let @+ = expand('%')<cr>", opts)
