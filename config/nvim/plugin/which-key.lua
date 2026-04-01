-- ABOUTME: Configures which-key for keymap discovery popup.
-- ABOUTME: Deferred to after startup.

vim.schedule(function()
  vim.pack.add({ 'https://github.com/folke/which-key.nvim' })

  require('which-key').setup({
    delay = 500
  })

  vim.keymap.set("n", "<leader>?", function()
    require("which-key").show({ global = false })
  end, { desc = "Buffer Local Keymaps (which-key)" })
end)
