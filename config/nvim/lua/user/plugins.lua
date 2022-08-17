-- Bootstrap packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  print "Installing packer - close and reopen Neovim"
  vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  -- snapshot = "August 17, 2022",
  snapshot_path = fn.stdpath "config" .. "/snapshots",
  max_jobs = 50,
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
    prompt_border = "rounded", -- Border style of prompt popups.
  },
}

return packer.startup(function(use)
  -- Plugin Manager
  use "wbthomason/packer.nvim" -- have packer manage itself

  -- LSP
  use "neovim/nvim-lspconfig"
  use "williamboman/mason-lspconfig.nvim"
  use "williamboman/mason.nvim"

  -- Completion
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-path"
  use "hrsh7th/nvim-cmp"

  -- Syntax/Treesitter
  use "nvim-treesitter/nvim-treesitter"

  -- Fuzzy finder/Telescope
  use {
    "nvim-telescope/telescope.nvim",
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
  }


  -- Colorscheme
  use "ellisonleao/gruvbox.nvim"

  -- Statusline
  use "nvim-lualine/lualine.nvim"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Keep this at the end
  if packer_bootstrap then
    require('packer').sync()
  end
end)
