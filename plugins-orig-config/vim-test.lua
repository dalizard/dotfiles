local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.keymap.set

keymap("n", "<leader>s", "<cmd>TestNearest<cr>", opts)
keymap("n", "<leader>f", "<cmd>TestFile<cr>", opts)
keymap("n", "<leader>a", "<cmd>TestSuite<cr>", opts)
keymap("n", "<leader>l", "<cmd>TestLast<cr>", opts)
keymap("n", "<leader>v", "<cmd>TestVisit<cr>", opts)

vim.cmd([[
  function! TestRunner(cmd) abort
    let term_position = get(g:, 'test#neovim#term_position', 'botright')

    let opts = {'suffix': ' # vim-test'}

    function! opts.on_exit(job_id, exit_code, event)
      if a:exit_code == 0
        call self.close_terminal()
      endif
    endfunction

    function! opts.close_terminal()
      if bufnr(self.suffix) != -1
        execute 'bdelete!' bufnr(self.suffix)
      end
    endfunction

    call opts.close_terminal()

    execute term_position . ' new'
    call termopen(a:cmd . opts.suffix, opts)
    au BufDelete <buffer> wincmd p
    normal! G
    wincmd p
  endfunction

  let g:test#custom_strategies = {'testrunner': function('TestRunner')}
  let g:test#strategy = 'testrunner'
  let test#neovim#term_position = "vert botright"
]])
