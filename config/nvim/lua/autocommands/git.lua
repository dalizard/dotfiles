local utils = require('utils')

local autoCommands = {
  git = {
    -- Browse the commit under cursor
    { "FileType", "fugitiveblame", function()
      vim.keymap.set("n", "<leader>gb", function()
        vim.cmd("execute ':GBrowse ' .. vim.fn.expand('<cword>')")
      end, { desc = "Browse commit under cursor" })
    end }
  }
}

utils.create_autocmds(autoCommands)
