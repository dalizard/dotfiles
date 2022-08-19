local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

keymap("n", "<leader>t", ":!erlc -DTEST %; erl -noshell -pa . -eval 'eunit:test(%:r, [verbose])' -s init stop<cr>", opts)
keymap("n", "<leader>e :sp\|:term erlc %; erl -pa .<cr>\|:startins<cr>", opts)
