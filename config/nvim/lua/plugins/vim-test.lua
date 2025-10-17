local utils = require('utils')

return {
  "vim-test/vim-test",
  config = function()
    local opts = { noremap = true, silent = true }

    utils.keymap("n", "<leader>ts", "<cmd>TestNearest<cr>", "Run nearest test", opts)
    utils.keymap("n", "<leader>tf", "<cmd>TestFile<cr>", "Run test file", opts)
    utils.keymap("n", "<leader>ta", "<cmd>TestSuite<cr>", "Run test suite", opts)
    utils.keymap("n", "<leader>tl", "<cmd>TestLast<cr>", "Run last test", opts)
    utils.keymap("n", "<leader>tv", "<cmd>TestVisit<cr>", "Visit test file from last run", opts)

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
  end
}
