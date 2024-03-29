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
set foldlevelstart=99

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

call plug#begin()

Plug 'nordtheme/vim', { 'tag': 'v0.19.0' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive', { 'tag': 'v3.7' }
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'mg979/vim-visual-multi', { 'tag': 'v0.5.8' }
    let g:VM_theme = 'neon'
Plug 'LunarWatcher/auto-pairs', { 'tag': 'v4.0.2' }
    let g:AutoPairsCompatibleMaps = 0
    let g:AutoPairsShortcutJump=''
    let g:AutoPairsMoveCharacter=''
    let g:AutoPairsShortcutBackInsert=''
    let g:AutoPairsFlyMode=1 
Plug 'editorconfig/editorconfig-vim', { 'tag': 'v1.2.0' }
Plug 'mattn/emmet-vim'
Plug 'preservim/nerdtree', { 'tag': '7.1.2' }
    let NERDTreeShowHidden=1
    let NERDTreeMinimalUI=1
    let NERDTreeMouseMode=2
    let NERDTreeIgnore=['\.DS_Store$']
    " close vim if the only opened window in NERDTree
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    map <C-b> :NERDTreeToggle<cr>
    map <leader>br :NERDTreeFind<cr>
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
Plug 'airblade/vim-gitgutter', {'branch': 'main'}
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'posva/vim-vue'
Plug 'wellle/targets.vim', { 'tag': 'v0.5.0' }
Plug 'SirVer/ultisnips', { 'tag': '3.2' }
    let g:UltiSnipsSnippetDirectories = ['ultisnippets']
    let g:UltiSnipsExpandTrigger='<tab>'
    let g:UltiSnipsJumpForwardTrigger='<tab>'
    let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
Plug 'wincent/ferret'
    let g:FerretMap=0
    nmap <silent> <expr> <leader>fa (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Ack "
    nmap <leader>ff <Plug>(FerretAck)
    nmap <leader>fl <Plug>(FerretLack)
    nmap <leader>fb :Back<space>
    vnoremap <leader>fv "yy:Ack <C-r>y<cr><cr>
    nmap <leader>fw <Plug>(FerretAckWord)
    nmap <leader>fW <Plug>(FerretAckWord)
    nmap <leader>sa <Plug>(FerretAcks)
    nmap <leader>ss <Plug>(FerretAcks)
    nmap <leader>sl <Plug>(FerretLack)
Plug '~/.fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
    map <C-p> :Files<cr>
    map <leader>ob :Buffers<cr>
    map <leader>oc :BCommits<cr>
    map <leader>og :GFiles?<cr>
    map <leader>oG :GFiles<cr>
    map <leader>oh :History<cr>
    map <leader>oo :BLines<cr>
    map <leader>ot :BTags<cr>
    map <leader>oT :Tags<cr>
Plug 'stsewd/fzf-checkout.vim'
    nmap <leader>gc :GBranches<cr>
Plug 'neoclide/coc.nvim', {'branch': 'release'}
    let g:coc_global_extensions = [
    \ '@yaegassy/coc-volar',
    \ 'coc-css',
    \ 'coc-emoji',
    \ 'coc-eslint',
    \ 'coc-highlight',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-prettier',
    \ 'coc-tsserver',
    \ 'coc-ultisnips',
    \ 'coc-yaml',
    \ ]
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)
    nmap <silent> <leader>ld <Plug>(coc-definition)
    nmap <silent> <leader>lf <Plug>(coc-references)
    nmap <silent> <leader>lF :<C-u>CocCommand tsserver.findAllFileReferences<CR>
    nmap <silent> <leader>ll :<C-u>CocDiagnostics<CR>
    nmap <leader>ln <Plug>(coc-rename)
    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')
    command! -nargs=0 Prettier :CocCommand prettier.formatFile
    " Use <c-space> to trigger completion.
    inoremap <silent><expr> <c-space> coc#refresh()
    " Use <leader>ld to show documentation in preview window
    nnoremap <silent> <leader>li :call CocActionAsync('doHover')<CR>
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'

call plug#end()

colorscheme nord

filetype plugin indent on
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

"== KEY MAPPINGS ==
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader><leader> <c-^>
nnoremap <silent> <esc><esc> :noh<cr>
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
map <leader>w :wa<cr>
" Quit the current window
nnoremap <leader>q :q<cr> 
" Switch to previous buffer then delete the current one
nnoremap <leader>x :bp<cr>:bd #<cr> 
" Close all buffers except the current one
nnoremap <leader>bd :%bd<cr>:e#<cr>:bd#<cr>:NERDTreeFind<cr>
" Tolerate first uppercase letter in common commands
command! W write
command! Wa wa
command! Wq wq
command! Wqa wqa
command! Q quit
" https://vim.fandom.com/wiki/Selecting_your_pasted_text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" Aliases to interact with system clipboard
nmap <Leader>y "+y
vmap <Leader>y "+y
nmap <Leader>d "+d
vmap <Leader>d "+d
nmap <Leader>p "+p
vmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>P "+P

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

"== FOLDING ==
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
nnoremap <silent> <leader>z :let&l:foldlevel = indent(".") / &sw<cr>
highlight Folded guifg=#5E81AC

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "javascript" },
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c", "rust" },  -- list of language that will be disabled
    additional_vim_regex_highlighting = false,
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}
EOF
