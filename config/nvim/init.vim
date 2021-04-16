" Plugins {{{
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.nvim/plugins')

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'itchyny/lightline.vim'
Plug 'janko-m/vim-test'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'lifepillar/vim-cheat40'
Plug 'lifepillar/vim-colortemplate'
Plug 'lifepillar/vim-mucomplete'
Plug 'lmeijvogel/vim-yaml-helper'
Plug 'mbbill/undotree'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-surround'
Plug 'vim-erlang/vim-erlang-compiler'

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
set shell=/usr/local/bin/dash
set guicursor=                    " Do not change the cursor
set mouse=a                       " Enable mouse for all modes
set cursorline

" Do not use the deafault cheat sheet
let g:cheat40_use_default = 0
" }}}

" {{{ Color Scheme
let g:gruvbox8_filetype_hi_groups = 1
let g:gruvbox8_plugin_hi_groups = 1
colorscheme gruvbox8
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

" fzf.vim shortcuts
nnoremap <silent> <C-j> :GFiles<cr>
nnoremap <silent> <C-k> :Files<cr>
nnoremap <silent> <C-f> :Buffers<cr>

" Quick search
nnoremap <silent> K :call SearchWordWithRg()<cr>
vnoremap <silent> K :call SearchVisualSelectionWithRg()<cr>

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
\ { 'fg':      ['fg', 'fzfNormal'],
  \ 'bg':      ['bg', 'none'],
  \ 'hl':      ['fg', 'fzfComment'],
  \ 'fg+':     ['fg', 'fzfCursorLine'],
  \ 'bg+':     ['bg', 'fzfCursorLine'],
  \ 'hl+':     ['fg', 'fzfStatement'],
  \ 'info':    ['fg', 'fzfPreProc'],
  \ 'border':  ['fg', 'fzfIgnore'],
  \ 'prompt':  ['fg', 'fzfConditional'],
  \ 'pointer': ['fg', 'fzfException'],
  \ 'marker':  ['fg', 'fzfKeyword'],
  \ 'spinner': ['fg', 'fzfLabel'],
  \ 'header':  ['fg', 'fzfComment'] }
" }}}

" vim-test {{{
function! TestRunner(cmd)
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

  vertical botright new
  call termopen(a:cmd . opts.suffix, opts)
  au BufDelete <buffer> wincmd p
  normal! G
  wincmd p
endfunction

let g:test#custom_strategies = {'testrunner': function('TestRunner')}
let g:test#strategy = 'testrunner'

let test#ruby#rspec#options = {'suite': '-f p -r ~/.rspec-support/quickfix_formatter.rb -f QuickfixFormatter -o spec/quickfix.out'}
" }}}

" lightline.vim {{{
let g:lightline = {
      \ 'mode_map': {
      \ 'n' : 'N',
      \ 'i' : 'I',
      \ 'R' : 'R',
      \ 'v' : 'V',
      \ 'V' : 'VL',
      \ "\<C-v>": 'VB',
      \ 'c' : 'C',
      \ 's' : 'S',
      \ 'S' : 'SL',
      \ "\<C-s>": 'SB',
      \ 't': 'T',
      \ },
      \ 'colorscheme': 'gruvbox8',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste', 'spell' ],
      \             [ 'fugitive', 'readonly', 'filename', 'gitmerge' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'fileencoding' ], [ 'filetype' ], [ 'obsession' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'mode': 'LightlineMode',
      \   'fugitive': 'LightlineFugitive',
      \   'readonly': 'LightlineReadonly',
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightlineFiletype',
      \   'fileencoding': 'LightlineFileencoding',
      \   'gitmerge': 'LightlineGitmerge',
      \ },
      \ 'component_expand': {
      \   'obsession': 'LightlineObsession'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '・', 'right': '・' }
      \ }

function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '⌈no name⌉'
  let modified = &modified ? ' ⌙' : ''
  return filename . modified
endfunction

function! LightlineReadonly()
  return &readonly ? '⌀' : ''
endfunction

function! LightlineFugitive()
  if exists("*fugitive#head(7)")
    return winwidth(0) > 60 ? fugitive#head(7) : ''
  endif
  return ''
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  return winwidth(0) > 30 ? lightline#mode() : ''
endfunction

function! LightlineGitmerge()
  let fullname = expand('%')
  let gitversion = ''
  if fullname =~? 'fugitive://.*/\.git//0/.*'
      let gitversion = 'git index'
  elseif fullname =~? 'fugitive://.*/\.git//2/.*'
      let gitversion = 'git target'
  elseif fullname =~? 'fugitive://.*/\.git//3/.*'
      let gitversion = 'git merge'
  elseif &diff == 1
      let gitversion = 'working copy'
  endif
  return gitversion
endfunction

function! LightlineObsession()
    return '%{ObsessionStatus("▾", "▿")}'
endfunction
" }}}

" {{{ Language Client
let g:LanguageClient_loadSettings = 0
let g:LanguageClient_selectionUI = 'fzf'
let g:LanguageClient_showCompletionDocs = 0


let g:LanguageClient_serverCommands = {
      \ 'javascript': ['typescript-language-server', '--stdio'],
      \ 'typescript': ['typescript-language-server', '--stdio'],
      \ 'ruby': ['solargraph', 'stdio'],
      \}

let g:LanguageClient_diagnosticsDisplay = {
  \ 1: {
  \   "name": "Error",
  \   "texthl": "ALEError",
  \   "signText": "•",
  \   "signTexthl": "ALEErrorSign",
  \   "virtualTexthl": "Error",
  \ },
  \ 2: {
  \   "name": "Warning",
  \   "texthl": "ALEWarning",
  \   "signText": "•",
  \   "signTexthl": "ALEWarningSign",
  \   "virtualTexthl": "Todo",
  \ },
  \ 3: {
  \   "name": "Information",
  \   "texthl": "ALEInfo",
  \   "signText": "•",
  \   "signTexthl": "ALEInfoSign",
  \   "virtualTexthl": "Todo",
  \ },
  \ 4: {
  \   "name": "Hint",
  \   "texthl": "ALEInfo",
  \   "signText": "•",
  \   "signTexthl": "ALEInfoSign",
  \   "virtualTexthl": "Todo",
  \ },
  \ }

function LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <buffer> <silent> L :call LanguageClient#textDocument_hover()<cr>
    nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
  endif
endfunction

autocmd FileType * call LC_maps()
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

" Colorizer.lua {{{
lua << EOF
require 'colorizer'.setup({}, {
  rgb_fn = true,
  hsl_fn = true
})
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
" }}}

" vim:foldmethod=marker:foldlevel=0
