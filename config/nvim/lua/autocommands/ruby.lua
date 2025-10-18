local utils = require('utils')

local autoCommands = {
  ruby = {
    -- Disable tree-sitter re-indentation for `.`
    { "FileType", "ruby", "setlocal indentkeys=-." }
  }
}

utils.create_autocmds(autoCommands)
