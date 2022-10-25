-- Bootstrap packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
  print "Installing packer - close and reopen Neovim"
  vim.cmd([[packadd packer.nvim]])
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
  use {
    "williamboman/mason.nvim",
    config = function() require("plugins.config.mason") end
  }
  use {
    "williamboman/mason-lspconfig.nvim",
    after = "mason.nvim"
  }
  use {
    "neovim/nvim-lspconfig",
    config = function() require("plugins.config.lsp") end,
    after = "mason-lspconfig.nvim"
  }

  -- Completion
  use {
    "hrsh7th/nvim-cmp", -- core plugin
    config = function() require("plugins.config.cmp") end
  }
  use "hrsh7th/cmp-buffer" -- completes words from the current buffer
  use "hrsh7th/cmp-nvim-lsp" -- LSP support
  use "hrsh7th/cmp-nvim-lua" -- neovim Lua completion
  use "hrsh7th/cmp-path" -- complete files
  use "saadparwaiz1/cmp_luasnip"

  -- Syntax/Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    config = function() require("plugins.config.treesitter") end
  }

  -- Fuzzy Finder/Telescope
  use {
    "nvim-telescope/telescope.nvim",
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = function() require("plugins.config.telescope") end
  }
  use "nvim-telescope/telescope-file-browser.nvim"
  use {
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
  }

  -- Snippet
  use "L3MON4D3/LuaSnip"

  -- Colorscheme
  use {
    "ellisonleao/gruvbox.nvim",
    config = function() require("plugins.config.gruvbox") end
  }
  use {
    "kyazdani42/nvim-web-devicons",
    config = function() require("plugins.config.nvim-web-devicons") end
  }

  -- Statusline
  use {
    "nvim-lualine/lualine.nvim",
    config = function() require("plugins.config.lualine") end
  }

  -- Git
  use {
    "lewis6991/gitsigns.nvim",
    config = function() require("plugins.config.gitsigns") end
  }
  use "tpope/vim-fugitive"
  use "tpope/vim-rhubarb"

  -- Tests
  use {
    "vim-test/vim-test",
    config = function() require("plugins.config.vim-test") end
  }

  -- Ruby on Rails
  use "tpope/vim-rails"

  -- File Explorer
  use {
    "kyazdani42/nvim-tree.lua",
    config = function() require("plugins.config.nvim-tree") end
  }

  -- Editing Support
  use {
    "windwp/nvim-autopairs",
    config = function() require("plugins.config.autopairs") end
  }

  -- Utility
  use "lewis6991/impatient.nvim"
  use {
    "kylechui/nvim-surround",
    config = function() require("plugins.config.nvim-surround") end
  }

  use {
    "norcalli/nvim-colorizer.lua",
    config = function() require("plugins.config.nvim-colorizer") end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Keep this at the end
  if packer_bootstrap then
    require('packer').sync()
  end
end)
