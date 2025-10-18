local utils = require('utils')

local autoCommands = {
  filetype = {
    -- Set filetype for all slim files
    { "BufNewFile,BufRead", "*.slim", "set ft=slim" }
  }
}

utils.create_autocmds(autoCommands)
