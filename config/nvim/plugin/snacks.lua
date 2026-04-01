-- ABOUTME: Configures snacks.nvim for file picking, grep, explorer, and notifications.
-- ABOUTME: Loaded eagerly as a core UI component.

vim.pack.add({ 'https://github.com/folke/snacks.nvim' })

require('snacks').setup({
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
})

local keymap = require('utils').keymap
keymap("n", "<C-j>", function() Snacks.picker.files({ layout = { preview = false } }) end, "Find Files")
keymap("n", "<C-f>", function() Snacks.picker.buffers({ layout = { preview = false } }) end, "Buffers")
keymap("n", "<C-l>", function() Snacks.picker.grep() end, "Grep")
keymap({ "n", "x" }, "<C-h>", function() Snacks.picker.grep_word() end, "Visual selection or word")
keymap("n", "<leader>e", function() Snacks.explorer() end, "File Explorer")
keymap("n", "<leader>ch", function() Snacks.picker.command_history() end, "Command History")
keymap("n", "<leader>.", function() Snacks.scratch() end, "Toggle Scratch Buffer")
keymap("n", "<leader>S", function() Snacks.scratch.select() end, "Select Scratch Buffer")
