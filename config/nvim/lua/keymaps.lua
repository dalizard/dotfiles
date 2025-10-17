local utils = require('utils')

-- Save with W as well
vim.api.nvim_create_user_command('W', 'w', {})

-- No cursor jumps on highlighting
utils.keymap("n", "#", "<cmd>keepjumps normal! mi*`i<cr>")

-- Make command mode navigation more like the shell
utils.keymap("c", "<M-b>", "<S-Left>")
utils.keymap("c", "<M-f>", "<S-Right>")
utils.keymap("c", "<C-a>", "<Home>")
utils.keymap("c", "<C-e>", "<End>")
utils.keymap("c", "<C-f>", "<Right>")
utils.keymap("c", "<C-b>", "<Left>")

-- Clear highlighted text
utils.keymap("n", "<cr>", ":nohl<cr>")

-- Disable Q
utils.keymap("n", "Q", "<nop>")

--- Leave terminal mode
utils.keymap("t", "<esc>", "<C-\\><C-n>", "Leave terminal mode")

-- Forget about the damn arrow keys!
utils.keymap({ "n", "i", "v" }, "<Up>", "<nop>")
utils.keymap({ "n", "i", "v" }, "<Down>", "<nop>")
utils.keymap({ "n", "i", "v" }, "<Left>", "<nop>")
utils.keymap({ "n", "i", "v" }, "<Right>", "<nop>")

-- Esc is harder to reach
utils.keymap("i", "<C-c>", "<esc>")

-- Copy to clipboard
utils.keymap("v", "<leader>y", '"+y', "Copy to system clipboard")
utils.keymap("n", "<leader>y", '"+y', "Copy to system lipboard")
utils.keymap("n", "<leader>Y", '"+g_', "Copy to system clipboard")
-- utils.keymap("n", "<leader>yy", '"+yy', opts) TODO: Do I need this?

-- Expand current path
utils.keymap("c", "%%", "<C-R>=expand('%:h').'/'<cr>", "Expand current path")

-- Copy current file path to clipboard
utils.keymap("n", "<leader>fc", "<cmd>let @+ = expand('%:~:.')<cr>", "Copy file path to clipboard")

-- Easy theme reload
utils.keymap("n", "<leader>r", "<cmd>colorscheme lagadath<cr>", "Reload theme")

-- Move visual text easily
utils.keymap("v", "J", ":m '>+1<cr>gv=gv")
utils.keymap("v", "K", ":m '<-2<cr>gv=gv")

-- Toggle diagnostics virtual text
local _show_virtual_text = true
utils.keymap("n", "<leader>gv", function()
  if _show_virtual_text then
    vim.diagnostic.show(nil, nil, nil, { virtual_text = false })
    _show_virtual_text = false
  else
    vim.diagnostic.show(nil, nil, nil, { virtual_text = true })
    _show_virtual_text = true
  end
end, "Toggle diagnostic virtual text")

-- Create missing directories in a path
utils.keymap("n", "<leader>m", ":call mkdir(expand('%:p:h'), 'p')<cr>")
