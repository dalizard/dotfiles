" Plugins {{{
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release --locked
    else
      !cargo build --release --locked --no-default-features --features json-rpc
    endif
  endif
endfunction


call plug#begin('~/.nvim/plugins')

Plug 'airblade/vim-gitgutter'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'lifepillar/vim-cheat40'
Plug 'lifepillar/vim-colortemplate'
Plug 'lifepillar/vim-mucomplete'
Plug 'mbbill/undotree'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-erlang/vim-erlang-compiler'
Plug 'vim-test/vim-test'

call plug#end()
" }}}

" Core settings {{{
syntax enable
syntax sync minlines=256
filetype plugin indent on         " Enable file type detection.
set termguicolors
set nonumber                      " Do not show line numbers
set hidden                        " Allow unsaved background buffers and remember marks/undo for them
set history=10000                 " Lines to keep in history
set noruler                       " Do not show the ruler
set synmaxcol=128
set lazyredraw
set laststatus=2                  " Always show a status line for the last window
set novisualbell
set modelines=1                   " No lines are checked for set commands
set showmode                      " Show the mode you are in
set tabstop=2                     " A tab is two spaces
set shiftwidth=2                  " An autoindent (with <<) is two spaces
set autoindent                    " Copy indent from current line when starting a new line
set expandtab                     " Use spaces, not tabs
set list                          " Show invisible characters
set backspace=indent,eol,start    " Backspace through everything in insert mode
set listchars=""                  " Reset the listchars
set listchars=tab:\ \             " A tab should display as "  ", trailing whitespace as "."
set listchars+=trail:.            " Show trailing spaces as dots
set hlsearch                      " Highlight matches
set incsearch                     " Incremental searching
set ignorecase                    " Searches are case insensitive...
set smartcase                     " ... unless they contain at least one capital letter
set wildmenu
set wildmode=longest,list
set scrolloff=3                   " Have some context around the current line always on screen
set autoread                      " Watch out for file changes
set splitbelow                    " Put new window below the current one
set complete+=kspell              " Autocomplete with dictionary words when spell check is on
set completeopt=noinsert,menuone,noselect
set nobackup
set noswapfile                    " It's 2021 (at least)
set nowritebackup
set undofile                      " Maintain undo history between sessions
set undodir=~/.nvim/_undo
set directory=~/.nvim/_temp
set foldmethod=marker
set foldlevel=0
set previewheight=20              " Preview split height
set guicursor=                    " Do not change the cursor
set mouse=a                       " Enable mouse for all modes
set cursorline
set shell=dash

if $COLOR_THEME == 'dark'
  set background=dark
else
  set background=light
endif

" Do not use the deafault cheat sheet
let g:cheat40_use_default = 0
" }}}

" {{{ Gruvbox
lua << EOF
-- setup must be called before loading the colorscheme
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = true,
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  overrides = {},
})
vim.cmd("colorscheme gruvbox")
EOF
colorscheme gruvbox
" }}}

" Auto Groups {{{
augroup configgroup
  autocmd!

  " Only show cursorline in the current window and in normal mode.
	autocmd WinLeave,InsertEnter * set nocursorline
	autocmd WinEnter,InsertLeave * set cursorline

  " Reload the colorscheme whenever we write the file
  autocmd BufWritePost gruvbox.vim color gruvbox

  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
        \| if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \|   execute "normal! g`\""
        \| endif

  autocmd  FileType fzf set laststatus=0 noshowmode noruler
        \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END
" }}}

" Key Mappings {{{
" Set the leader key
let mapleader = ","

" Use Alt and Ctrl keys in command mode
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>
cnoremap <C-a> <C-b>

" Leave terminal mode
tnoremap <esc> <C-\><C-n>

" Clear highlighted text
nnoremap <silent> <cr> :nohl<cr>

" Disable Q
nnoremap Q <nop>

