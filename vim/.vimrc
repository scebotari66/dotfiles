call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive', { 'tag': 'v3.1' }
Plug 'tpope/vim-surround'
Plug 'flazz/vim-colorschemes'
Plug 'dense-analysis/ale', { 'tag': 'v2.6.0' }
Plug 'jiangmiao/auto-pairs', { 'tag': 'v2.0.0' }
Plug 'terryma/vim-multiple-cursors'
Plug 'ctrlpvim/ctrlp.vim', { 'tag': '1.80' }
let g:ctrlp_show_hidden = 1
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = '\.git$\|build$\|node_modules$\|ext'
let g:ctrlp_lazy_update = 100
" ignore files from .gitignore
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
Plug 'editorconfig/editorconfig-vim', { 'tag': 'v1.0.0-beta' }
Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdtree', { 'tag': '6.2.0', 'on': 'NERDTreeToggle' }
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeMouseMode=2
" close vim if the only opened window in NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on':  'NERDTreeToggle'  }
Plug 'vim-airline/vim-airline', { 'tag': 'v0.10' }
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'pangloss/vim-javascript'
Plug 'posva/vim-vue'
call plug#end()

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
set showcmd
set ignorecase smartcase
filetype plugin indent on

colorscheme neodark
let mapleader=" "

"== KEY MAPPINGS ==
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader><leader> <c-^>
nnoremap <silent> <esc><esc> :noh<cr>
nnoremap <leader>j :cnext<cr>
nnoremap <leader>k :cprev<cr>
map <leader>J :join<cr>
" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" Move vertically faster with counts
noremap J 5j
vnoremap J 5j
noremap K 5k
vnoremap K 5k
" Move faster in buffer list
map gb :bnext<CR>
map gB :bprev<CR>
" Switch to previous buffer then delete the current one
nnoremap <leader>q :bp<cr>:bd #<cr> 
" Tolerate first uppercase letter in common commands
command W write
command Wa wa
command Wq wq
command Wqa wqa
command Q quit
map <C-b> :NERDTreeToggle<cr>
map <leader>br :NERDTreeFind<cr>

"== FUNCTIONS ==
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

" Indent if we're at the beginning of a line, autocomplete otherwise
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-n>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-p>
