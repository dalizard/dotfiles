call pathogen#infect()
filetype plugin indent on 	      " Enable file type detection.
colorscheme molokai               " Color theme
syntax enable                     " Turn on syntax highlighting
set encoding=utf-8                " Set default encoding to UTF-8
set nocompatible                  " Use vim, no vi defaults
set number                        " Show line numbers
set hidden                        " Allow unsaved background buffers and remember marks/undo for them
set showcmd                       " Display incomplete commands
set nowrap
set history=10000
set noruler
set ttyscroll=3
set lazyredraw
set laststatus=2
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
set autoread
set t_ti= t_te=
set timeout timeoutlen=1000 ttimeoutlen=100

set backup
set backupdir=~/.vim/_backup    " where to put backup files
set directory=~/.vim/_temp      " where to put swap files

set nofoldenable
set switchbuf=usetab,newtab

let mapleader = ","
let g:airline_powerline_fonts=1

highlight NonText cterm=NONE ctermfg=NONE

:nnoremap <cr> :nohlsearch<cr>

nnoremap <leader><leader> <c-^>

map <C-l> :tabn<CR>
map <C-h> :tabp<CR>
map <C-n> :tabnew<CR>

map <leader>y "*y

imap jj <ESC>
imap <c-c> <esc>

cnoremap %% <C-R>=expand('%:h').'/'<cr>

nnoremap <leader><leader> <c-^>

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