" Forget about the damn arrow keys!
nnoremap <Up> <nop>
inoremap <Up> <nop>
vnoremap <Up> <nop>
nnoremap <Down> <nop>
inoremap <Down> <nop>
vnoremap <Down> <nop>
nnoremap <Left> <nop>
inoremap <Left> <nop>
vnoremap <Left> <nop>
nnoremap <Right> <nop>
inoremap <Right> <nop>
vnoremap <Right> <nop>

" Esc is harder to reach
inoremap <C-c> <esc>

" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>yy "+yy

" Telescope shortcuts
nnoremap <silent> <C-j> <cmd>Telescope git_files<cr>
nnoremap <silent> <C-l> <cmd>Telescope live_grep<cr>
nnoremap <silent> <C-k> <cmd>Telescope find_files no_ignore=true<cr>
nnoremap <silent> <C-f> <cmd>Telescope buffers<cr>

" Quick search
nnoremap <silent> K <cmd>Telescope grep_string<cr>
vnoremap <silent> K <cmd>Telescope grep_string<cr>

" Expand current path
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" Populate QuickFix with test suite run result
nnoremap <leader>q :cg spec/quickfix.out<cr>:echo "QuickFix populated"<cr>

" Rubocop
nnoremap <silent> <leader>c :call RunRubocop()<cr>

" test.vim
nnoremap <silent> <leader>s :TestNearest<cr>
nnoremap <silent> <leader>f :TestFile<cr>
nnoremap <silent> <leader>a :TestSuite<cr>
nnoremap <silent> <leader>l :TestLast<cr>
nnoremap <silent> <leader>v :TestVisit<cr>

" Rename a file
nnoremap <leader>r :call RenameFile()<cr>

" Swap windows
nnoremap <silent> <leader>wc :call MarkWindowSwap()<cr>
nnoremap <silent> <leader>wp :call DoWindowSwap()<cr>

" Copy current file path to clipboard
nnoremap <silent> <leader>yp :call CopyFilePathToClipboard()<cr>

" Because I constantly type :W istead of :w
cnoreabbrev W w

" Because :rg is easier
cnoreabbrev rg Rg
cnoreabbrev rg! Rg!

" Quick search shortcut
nnoremap \ :Rg<space>
nnoremap <C-\> :Rg!<space>

au FileType go nmap <leader>t <Plug>(go-run-split)

" Puts the called in Ruby
au FileType ruby nnoremap <leader>wtf oputs "#" * 80<c-m>puts caller<c-m>puts "#" * 80<esc>
" }}}

" RipGrep {{{
if executable('rg')
  set grepprg=rg\ --vimgrep
  set grepformat^=%f:%l:%c:%m
endif

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --smart-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" }}}

" fzf {{{
let g:fzf_preview_window = ''
let g:fzf_layout = { 'down': '~30%' }
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'],
  \ 'query':   ['fg', 'Query'] }
" }}}

" vim-test {{{

"function! TestRunnner(cmd) abort
"  let term_position = get(g:, 'test#neovim#term_position', 'botright')
"  execute term_position . ' new'
"  call termopen(a:cmd)
"  au BufDelete <buffer> wincmd p " switch back to last window
"  if !get(g:, 'test#neovim#start_normal', 0)
"    startinsert
"  endif
"endfunction

function! TestRunner(cmd) abort
  let term_position = get(g:, 'test#neovim#term_position', 'botright')

  let opts = {'suffix': ' # vim-test'}

  function! opts.on_exit(job_id, exit_code, event)
    if a:exit_code == 0
      call self.close_terminal()
    endif
  endfunction

  function! opts.close_terminal()
    if bufnr(self.suffix) != -1
      execute 'bdelete!' bufnr(self.suffix)
    end
  endfunction

  call opts.close_terminal()

  execute term_position . ' new'
  call termopen(a:cmd . opts.suffix, opts)
  au BufDelete <buffer> wincmd p
  normal! G
  wincmd p
endfunction

let g:test#custom_strategies = {'testrunner': function('TestRunner')}
let g:test#strategy = 'testrunner'
let test#neovim#term_position = "vert botright"

