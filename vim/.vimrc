execute pathogen#infect()

syntax on
set t_Co=256
set mouse=a
set nobackup
set noswapfile
set expandtab
set smartindent
set tabstop=4
set shiftwidth=4
set number
set relativenumber
filetype plugin indent on

"==Key Mappings
map <C-n> :NERDTreeToggle<CR>

"==Plugin `vim-airline` related=="
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

"==Plugin NERDTree related=="
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeMouseMode=2
" open on start up
autocmd VimEnter * NERDTree
" set cursor positon from NERDTree to file on vim open
autocmd VimEnter * wincmd p
" close vim if the only opened window in NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"==Plugin Vim colorschemes related=="
colorscheme mustang
