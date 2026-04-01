vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Installation hooks must be registered before any vim.pack.add() call so that
-- lockfile bootstrapping on a fresh machine doesn't miss them.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'LuaSnip' then
      vim.fn.system({ 'make', '-C', ev.data.path, 'install_jsregexp' })
    elseif name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end
})

-- Local dev plugins (not managed by vim.pack)
vim.opt.rtp:prepend(vim.fn.expand("~/Code/lagadath"))

require "options"
require "keymaps"
require "autocommands"
require "globals"
require "commands"