let test#ruby#rspec#options = {'suite': '-f p -r ~/.rspec-support/quickfix_formatter.rb -f QuickfixFormatter -o spec/quickfix.out'}
" }}}

" lualine.nvim {{{
lua << END
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
END
" }}}

" lightline.vim {{{
"let g:lightline = {
"      \ 'mode_map': {
"      \ 'n' : 'N',
"      \ 'i' : 'I',
"      \ 'R' : 'R',
"      \ 'v' : 'V',
"      \ 'V' : 'VL',
"      \ "\<C-v>": 'VB',
"      \ 'c' : 'C',
"      \ 's' : 'S',
"      \ 'S' : 'SL',
"      \ "\<C-s>": 'SB',
"      \ 't': 'T',
"      \ },
"      \ 'colorscheme': 'gruvbox8',
"      \ 'active': {
"      \   'left': [ [ 'mode', 'paste', 'spell' ],
"      \             [ 'fugitive', 'readonly', 'filename', 'gitmerge' ] ],
"      \   'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'fileencoding' ], [ 'filetype' ], [ 'obsession' ] ]
"      \ },
"      \ 'component_function': {
"      \   'filename': 'LightlineFilename',
"      \   'mode': 'LightlineMode',
"      \   'fugitive': 'LightlineFugitive',
"      \   'readonly': 'LightlineReadonly',
"      \   'fileformat': 'LightlineFileformat',
"      \   'filetype': 'LightlineFiletype',
"      \   'fileencoding': 'LightlineFileencoding',
"      \   'gitmerge': 'LightlineGitmerge',
"      \ },
"      \ 'component_expand': {
"      \   'obsession': 'LightlineObsession'
"      \ },
"      \ 'separator': { 'left': '', 'right': '' },
"      \ 'subseparator': { 'left': '・', 'right': '・' }
"      \ }
"
"autocmd OptionSet background
"      \ execute 'source' globpath(&rtp, 'autoload/lightline/colorscheme/gruvbox8.vim')
"      \ | call lightline#colorscheme() | call lightline#update()
"
"function! LightlineFilename()
"  let filename = expand('%:t') !=# '' ? expand('%:t') : '⌈no name⌉'
"  let modified = &modified ? ' ⌙' : ''
"  return filename . modified
"endfunction
"
"function! LightlineReadonly()
"  return &readonly ? '⌀' : ''
"endfunction
"
"function! LightlineFugitive()
"  if exists("*FugitiveHead(7)")
"    return winwidth(0) > 60 ? FugitiveHead(7) : ''
"  endif
"  return ''
"endfunction
"
"function! LightlineFileformat()
"  return winwidth(0) > 70 ? &fileformat : ''
"endfunction
"
"function! LightlineFiletype()
"  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
"endfunction
"
"function! LightlineFileencoding()
"  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
"endfunction
"
"function! LightlineMode()
"  return winwidth(0) > 30 ? lightline#mode() : ''
"endfunction
"
"function! LightlineGitmerge()
"  let fullname = expand('%')
"  let gitversion = ''
"  if fullname =~? 'fugitive://.*/\.git//0/.*'
"      let gitversion = 'git index'
"  elseif fullname =~? 'fugitive://.*/\.git//2/.*'
"      let gitversion = 'git target'
"  elseif fullname =~? 'fugitive://.*/\.git//3/.*'
"      let gitversion = 'git merge'
"  elseif &diff == 1
"      let gitversion = 'working copy'
"  endif
"  return gitversion
"endfunction
"
"function! LightlineObsession()
"    return '%{ObsessionStatus("▾", "▿")}'
"endfunction
" }}}

" {{{ MUcomplete
let g:mucomplete#completion_delay = 50
let g:mucomplete#reopen_immediately = 0
" }}}

" {{{ vim-jsx-pretty
let g:vim_jsx_pretty_colorful_config = 1
" }}}

" vim-fugitive {{{
augroup fugitive_ext
  autocmd!
  " Browse to the commit under my cursor
  autocmd FileType fugitiveblame nnoremap <buffer> <leader>gb :execute ":Gbrowse " . expand("<cword>")<cr>
