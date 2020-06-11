syntax on
let mapleader=" "

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
set colorcolumn=100
set showmatch
set incsearch
set hlsearch
set lazyredraw
set showcmd
set ignorecase smartcase
set backspace=indent,eol,start
set autoread
set noshowmode
set termguicolors
set showtabline=2
set laststatus=2

call plug#begin('~/.vim/plugged')
Plug 'arcticicestudio/nord-vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive', { 'tag': 'v3.2' }
Plug 'tpope/vim-surround'
Plug 'flazz/vim-colorschemes'
Plug 'dense-analysis/ale', { 'tag': 'v2.7.0' }
Plug 'mg979/vim-visual-multi', { 'tag': 'v.0.5.3' }
Plug 'jiangmiao/auto-pairs', { 'tag': 'v2.0.0' }
    let g:AutoPairsShortcutJump=''
    let g:AutoPairsMoveCharacter=''
    let g:AutoPairsShortcutBackInsert=''
Plug 'editorconfig/editorconfig-vim', { 'tag': 'v1.0.0-beta' }
Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdtree', { 'tag': '6.6.0', 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
    let NERDTreeShowHidden=1
    let NERDTreeMinimalUI=1
    let NERDTreeMouseMode=2
    let NERDTreeIgnore=['\.DS_Store$']
    " close vim if the only opened window in NERDTree
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on':  'NERDTreeToggle'  }
Plug 'itchyny/lightline.vim'
	let g:lightline = {
		\ 'active': {
        \   'left':[ [ 'mode', 'paste' ],
        \            [ 'gitbranch', 'readonly', 'modified' ]
        \   ],
		\ },
		\ 'colorscheme': 'nord',
		\ 'component': { 'lineinfo': ' %3l:%-2v' },
		\ 'component_expand': { 'buffers': 'lightline#bufferline#buffers' },
		\ 'component_function': { 'readonly': 'LightlineReadonly', 'gitbranch': 'LightlineFugitiveHead' },
		\ 'component_type': { 'buffers': 'tabsel' },
		\ 'separator': { 'left': '', 'right': '' },
		\ 'subseparator': { 'left': '', 'right': '' },
		\ 'tabline': { 'left': [['buffers']], 'right': [['close']] }
		\ }
	function! LightlineReadonly()
		return &readonly ? '' : ''
	endfunction
	function! LightlineFugitiveHead()
		if exists('*FugitiveHead')
			let branch = FugitiveHead()
			return branch !=# '' ? ''.branch : ''
		endif
		return ''
	endfunction
Plug 'mengelbrecht/lightline-bufferline'
    let g:lightline#bufferline#filename_modifier = ':t'
    nmap <Leader>1 <Plug>lightline#bufferline#go(1)
    nmap <Leader>2 <Plug>lightline#bufferline#go(2)
    nmap <Leader>3 <Plug>lightline#bufferline#go(3)
    nmap <Leader>4 <Plug>lightline#bufferline#go(4)
    nmap <Leader>5 <Plug>lightline#bufferline#go(5)
    nmap <Leader>6 <Plug>lightline#bufferline#go(6)
    nmap <Leader>7 <Plug>lightline#bufferline#go(7)
    nmap <Leader>8 <Plug>lightline#bufferline#go(8)
    nmap <Leader>9 <Plug>lightline#bufferline#go(9)
Plug 'airblade/vim-gitgutter'
Plug 'pangloss/vim-javascript'
Plug 'posva/vim-vue'
Plug 'wellle/targets.vim', { 'tag': 'v0.5.0' }
Plug 'SirVer/ultisnips', { 'tag': '3.2' }
    let g:UltiSnipsSnippetDirectories = ['ultisnippets']
    let g:UltiSnipsExpandTrigger='<tab>'
    let g:UltiSnipsJumpForwardTrigger='<tab>'
    let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
Plug 'wincent/ferret'
    let g:FerretMap=0
    nmap <leader>fa <Plug>(FerretAck)
    nmap <leader>ff <Plug>(FerretAck)
    nmap <leader>fl <Plug>(FerretLack)
    nmap <leader>fb <Plug>(FerretBack)
    nmap <leader>fw <Plug>(FerretAckWord)
    nmap <leader>sa <Plug>(FerretAcks)
    nmap <leader>ss <Plug>(FerretAcks)
    nmap <leader>sl <Plug>(FerretLack)
    nmap <leader>sb <Plug>(FerretBacks)
Plug '~/.fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
call plug#end()

colorscheme nord

filetype plugin indent on
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

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
" Write all changed buffers
map <leader>w :wa<cr>
" Quit the current window
nnoremap <leader>q :q<cr> 
" Switch to previous buffer then delete the current one
nnoremap <leader>x :bp<cr>:bd #<cr> 
" Close all buffers except the current one
nnoremap <leader>bd :%bd<cr>:e#<cr>:bd#<cr>
" Tolerate first uppercase letter in common commands
command! W write
command! Wa wa
command! Wq wq
command! Wqa wqa
command! Q quit
map <C-b> :NERDTreeToggle<cr>
map <leader>br :NERDTreeFind<cr>
map <C-p> :Files<cr>
map <leader>ob :Buffers<cr>
map <leader>og :GFiles<cr>
map <leader>oG :GFiles?<cr>
map <leader>oh :History<cr>

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
