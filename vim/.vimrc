call plug#begin('~/.vim/plugged')

Plug 'chriskempson/base16-vim'
Plug 'altercation/vim-colors-solarized'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'ledger/vim-ledger'
Plug 'editorconfig/editorconfig-vim'
Plug 'mattn/calendar-vim'
Plug 'junegunn/goyo.vim'
Plug 'vimwiki/vimwiki'
Plug 'tools-life/taskwiki'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-flagship'
Plug 'pangloss/vim-javascript'

Plug 'leafgarland/typescript-vim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'glepnir/lspsaga.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'folke/lsp-colors.nvim'
Plug 'hrsh7th/vim-vsnip'

call plug#end()

function! GetDate()
    call inputsave()
    let friendlyDate = input('Enter date: ')
    call inputrestore()
    let cmd = '/usr/bin/date --date="' . friendlyDate . '" +%F'
    let result = substitute(system(cmd), '[\]\|[[:cntrl:]]', '', 'g')
    call setline(line('.'), getline('.') . result)
endfunction

" silent! color solarized
set bg=dark
set listchars=tab:>-,trail:~,extends:>,precedes:<
set list
set tabstop=4
set shiftwidth=4
set expandtab
set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
" set shortmess+=c
set directory=$HOME/.vim/swapfiles//
set guioptions-=m "menu bar
set guioptions-=T "toolbar
set guioptions-=r "scrollbar
set foldlevelstart=5
" set showtabline=1
set laststatus=0
set hlsearch

highlight EndOfBuffer ctermfg=black ctermbg=black
highlight TabLine ctermbg=black
highlight TabLineSel ctermbg=black
highlight TabLineFill ctermbg=black

let mapleader=","
let maplocalleader = " "
let g:vimwiki_list = [{'path': '~/Wiki/'}]
let g:tablabel = "%N%{flagship#tabmodified()} %{flagship#tabcwds('shorten',',')}"
let g:calendar_monday = 1

map <localleader>id :call GetDate()<CR>
map <localleader>p :FZF<CR>
map <localleader>f :Rg<CR>
map <localleader>h :noh<CR>
map <localleader>gg :Ggrep<SPACE>
map <C-n> :set invnumber<CR> <BAR> :set invrelativenumber<CR>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>

autocmd FileType markdown setlocal spell spelllang=en_gb
autocmd QuickFixCmdPost *grep* cwindow


lua << EOF
    require'lsp-colors'.setup({
        Error = "#db4b4b",
        Warning = "#e0af68",
        Information = "#0db9d7",
        Hint = "#10B981"
    })
    require'lspconfig'.tsserver.setup({})
    require'lspsaga'.init_lsp_saga()
    require'trouble'.setup {}
    local cmp = require('cmp')
    cmp.setup { }
EOF
