local utils = require('utils')

local autoCommands = {
  general = {
    -- Return to last edit position when opening files
    { "BufReadPost", "*", function()
      if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") and
          vim.bo.filetype ~= 'gitcommit' then
        vim.fn.setpos('.', vim.fn.getpos("'\""))
        vim.cmd("normal! g`\"")
      end
    end }
  }
}

utils.create_autocmds(autoCommands)
