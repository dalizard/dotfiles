local utils = require('utils')

local autoCommands = {
  formatting = {
    -- Only show cursorline in the current window and in normal mode
    { "WinLeave,InsertEnter", "*", "setlocal nocursorline" },
    { "WinEnter,InsertLeave", "*", "setlocal cursorline" },

    -- Disable automatic comment insertion
    { "FileType", "*", function()
      vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end }
  },
}

utils.create_autocmds(autoCommands)
