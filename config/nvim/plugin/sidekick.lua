-- ABOUTME: Configures sidekick.nvim for AI CLI integration.
-- ABOUTME: Deferred to after startup with keymaps for toggle, select, send.

vim.schedule(function()
  vim.pack.add({ 'https://github.com/folke/sidekick.nvim' })

  require('sidekick').setup({
    cli = {
      mux = {
        backend = "tmux",
        enabled = false,
      },
    },
  })

  local keymap = require('utils').keymap
  keymap({ "n", "t", "i", "x" }, "<M-q>", function() require("sidekick.cli").toggle() end, "Sidekick Toggle")
  keymap("n", "<leader>as", function() require("sidekick.cli").select({ filter = { installed = true } }) end, "Select CLI")
  keymap("n", "<leader>ad", function() require("sidekick.cli").close() end, "Detach a CLI Session")
  keymap({ "x", "n" }, "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end, "Send This")
  keymap("x", "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end, "Send Visual Selection")
  keymap({ "n", "x" }, "<leader>ap", function() require("sidekick.cli").prompt() end, "Sidekick Select Prompt")
end)
