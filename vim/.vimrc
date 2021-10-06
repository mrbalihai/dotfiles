call plug#begin('~/.vim/plugged')
Plug 'altercation/vim-colors-solarized'
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
Plug 'airblade/vim-gitgutter'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'liuchengxu/vim-which-key'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'
Plug 'ervandew/supertab'

call plug#end()

function! GetDate()
    call inputsave()
    let friendlyDate = input('Enter date: ')
    call inputrestore()
    let cmd = '/usr/bin/date --date="' . friendlyDate . '" +%F'
    let result = substitute(system(cmd), '[\]\|[[:cntrl:]]', '', 'g')
    call setline(line('.'), getline('.') . result)
endfunction

colorscheme solarized
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
set shortmess+=c
set directory=$HOME/.vim/swapfiles//
set guioptions-=m "menu bar
set guioptions-=T "toolbar
set guioptions-=r "scrollbar
set foldlevelstart=5
set showtabline=1
set laststatus=0
set hlsearch
set completeopt=menu,menuone,noselect
set timeoutlen=300

highlight EndOfBuffer ctermfg=0 ctermbg=0
highlight TabLine ctermbg=8
highlight TabLineSel ctermbg=8
highlight TabLineFill ctermbg=8
highlight ColorColumn ctermbg=8
highlight LineNr ctermbg=8 ctermfg=2
highlight SignColumn ctermbg=0 ctermfg=2
highlight GitGutterAdd ctermbg=0
highlight GitGutterChange ctermbg=0
highlight GitGutterDelete ctermbg=0
highlight GitGutterChangeDelete ctermbg=0
highlight Normal ctermbg=0
highlight WhichKeyFloating ctermbg=8

let g:gitgutter_override_sign_column_highlight = 0
let mapleader = " "
let maplocalleader = ","
let g:vimwiki_list = [{'path': '~/Wiki/'}]
let g:tablabel = "%N%{flagship#tabmodified()} %{flagship#tabcwds('shorten',',')}"
let g:calendar_monday = 1
let g:which_key_centered = 0

let g:lsp_diagnostics_signs_error = {'text': ''}
let g:lsp_diagnostics_signs_warning = {'text': '' }
let g:lsp_diagnostics_signs_hint = {'text': ''}
let g:lsp_document_code_action_signs_hint = {'text': ''}
let g:lsp_diagnostics_float_cursor = 1

" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
nnoremap <silent> <leader>id :call GetDate()<CR>
nnoremap <silent> <leader>tc :execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")<CR>
nnoremap <silent> <leader>th :noh<CR>
nnoremap <silent> <leader>tn :set invnumber<CR> <BAR> <CMD>set invrelativenumber<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>fc :Commits<CR>
nnoremap <silent> <leader>ff :Files<CR>
nnoremap <silent> <leader>fg :Rg<CR>
nnoremap <silent> <leader>.. :LspCodeAction<CR>
nnoremap <silent> <leader>.i :LspHover<CR>
nnoremap <silent> <leader>.d :LspDefinition<CR>

call which_key#register('<Space>', "g:which_key_map")
let g:which_key_map =  {
    \ 'c': { 'name': 'which_key_ignore' },
    \ 'h': { 'name': 'which_key_ignore' },
    \ '.': {
        \ 'name': '+Code' ,
        \ '.': 'Code Action',
        \ 'i': 'Hover Info',
        \ 'd': 'Go to Definition',
    \ },
    \ 'f': {
        \ 'name': '+Find' ,
        \ 'b': 'Buffers',
        \ 'c': 'Git Commits',
        \ 'f': 'Files',
        \ 'g': 'Grep',
    \ },
    \ 'i': {
        \ 'name': '+Insert' ,
        \ 'd': 'Date',
    \ },
    \ 't': {
        \ 'name': '+Toggle',
        \ 'c': 'Colour Column',
        \ 'h': 'Clear Search Highlight',
        \ 'n': 'Line Numbers',
    \ },
    \ 'w': {
        \ 'name': '+Wiki'
    \}
\ }

autocmd FileType markdown setlocal spell spelllang=en_gb
autocmd QuickFixCmdPost *grep* cwindow
