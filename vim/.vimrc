execute pathogen#infect()

syntax on
set t_Co=256
set mouse=a
set number
set hidden
set nobackup
set noswapfile
set expandtab
set smartindent
set tabstop=4
set shiftwidth=4
set relativenumber
set colorcolumn=100
set showmatch
set incsearch
set hlsearch
set ignorecase smartcase
filetype plugin indent on

let mapleader=" "

"==Key Mappings
nnoremap <leader><leader> <c-^>
nnoremap <silent> <leader>c :noh<CR><CR>
map <C-b> :NERDTreeToggle<CR>
map <leader>br :NERDTreeFind<CR>

"==Plugin `vim-airline` related=="
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

"==Plugin NERDTree related=="
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeMouseMode=2
" close vim if the only opened window in NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"==Plugin Vim colorschemes related=="
colorscheme neodark
