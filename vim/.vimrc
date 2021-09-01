call plug#begin('~/.vim/plugged')

Plug 'chriskempson/base16-vim'
Plug 'altercation/vim-colors-solarized'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'leafgarland/typescript-vim'
Plug 'ledger/vim-ledger'
Plug 'editorconfig/editorconfig-vim'
Plug 'tikhomirov/vim-glsl'
Plug 'mattn/calendar-vim'
Plug 'junegunn/goyo.vim'
Plug 'vimwiki/vimwiki'
Plug 'tools-life/taskwiki'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-flagship'
Plug 'airblade/vim-gitgutter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

function! GetDate()
    call inputsave()
    let friendlyDate = input('Enter date: ')
    call inputrestore()
    let cmd = '/usr/bin/date --date="' . friendlyDate . '" +%F'
    let result = substitute(system(cmd), '[\]\|[[:cntrl:]]', '', 'g')
    call setline(line('.'), getline('.') . result)
endfunction

silent! color base16-default-light
set bg=light
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
set shortmess+=c
set directory=$HOME/.vim/swapfiles//
set guioptions-=m "menu bar
set guioptions-=T "toolbar
set guioptions-=r "scrollbar
set foldlevelstart=5
set showtabline=1
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
let g:coc_global_extensions = [
            \ 'coc-tsserver'
            \ ]
let g:coc_disable_startup_warning = 1

map <localleader>id :call GetDate()<CR>
map <localleader>p :FZF<CR>
map <localleader>h :noh<CR>
map <localleader>gg :Ggrep<SPACE>
map <C-n> :set invnumber<CR> <BAR> :set invrelativenumber<CR>

autocmd FileType markdown setlocal spell spelllang=en_gb
autocmd QuickFixCmdPost *grep* cwindow
