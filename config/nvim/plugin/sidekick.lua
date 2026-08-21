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

  -- `nvim_open_win` ignores 'equalalways' for splits, so the neighbouring window
  -- gives up the sidekick's full width instead of the cost being shared. Equalize
  -- whenever a sidekick window appears or goes away; `winfixwidth` keeps its size.
  local group = vim.api.nvim_create_augroup('sidekick_equalize', { clear = true })
  local sidekick_wins = {}

  vim.api.nvim_create_autocmd('WinNew', {
    group = group,
    callback = function()
      vim.schedule(function()
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          if vim.w[win].sidekick_session_id and not sidekick_wins[win] then
            sidekick_wins[win] = true
            vim.api.nvim_win_call(win, function() vim.cmd.wincmd('=') end)
            return
          end
        end
      end)
    end,
  })

  vim.api.nvim_create_autocmd('WinClosed', {
    group = group,
    callback = function(ev)
      local win = tonumber(ev.match)
      if sidekick_wins[win] then
        sidekick_wins[win] = nil
        vim.schedule(function() vim.cmd.wincmd('=') end)
      end
    end,
  })

  local keymap = require('utils').keymap
  keymap({ "n", "t", "i", "x" }, "<M-q>", function() require("sidekick.cli").toggle() end, "Sidekick Toggle")
  keymap("n", "<leader>as", function() require("sidekick.cli").select({ filter = { installed = true } }) end, "Select CLI")
  keymap("n", "<leader>ad", function() require("sidekick.cli").close() end, "Detach a CLI Session")
  keymap({ "x", "n" }, "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end, "Send This")
  keymap("x", "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end, "Send Visual Selection")
  keymap({ "n", "x" }, "<leader>ap", function() require("sidekick.cli").prompt() end, "Sidekick Select Prompt")
end)
