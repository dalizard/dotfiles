-- ABOUTME: Configures nvim-treesitter with async parser loading and highlighting.
-- ABOUTME: Includes treesitter-context and treesitter-textobjects.

vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
})

-- nvim-treesitter (main branch) stores queries in runtime/queries/ instead of
-- queries/ at the repo root. Add the runtime/ subdirectory to rtp so Neovim
-- can find highlight/indent/fold queries for all languages.
for _, plug in ipairs(vim.pack.get()) do
  if plug.spec.name == 'nvim-treesitter' then
    vim.opt.rtp:append(plug.path .. '/runtime')
    break
  end
end

require('treesitter-context').setup({
  max_lines = 4,
  multiline_threshold = 2,
})

local ts = require('nvim-treesitter')

-- State tracking for async parser loading
local parsers_loaded = {}
local parsers_pending = {}
local parsers_failed = {}

local ns = vim.api.nvim_create_namespace('treesitter.async')

-- Helper to start highlighting and indentation
local function start(buf, lang)
  local ok = pcall(vim.treesitter.start, buf, lang)
  if ok then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
  return ok
end

-- Install core parsers after startup
vim.schedule(function()
  ts.install({
    'bash',
    'c',
    'comment',
    'css',
    'diff',
    'dockerfile',
    'fish',
    'git_rebase',
    'gitignore',
    'go',
    'gomod',
    'gosum',
    'gowork',
    'graphql',
    'hcl',
    'html',
    'http',
    'javascript',
    'jsdoc',
    'json',
    'json5',
    'lua',
    'luadoc',
    'luap',
    'make',
    'markdown',
    'markdown_inline',
    'printf',
    'python',
    'query',
    'regex',
    'ruby',
    'rust',
    'scheme',
    'scss',
    'slim',
    'sql',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
    'vue',
    'xml',
    'yaml',
  }, {
    max_jobs = 8,
  })
end)

-- Decoration provider for async parser loading
vim.api.nvim_set_decoration_provider(ns, {
  on_start = vim.schedule_wrap(function()
    if #parsers_pending == 0 then
      return false
    end
    for _, data in ipairs(parsers_pending) do
      if vim.api.nvim_buf_is_valid(data.buf) then
        if start(data.buf, data.lang) then
          parsers_loaded[data.lang] = true
        else
          parsers_failed[data.lang] = true
        end
      end
    end
    parsers_pending = {}
  end),
})

local group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true })

local ignore_filetypes = {
  'blink-cmp-menu',
  'checkhealth',
  'gitcommit',
  'mason',
  'mason_backdrop',
  'snacks_dashboard',
  'snacks_layout_box',
  'snacks_notif',
  'snacks_picker_input',
  'snacks_picker_list',
  'snacks_picker_preview',
  'snacks_win',
}

-- Auto-install parsers and enable highlighting on FileType
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  desc = 'Enable treesitter highlighting and indentation (non-blocking)',
  callback = function(event)
    if vim.tbl_contains(ignore_filetypes, event.match) then
      return
    end

    local lang = vim.treesitter.language.get_lang(event.match) or event.match
    local buf = event.buf

    if parsers_failed[lang] then
      return
    end

    if parsers_loaded[lang] then
      -- Parser already loaded, start immediately (fast path)
      start(buf, lang)
    else
      -- Queue for async loading
      table.insert(parsers_pending, { buf = buf, lang = lang })
    end

    -- Auto-install missing parsers (async, no-op if already installed)
    ts.install({ lang })
  end,
})
