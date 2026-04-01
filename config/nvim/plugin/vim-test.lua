-- ABOUTME: Configures vim-test with a custom terminal test runner.
-- ABOUTME: Provides keymaps for running nearest, file, suite, and last tests.

vim.pack.add({ 'https://github.com/vim-test/vim-test' })

local utils = require('utils')

utils.keymap("n", "<leader>ts", "<cmd>TestNearest<cr>", "Run nearest test")
utils.keymap("n", "<leader>tf", "<cmd>TestFile<cr>", "Run test file")
utils.keymap("n", "<leader>ta", "<cmd>TestSuite<cr>", "Run test suite")
utils.keymap("n", "<leader>tl", "<cmd>TestLast<cr>", "Run last test")
utils.keymap("n", "<leader>tv", "<cmd>TestVisit<cr>", "Visit test file from last run")

local suffix = ' # vim-test'

local function close_terminal()
  local bufnr = vim.fn.bufnr(suffix)
  if bufnr ~= -1 then
    vim.cmd('bdelete! ' .. bufnr)
  end
end

local function test_runner(cmd)
  local term_position = vim.g['test#neovim#term_position'] or 'botright'

  close_terminal()

  vim.cmd(term_position .. ' new')
  vim.fn.termopen(cmd .. suffix, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        close_terminal()
      end
    end
  })
  vim.api.nvim_create_autocmd('BufDelete', {
    buffer = 0,
    once = true,
    command = 'wincmd p',
  })
  vim.cmd('normal! G')
  vim.cmd('wincmd p')
end

vim.g['test#custom_strategies'] = { testrunner = test_runner }
vim.g['test#strategy'] = 'testrunner'
vim.g['test#neovim#term_position'] = 'vert botright'
