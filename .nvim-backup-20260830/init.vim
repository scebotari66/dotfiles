syntax on
let mapleader=" "

set noswapfile
set showmatch
set laststatus=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

call plug#begin()

Plug 'nordtheme/vim', { 'tag': 'v0.19.0' }
Plug 'tpope/vim-fugitive', { 'tag': 'v3.7' }
Plug 'tpope/vim-unimpaired'
Plug 'mg979/vim-visual-multi', { 'tag': 'v0.5.8' }
    let g:VM_theme = 'neon'
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
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'posva/vim-vue'
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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
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
Plug 'nvim-treesitter/nvim-treesitter', {'branch': 'master', 'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects', {'branch': 'master'}
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
" Tolerate first uppercase letter in common commands
command! W write
command! Wa wa
command! Wq wq
command! Wqa wqa
command! Q quit
" https://vim.fandom.com/wiki/Selecting_your_pasted_text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

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
