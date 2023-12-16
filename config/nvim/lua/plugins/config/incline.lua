local status_ok, incline = pcall(require, "incline")
if not status_ok then
  return
end

local colors = require("lagadath.palette")

incline.setup({
  highlight = {
    groups = {
      InclineNormal = { guibg = colors.highlight_med, guifg = colors.text },
      InclineNormalNC = { guibg = colors.highlight_low, guifg = colors.text }
    },
  },
  window = {
    margin = { vertical = 0, horizontal = 1 },
  },
  hide = {
    cursorline = true
  },
})
