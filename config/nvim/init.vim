if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.nvim/plugins')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-rails'
Plug 'vim-erlang/vim-erlang-compiler'
Plug 'vim-erlang/vim-erlang-runtime'
Plug 'junegunn/fzf.vim'
Plug 'janko-m/vim-test'
Plug 'slim-template/vim-slim'
call plug#end()

colorscheme molokai               " Color theme
filetype plugin indent on 	      " Enable file type detection.
syntax enable                     " Turn on syntax highlighting
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
set synmaxcol=128
set scrolloff=3                   " Have some context around the current line always on screen
set autoread                      " Watch out for file changes
set splitbelow                    " Put new window below the current one
set nobackup
set nowritebackup
set undofile                      " Maintain undo history between sessions
set undodir=~/.nvim/_undo
set directory=~/.nvim/_temp
set foldmethod=indent
set foldnestmax=10
set nofoldenable                  " All folds are open
set foldlevel=1
set switchbuf=usetab,newtab
set shell=/usr/local/bin/fish
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

" Leave terminal mode
tnoremap <Esc> <C-\><C-n>

" Clear highlighted text
nnoremap <silent> <CR> :nohl<CR>

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

" Easy buffer navigation
nnoremap <silent> <C-l> :bnext<CR>
nnoremap <silent> <C-k> :bprevious<CR>

" Copy to clipboard
vnoremap <leader>y "*y

" Esc is harder to reach
inoremap <C-c> <ESC>

" fzf
let g:fzf_layout = { 'down': '~30%' }
nnoremap <silent> <C-j> :Files<CR>
nnoremap <silent> <C-f> :Buffers<CR>

nnoremap <silent> K :call SearchWordWithAg()<CR>
vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>

function! SearchWordWithAg()
  execute 'Ag' expand('<cword>')
endfunction

function! SearchVisualSelectionWithAg() range
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')
  let old_clipboard = &clipboard
  set clipboard&
  normal! ""gvy
  let selection = getreg('"')
  call setreg('"', old_reg, old_regtype)
  let &clipboard = old_clipboard
  execute 'Ag' selection
endfunction

" Expand current path
cnoremap %% <C-R>=expand('%:h').'/'<CR>

" vim-test
let test#strategy = 'neovim'
nnoremap <silent> <leader>s :TestNearest<CR>
nnoremap <silent> <leader>f :TestFile<CR>
nnoremap <silent> <leader>a :TestSuite<CR>
nnoremap <silent> <leader>l :TestLast<CR>
nnoremap <silent> <leader>v :TestVisit<CR>

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
map <leader>r :call RenameFile()<CR>

" Easy widows swap
function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf
endfunction

nnoremap <silent> <leader>wc :call MarkWindowSwap()<CR>
nnoremap <silent> <leader>wp :call DoWindowSwap()<CR>

" Copy current file path to clipboard
nnoremap <Leader>yp :let @*=expand("%")<cr>:echo "Copied file path to clipboard"<cr>

" .rb keywords
autocmd FileType ruby set iskeyword+=?,!
