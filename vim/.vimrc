call plug#begin('~/.vim/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'overcache/NeoSolarized'
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
Plug 'folke/which-key.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'folke/lsp-colors.nvim'


call plug#end()

function! GetDate()
    call inputsave()
    let friendlyDate = input('Enter date: ')
    call inputrestore()
    let cmd = '/usr/bin/date --date="' . friendlyDate . '" +%F'
    let result = substitute(system(cmd), '[\]\|[[:cntrl:]]', '', 'g')
    call setline(line('.'), getline('.') . result)
endfunction

set termguicolors
colorscheme NeoSolarized
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

hi! EndOfBuffer guifg=bg guibg=bg ctermfg=bg ctermbg=bg
hi! WhichKeyFloat ctermbg=0 guibg=#073642
hi! Pmenu ctermfg=NONE ctermbg=0 cterm=NONE guifg=NONE guibg=#073642 gui=NONE

let g:gitgutter_override_sign_column_highlight = 0
let mapleader = " "
let maplocalleader = ","
let g:vimwiki_list = [{'path': '~/Wiki/'}]
let g:tablabel = "%N%{flagship#tabmodified()} %{flagship#tabcwds('shorten',',')}"
let g:calendar_monday = 1

autocmd FileType markdown setlocal spell spelllang=en_gb
autocmd QuickFixCmdPost *grep* cwindow

lua << EOF
    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end

    require'nvim-web-devicons'.setup {
        default = true;
    }

    require'nvim-tree'.setup()
    require'lsp-colors'.setup {
        -- Error = "#db4b4b",
        -- Warning = "#e0af68",
        -- Information = "#0db9d7",
        -- Hint = "#10B981"
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
            ['c'] = 'which_key_ignore',
            ['h'] = {
                name = '+Git'
            },
            ['f'] = {
                name = '+Find',
                ['b'] = { '<CMD>Telescope buffers<CR>', 'Buffers' },
                ['f'] = { '<CMD>Telescope find_files<CR>', 'Files' },
                ['g'] = { '<CMD>Telescope live_grep<CR>', 'Grep' },
                ['h'] = { '<CMD>Telescope help_tags<CR>', 'Help tags' },
                ['t'] = { '<CMD>NvimTreeToggle<CR>', 'Tree' },
            },
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
                name = '+Wiki'
            },
        },
    })

    local cmp = require'cmp'

    cmp.setup({
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end,
        },
        mapping = {
            ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            },
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif vim.fn["vsnip#available"]() == 1 then
                    feedkey("<Plug>(vsnip-expand-or-jump)", "")
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<S-Tab>"] = cmp.mapping(function()
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                    feedkey("<Plug>(vsnip-jump-prev)", "")
                end
            end, { "i", "s" }),
        },
        sources = {
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
            { name = 'buffer' },
        }
    })

    local nvim_lsp = require'lspconfig'
    local on_attach = function(client, bufnr)
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
        whichkey.register({
            ['<leader>'] = {
                ['.'] = {
                    name = '+Code',
                    ['.'] = { '<CMD>lua vim.lsp.buf.code_action()<CR>', 'Action' },
                    ['k'] = { '<CMD>lua vim.lsp.buf.hover()<CR>', 'Show Hover Doc' },
                    ['d'] = { '<CMD>lua vim.lsp.buf.definition()<CR>', 'Go To Definition' },
                    ['s'] = { '<CMD>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>', 'Search Symbols' },
                    ['n'] = { '<CMD>lua vim.lsp.diagnostic.goto_next()<CR>', 'Go To Next Diagnostic' },
                    ['p'] = { '<CMD>lua vim.lsp.diagnostic.goto_prev()<CR>', 'Go To Previous Diagnostic' },
                    ['f'] = { '<CMD>lua vim.lsp.buf.formatting()<CR>', 'Format' }
                },
            }
      })
      vim.o.relativenumber = true
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        underline = true,
        signs = true
      })
      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        focusable = false,
      })
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        focusable = false
      })
      vim.api.nvim_command('autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })')
      vim.api.nvim_command('autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()')
    end

    local servers = { 'tsserver' }
    for _, lsp in ipairs(servers) do
      nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
        flags = {
          debounce_text_changes = 150,
        }
      }
    end

    local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }
    for type, icon in pairs(signs) do
      local hl = "LspDiagnosticsSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

EOF
