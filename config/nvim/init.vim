call plug#begin('~/.nvim/plugins')
Plug 'bling/vim-airline'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'vim-erlang/vim-erlang-compiler'
Plug 'vim-erlang/vim-erlang-runtime'
Plug 'thoughtbot/vim-rspec'
Plug 'junegunn/fzf.vim'
call plug#end()

colorscheme molokai               " Color theme
filetype plugin indent on 	      " Enable file type detection.
syntax enable                     " Turn on syntax highlighting
set encoding=utf-8                " Set default encoding to UTF-8
set nonumber                      " Do not show line numbers
set hidden                        " Allow unsaved background buffers and remember marks/undo for them
set noshowcmd                     " Do not display incomplete commands
set history=10000                 " Lines to keep in history
set noruler                       " Do not show the ruler
set lazyredraw
set laststatus=2                  " Always show a status line for the last window
set novisualbell
set modelines=0                   " No lines are checked for set commands
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
set cursorline                    " Highlights current line
set synmaxcol=128
set scrolloff=3                   " Have some context around the current line always on screen
set autoread                      " Watch out for file changes
set t_ti= t_te=
"set timeout timeoutlen=1000 ttimeoutlen=100
set splitbelow                    " Put new window below the current one
set backup
set undodir=~/.nvim/_undo
set backupdir=~/.nvim/_backup      " where to put backup files
set directory=~/.nvim/_temp        " where to put swap files
set nofoldenable                  " All folds are open
set undofile                      " Maintain undo history between sessions
set switchbuf=usetab,newtab
set shell=/bin/bash
set rtp+=/usr/local/opt/fzf

let mapleader = ","
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tmuxline#enabled = 0
let g:tmuxline_separators = {
    \ 'left' : '',
    \ 'left_alt': '',
    \ 'right' : '',
    \ 'right_alt' : '<',
    \ 'space' : ' '}
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let ruby_operators = 1
let ruby_minlines = 1000
let ruby_space_errors = 1

" Proper error handling when using zeus gem
let g:dispatch_compilers = { 'zeus': '' }

" Go to previous fiile
nnoremap <leader><leader> <c-^>

" Disable Q
nnoremap Q <nop>

" Forget about the damn arrow keys!
nnoremap <Up> <NOP>
inoremap <Up> <NOP>
vnoremap <Up> <NOP>
nnoremap <Down> <NOP>
inoremap <Down> <NOP>
vnoremap <Down> <NOP>
nnoremap <Left> <NOP>
inoremap <Left> <NOP>
vnoremap <Left> <NOP>
nnoremap <Right> <NOP>
inoremap <Right> <NOP>
vnoremap <Right> <NOP>

"nnoremap <C-K> :Ag <C-r><C-w><CR>

" Easy buffer navigation
nnoremap <silent> <C-l> :bnext<CR>
nnoremap <silent> <C-k> :bprevious<CR>

" Copy to clipboard
map <leader>y "*y

" Esc is harder to reach
imap <C-c> <esc>

map <C-p> :Files<CR>
map <C-i> :Buffers<CR>

" Expand current path
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" Show previous file (vim-rails)
nnoremap <leader><leader> <C-^>

" vim-rspec
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" Rename current file or even move it to another location
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>r :call RenameFile()<cr>

" Copy current file path to clipboard
nnoremap <Leader>yp :let @*=expand("%")<cr>:echo "Copied file path to clipboard"<cr>

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" .rb settings
autocmd FileType ruby set iskeyword+=?,!
