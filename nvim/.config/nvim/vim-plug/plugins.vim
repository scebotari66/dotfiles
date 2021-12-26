call plug#begin()

Plug 'arcticicestudio/nord-vim', { 'tag': 'v0.18.0' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive', { 'tag': 'v3.4' }
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'mg979/vim-visual-multi', { 'tag': 'v0.5.8' }
    let g:VM_theme = 'neon'
Plug 'LunarWatcher/auto-pairs', { 'tag': 'v3.0.0' }
    let g:AutoPairsCompatibleMaps = 0
    let g:AutoPairsShortcutJump=''
    let g:AutoPairsMoveCharacter=''
    let g:AutoPairsShortcutBackInsert=''
    let g:AutoPairsFlyMode=1 
Plug 'editorconfig/editorconfig-vim', { 'tag': 'v1.1.1' }
Plug 'mattn/emmet-vim'
Plug 'preservim/nerdtree', { 'tag': '6.10.16' }
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
Plug 'airblade/vim-gitgutter'
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
    \ 'coc-css',
    \ 'coc-emoji',
    \ 'coc-eslint',
    \ 'coc-highlight',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-tsserver',
    \ 'coc-ultisnips',
    \ 'coc-yaml',
    \ ]
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)
    nmap <silent> <leader>ld <Plug>(coc-definition)
    nmap <silent> <leader>lf <Plug>(coc-references)
    nmap <silent> <leader>ll :<C-u>CocDiagnostics<CR>
    nmap <leader>ln <Plug>(coc-rename)
    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')
    command! -nargs=0 Prettier :CocCommand prettier.formatFile
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

call plug#end()
