return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    { "<C-j>",      function() Snacks.picker.files({ layout = { preview = false } }) end,   desc = "Find Files" },
    { "<C-f>",      function() Snacks.picker.buffers({ layout = { preview = false } }) end, desc = "Buffers" },
    { "<C-l>",      function() Snacks.picker.grep() end,                                    desc = "Grep" },
    { "<C-h>",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
    { "<leader>e",  function() Snacks.explorer() end,                                       desc = "File Explorer" },
    { "<leader>ch", function() Snacks.picker.command_history() end,                         desc = "Command History" },
    { "<leader>.",  function() Snacks.scratch() end,                                        desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end,                                 desc = "Select Scratch Buffer" },
  },
  opts = {
    styles = {
      scratch = {
        width = 0.8,
        height = 0.8,
      }
    },
    input = {
      enabled = true,
    },
    notifier = {
      enabled = true,
    },
    explorer = {
      replace_netrw = true,
    },
    picker = {
      enabled = true,
      exclude = {
        ".git",
        "node_modules",
      },
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
