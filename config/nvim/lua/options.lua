local home_dir = vim.fn.expand("~/")

local options = {
  autoindent = true, -- Copy indent from current line when starting a new line
  autoread = true, -- watch out for file changes
  background = os.getenv("COLOR_THEME"), -- Set the background dynamically
  backup = false, -- creates a backup file
  breakindent = true, -- show wrapped lines visually indented
  cmdheight = 1, -- more space in the neovim command line for displaying messages
  completeopt = { "menu", "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0, -- so that `` is visible in markdown files
  cursorline = true, -- highlight the current line
  directory = { home_dir .. ".nvim/_temp" }, -- set the temp directory
  expandtab = true, -- convert tabs to spaces
  fileencoding = "utf-8", -- the encoding written to a file
  hidden = true, -- allow unsaved background buffers and remember marks/undo for them
  history = 10000, -- lines to keep in history
  hlsearch = true, -- highlight all matches on previous search pattern
  ignorecase = true, -- ignore case in search patterns
  laststatus = 2, -- always show a status line for the last window
  list = true, -- show invisible characters
  modelines = 1, -- no lines are checked for set commands
  mouse = "a", -- enable mouse for all modes
  number = false, -- do not show line numbers
  numberwidth = 4, -- set number column width to 2 {default 4}
  pumheight = 10, -- pop up menu height
  relativenumber = false, -- set relative numbered lines
  ruler = false, -- do not show the ruler
  scrolloff = 3, -- have some context around the current line alwaus on screen
  shell = "dash", -- use dash because of speed
  shiftwidth = 2, -- the number of spaces inserted for each indentation
  showcmd = false,
  showmode = false, -- we don't need to see things like -- INSERT -- anymore
  showtabline = 0, -- never show tabs
  sidescrolloff = 8,
  signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
  smartcase = true, -- smart case
  smartindent = true, -- make indenting smarter again
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = false, -- force all vertical splits to go to the left of current window
  swapfile = false, -- creates a swapfile
  tabstop = 2, -- insert 2 spaces for a tab
  termguicolors = true, -- set term gui colors (most terminals support this)
  timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in milliseconds)
  title = true, -- show window title
  undodir = { home_dir .. ".nvim/_undo" }, -- set the undo directory
  undofile = true, -- enable persistent undo
  updatetime = 250, -- faster completion (4000ms default)
  wrap = true, -- display lines as one long line
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- No tildas in the sidebar
vim.opt.fillchars = vim.opt.fillchars + 'eob: '
vim.opt.fillchars:append {
  stl = ' ',
}

-- Do not show ins-completion messages
vim.opt.shortmess:append "c"

-- Disable intro message
vim.opt.shortmess:append "I"

-- Use ripgrep instead of grep
vim.opt.grepprg = "rg"
vim.opt.grepformat = "%f:%l:%c:%m"
