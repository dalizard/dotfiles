local opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Remap comma as leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Save with W as well
vim.api.nvim_create_user_command('W', 'w', {})

-- No cursor jumps on highlighting
keymap("n", "#", "<cmd>keepjumps normal! mi*`i<cr>", opts)

-- Use Alt and Ctrl keys in command mode
keymap("c", "<M-b>", "<S-Left>", opts)
keymap("c", "<M-f>", "<S-Right>", opts)
keymap("c", "<C-a>", "<C-b>", opts)

-- Leave terminal mode
keymap("t", "<esc>", "<C-\\><C-n>", opts)

-- Clear highlighted text
keymap("n", "<cr>", ":nohl<cr>", opts)

-- Disable Q
keymap("n", "Q", "<nop>", opts)

-- Forget about the damn arrow keys!
keymap({ "n", "i", "v" }, "<Up>", "<nop>", opts)
keymap({ "n", "i", "v" }, "<Down>", "<nop>", opts)
keymap({ "n", "i", "v" }, "<Left>", "<nop>", opts)
keymap({ "n", "i", "v" }, "<Right>", "<nop>", opts)

-- Esc is harder to reach
keymap("i", "<C-c>", "<esc>", opts)

-- Copy to clipboard
keymap("v", "<leader>y", '"+y', opts)
keymap("n", "<leader>y", '"+y', opts)
keymap("n", "<leader>Y", '"+g_', opts)
keymap("n", "<leader>yy", '"+yy', opts)

-- Expand current path
keymap("c", "%%", "<C-R>=expand('%:h').'/'<cr>", opts)

-- Telescope
keymap("n", "<C-j>", "<cmd>Telescope git_files<cr>", opts)
keymap("n", "<C-l>", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<C-k>", "<cmd>Telescope find_files no_ignore=true<cr>", opts)
keymap("n", "<C-f>", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<C-h>", "<cmd>Telescope grep_string<cr>", opts)
keymap("n", "<C-b>", "<cmd>Telescope file_browser<cr>", opts)

-- Copy current file path to clipboard
keymap("n", "<leader>yp", "<cmd>let @+ = expand('%')<cr>", opts)

-- File browser
keymap("n", "<leader>b", "<cmd>NvimTreeToggle<cr>", opts)

-- Treesitter playground
keymap("n", "<leader>q", "<cmd>TSHighlightCapturesUnderCursor<cr>", opts)

-- Easy theme reload
keymap("n", "<leader>r", "<cmd>colorscheme lagadath<cr>", opts)
