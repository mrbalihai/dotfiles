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
Plug 'folke/trouble.nvim'
Plug 'folke/lsp-colors.nvim'
Plug 'glepnir/lspsaga.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
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

lua << EOF
    require('telescope').setup {
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            }
        }
    }
    require('telescope').load_extension('fzf')
    require'lsp-colors'.setup {
        Error = '#db4b4b',
        Warning = '#e0af68',
        Information = '#0db9d7',
        Hint = '#10B981'
    }
    require'lspsaga'.init_lsp_saga {
        code_action_prompt = {
            virtual_text = true
        }
    }
    require'trouble'.setup {
        auto_open = true,
        auto_close = true
    }
    local whichkey = require'which-key'
    whichkey.register({
        ['<leader>'] = {
            ['.'] = {
                name = '+Code',
                ['.'] = { '<CMD>Lspsaga code_action<CR>', 'Action' },
                [','] = { '<CMD>Lspsaga range_code_action<CR>', 'Range Action' },
                ['d'] = { '<CMD>Lspsaga hover_doc<CR>', 'Hover Doc' },
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

    local luasnip = require'luasnip'
    local cmp = require'cmp'
    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
        },
        mapping = {
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
