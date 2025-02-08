-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- LSP
  {
    "williamboman/mason.nvim",
    config = function() require("plugins.config.mason") end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "mason.nvim"
  },
  {
    "neovim/nvim-lspconfig",
    config = function() require("plugins.config.lsp") end,
    dependencies = "mason-lspconfig.nvim"
  },
  -- Completion
  {
    "hrsh7th/nvim-cmp", -- core plugin
    config = function() require("plugins.config.cmp") end
  },
  "hrsh7th/cmp-buffer",   -- completes words from the current buffer
  "hrsh7th/cmp-nvim-lsp", -- LSP support
  "hrsh7th/cmp-nvim-lua", -- neovim Lua completion
  "hrsh7th/cmp-path",     -- complete files
  "saadparwaiz1/cmp_luasnip",
  {
    "zbirenbaum/copilot-cmp",
    config = function() require("plugins.config.copilot-cmp") end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function() require("plugins.config.copilot") end
  },
  -- Syntax/Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
    config = function() require("plugins.config.treesitter") end
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter"
  },
  "nvim-treesitter/playground",
  -- Fuzzy Finder/Telescope
  {
    "nvim-telescope/telescope.nvim",
    build = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    dependencies = "nvim-lua/plenary.nvim",
    config = function() require("plugins.config.telescope") end
  },
  "nvim-telescope/telescope-file-browser.nvim",
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build =
    "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
  },
  -- Snippet
  "L3MON4D3/LuaSnip",
  -- Colorscheme
  "dalizard/lagadath",
  {
    "nvim-tree/nvim-web-devicons",
    config = function() require("plugins.config.nvim-web-devicons") end
  },
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    config = function() require("plugins.config.lualine") end
  },
  { 'AndreM222/copilot-lualine' },
  -- Git
  {
    "lewis6991/gitsigns.nvim",
    config = function() require("plugins.config.gitsigns") end
  },
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  -- Tests
  {
    "vim-test/vim-test",
    config = function() require("plugins.config.vim-test") end
  },
  -- Ruby on Rails
  "tpope/vim-rails",
  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    config = function() require("plugins.config.nvim-tree") end
  },
  -- Editing Support
  {
    "windwp/nvim-autopairs",
    config = function() require("plugins.config.autopairs") end
  },
  -- Utility
  {
    "kylechui/nvim-surround",
    config = function() require("plugins.config.nvim-surround") end
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = function() require("plugins.config.nvim-colorizer") end
  },
  {
    "euclio/vim-markdown-composer",
    build = 'cargo build --release',
    config = function() require("plugins.config.vim-markdown-composer") end
  },
  {
    "b0o/incline.nvim",
    dependencies = "dalizard/lagadath",
    event = "BufReadPre",
    priority = 1200,
    config = function() require("plugins.config.incline") end
  },
})
