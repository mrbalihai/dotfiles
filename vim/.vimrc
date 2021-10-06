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

" IDE Plugins
Plug 'folke/which-key.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

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
set completeopt=menuone,noinsert,noselect
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
highlight WhichKeyFloat ctermbg=8
highlight Normal ctermbg=0

let g:gitgutter_override_sign_column_highlight = 0
let mapleader = " "
let maplocalleader = ","
let g:vimwiki_list = [{'path': '~/Wiki/'}]
let g:tablabel = "%N%{flagship#tabmodified()} %{flagship#tabcwds('shorten',',')}"
let g:calendar_monday = 1

autocmd FileType markdown setlocal spell spelllang=en_gb
autocmd QuickFixCmdPost *grep* cwindow

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

lua << EOF
    require'nvim-web-devicons'.setup {
        default = true;
    }
    require('telescope').setup {
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
                defaults = {
                    file_ignore_patterns = { 'node_modules', '.git' }
                }
            }
        }
    }
    require('telescope').load_extension('fzf')

    local whichkey = require'which-key'
    whichkey.register({
        ['<leader>'] = {
            ['.'] = {
                name = '+Code',
                ['.'] = { '<CMD>lua vim.lsp.buf.code_action()<CR>', 'Action' },
                ['d'] = { '<CMD>lua vim.lsp.buf.hover()<CR>', 'Hover Doc' },
            },
            ['c'] = 'which_key_ignore',
            ['f'] = {
                name = '+Find',
                ['b'] = { '<CMD>Telescope buffers<CR>', 'Buffers' },
                ['f'] = { '<CMD>Telescope find_files<CR>', 'Files' },
                ['g'] = { '<CMD>Telescope live_grep<CR>', 'Grep' },
                ['h'] = { '<CMD>Telescope help_tags<CR>', 'Help tags' },
            },
            ['h'] = 'which_key_ignore',
            ['i'] = {
                name = '+Insert',
                ['d'] = { '<CMD>call GetDate()', 'Date' },
            },
            ['t'] = {
                name = '+Toggle',
                ['c'] = { '<CMD>execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")<CR>', 'Colour Column' },
                ['h'] = { '<CMD>noh<CR>', 'Clear Search Highlight' },
                ['n'] = { '<CMD>set invnumber<CR> <BAR> <CMD>set invrelativenumber<CR>', 'Line Numbers' },
            },
            ['w'] = {
                name = '+Wiki',
                ['i'] = { '<CMD><Plug>VimwikiDiaryIndex <space>', '' },
                ['s'] = { '<CMD><Plug>VimwikiUISelect', '' },
                ['t'] = { '<CMD><Plug>VimwikiTabIndex', '' },
                ['i'] = { '<CMD><Plug>VimwikiIndex', '' },
            },
        },
    })
    vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    require('lspconfig').tsserver.setup {
        on_attach = require'completion'.on_attach
    }
EOF
