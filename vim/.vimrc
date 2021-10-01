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
Plug 'airblade/vim-gitgutter'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'folke/lsp-colors.nvim'
Plug 'glepnir/lspsaga.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'

call plug#end()

function! GetDate()
    call inputsave()
    let friendlyDate = input('Enter date: ')
    call inputrestore()
    let cmd = '/usr/bin/date --date="' . friendlyDate . '" +%F'
    let result = substitute(system(cmd), '[\]\|[[:cntrl:]]', '', 'g')
    call setline(line('.'), getline('.') . result)
endfunction

set colorcolumn=0
let s:color_column_old = 81
function! s:ToggleColorColumn()
    if s:color_column_old == 0
        let s:color_column_old = &colorcolumn
        "windo let &colorcolumn = 0
        set colorcolumn=0
    else
        "windo let &colorcolumn=s:color_column_old
        let &colorcolumn=s:color_column_old
        let s:color_column_old = 0
    endif
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
set completeopt=menu,menuone,noselect

highlight EndOfBuffer ctermfg=black ctermbg=black
" highlight TabLine ctermbg=black
" highlight TabLineSel ctermbg=black
" highlight TabLineFill ctermbg=black
highlight ColorColumn ctermbg=8
highlight LineNr ctermbg=8 ctermfg=2
highlight SignColumn ctermbg=8 ctermfg=2
let g:gitgutter_override_sign_column_highlight = 0
highlight GitGutterAdd ctermbg=8
highlight GitGutterChange ctermbg=8
highlight GitGutterDelete ctermbg=8
highlight GitGutterChangeDelete ctermbg=8


let mapleader=" "
let maplocalleader = ","
let g:vimwiki_list = [{'path': '~/Wiki/'}]
let g:tablabel = "%N%{flagship#tabmodified()} %{flagship#tabcwds('shorten',',')}"
let g:calendar_monday = 1

map <leader>id :call GetDate()<CR>
map <leader>p :Files<CR>
map <leader>f :Rg<CR>
map <leader>h :noh<CR>
map <leader>g :Ggrep<SPACE>
map <leader>c :call <SID>ToggleColorColumn()<CR>
map <leader>n :set invnumber<CR> <BAR> :set invrelativenumber<CR>
map <leader>. :Lspsaga code_action<CR>
map <leader>. :<C-U>Lspsaga range_code_action<CR>
nnoremap <silent>K :Lspsaga hover_doc<CR>

autocmd FileType markdown setlocal spell spelllang=en_gb
autocmd QuickFixCmdPost *grep* cwindow


lua << EOF
    require'lsp-colors'.setup({
        Error = "#db4b4b",
        Warning = "#e0af68",
        Information = "#0db9d7",
        Hint = "#10B981"
    })
    require'lspsaga'.init_lsp_saga()
    require'trouble'.setup {
        auto_open = true,
        auto_close = true
    }
    local luasnip = require 'luasnip'
    local cmp = require 'cmp'
    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
        },
        mapping = {
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            },
            ['<Tab>'] = function(fallback)
                if vim.fn.pumvisible() == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
                elseif luasnip.expand_or_jumpable() then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
                else
                    fallback()
                end
            end,
            ['<S-Tab>'] = function(fallback)
                if vim.fn.pumvisible() == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
                elseif luasnip.jumpable(-1) then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
                else
                    fallback()
                end
            end,
        },
        sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'buffer' }
        }
    })
    require('lspconfig').tsserver.setup {
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }
EOF
