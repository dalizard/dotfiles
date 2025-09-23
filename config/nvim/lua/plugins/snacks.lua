return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    { "<C-j>", function() Snacks.picker.files({ layout = { preview = false } }) end,   desc = "Find Files" },
    { "<C-f>", function() Snacks.picker.buffers({ layout = { preview = false } }) end, desc = "Buffers" },
    { "<C-l>", function() Snacks.picker.grep() end,                                    desc = "Grep" },
    { "<C-h>", function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
  },
  opts = {
    input = {
      enabled = true,
    },
    notifier = {
      enabled = true,
    },
    picker = {
      enabled = true,
      layout = { preset = "telescope", preview = true },
      formatters = {
        file = {
          truncate = 80
        },
      },
      win = {
        preview = {
          wo = {
            number = false,
            relativenumber = false,
            signcolumn = "no"
          }
        }
      }
    }
  }
}
