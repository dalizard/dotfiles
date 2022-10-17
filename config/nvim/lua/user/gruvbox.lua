local status_ok, gruvbox = pcall(require, "gruvbox")
if not status_ok then
  return
end

local colors = require "gruvbox.palette"

gruvbox.setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = true,
  invert_selection = false,
  invert_tabline = true,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  overrides = {
    GruvboxAquaSign = { bg = "NONE" },
    GruvboxBlueSign = { bg = "NONE" },
    GruvboxGreenSign = { bg = "NONE" },
    GruvboxOrangeSign = { bg = "NONE" },
    GruvboxPurpleSign = { bg = "NONE" },
    GruvboxRedSign = { bg = "NONE" },
    GruvboxYellowSign = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
  },
})

vim.cmd("colorscheme gruvbox")
vim.cmd [[
  hi link schemeIdentifier NONE
  hi link schemeParentheses NONE
]]
