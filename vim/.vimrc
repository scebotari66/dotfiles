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
set lazyredraw
set ignorecase smartcase
filetype plugin indent on

let mapleader=" "

"==Key Mappings
nnoremap <leader><leader> <c-^>
nnoremap <silent> <esc><esc> :noh<cr>
nnoremap <leader>j :cnext<cr>
nnoremap <leader>k :cprev<cr>
" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" Move vertically faster with counts
noremap <c-j> 5j
vnoremap <c-j> 5j
noremap <c-k> 5k
vnoremap <c-k> 5k
map <C-b> :NERDTreeToggle<cr>
map <leader>br :NERDTreeFind<cr>

"==Plugin `vim-airline` related=="
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

"==Plugin `ctrp` related=="
let g:ctrlp_show_hidden = 1
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = '\.git$\|build$\|node_modules$\|ext'
" ignore files from .gitignore
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

"==Plugin NERDTree related=="
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeMouseMode=2
" close vim if the only opened window in NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"==Plugin Vim colorschemes related=="
colorscheme neodark