augroup END

let g:fugitive_summary_format = "%<(16,trunc)%an || %s"

" Fold diffs by default
autocmd User FugitiveCommit set foldmethod=syntax
" }}}

" telescope.nvim {{{
lua << EOF
local actions = require('telescope.actions')
local action_layout = require('telescope.actions.layout')

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-p>"] = action_layout.toggle_preview,
        ["<C-y>"] = actions.delete_buffer,
      },
      n = {
        ["<C-p>"] = action_layout.toggle_preview,
      }
    },
    layout_strategy = 'flex',
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--hidden",
      "--smart-case"
    },
  },
  pickers = {
    git_files = {
      preview = {
        hide_on_startup = true
      }
    },
    find_files = {
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
      preview = {
        hide_on_startup = true
      }
    },
    buffers = {
      preview = {
        hide_on_startup = true
      }
    }
  }
}
EOF
" }}}

" Ruby {{{
let g:rails_projections = {
  \  'app/*.rb': {
  \     'alternate': 'spec/{}_spec.rb',
  \     'type': 'source'
  \   },
  \  'spec/*_spec.rb': {
  \     'alternate': 'app/{}.rb',
  \     'type': 'test'
  \   }
  \}
"}}}

" Erlang {{{
let g:erlang_completion_preview_help = 0
" }}}

" Go {{{
au FileType go nmap <leader>t <Plug>(go-run-vertical)
let g:go_doc_popup_window = 1
let g:go_doc_keywordprg_enabled = 0
let g:go_term_enabled = 1
let g:go_term_reuse = 1
let g:go_doc_popup_window = 1
" }}}

" Java {{{
let test#java#runner = 'gradletest'
" }}}

" Colorizer.lua {{{
lua << EOF
require 'colorizer'.setup({}, {
  rgb_fn = true,
  hsl_fn = true
})
EOF
" }}}

" Tree-sitter {{{
lua <<EOF
require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
    'tsx',
    'typescript',
    'javascript',
    'fish',
    'ruby',
    'go',
    'rust',
    'yaml',
    'html',
    'css'
  }
}
EOF
" }}}

" Custom Functions {{{
function! SearchWordWithRg()
  execute 'Rg' expand('<cword>')
endfunction

function! SearchVisualSelectionWithRg() range
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')
  let old_clipboard = &clipboard
  set clipboard&
  normal! ""gvy
  let selection = getreg('"')
  call setreg('"', old_reg, old_regtype)
  let &clipboard = old_clipboard
  execute 'Rg' selection
endfunction

function! RunRubocop()
  let opts = {'suffix': ' # rubocop'}

  function! opts.on_exit(job_id, exit_code, event)
    if a:exit_code == 0
      call self.close_terminal()
    endif
  endfunction

  function! opts.close_terminal()
    if bufnr(self.suffix) != -1
      execute 'bdelete!' bufnr(self.suffix)
    end
  endfunction

  call opts.close_terminal()

  vertical botright new

  call termopen('bin/rubocop' . opts.suffix, opts)

  wincmd p
endfunction

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

function! MarkWindowSwap()
  let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
  let curNum = winnr()
  let curBuf = bufnr( "%" )
  exe g:markedWinNum . "wincmd w"
  let markedBuf = bufnr( "%" )
  exe 'hide buf' curBuf
  exe curNum . "wincmd w"
  exe 'hide buf' markedBuf
endfunction

function! CopyFilePathToClipboard()
  silent call system('pbcopy', expand('%'))
  echo "Copied file path to clipboard"
endfunction

autocmd Signal SIGUSR1 call Darkorlight()
function! Darkorlight()
  if join(split(system("fish -c 'echo $COLOR_THEME'"))) == "dark"
    set background=dark
  else
    set background=light
  endif
  doautocmd OptionSet background
  doautocmd ColorScheme
  redraw
endfunction
" }}}

" vim:foldmethod=marker:foldlevel=0
