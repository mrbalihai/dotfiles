return function(use)
  use({ "github/copilot.vim" })
  use({ "nvim-lua/plenary.nvim" })
  use({ "MunifTanjim/nui.nvim" })
  use({ "dpayne/CodeGPT.nvim" })
  use({ "Mofiqul/vscode.nvim" })
  use({ "tpope/vim-vinegar" })
  use({
    "folke/which-key.nvim",
      config = function()
        local wk = require("which-key")
        wk.setup({})
        wk.register({
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
            ['e'] = { '<CMD>Exec<CR>', 'Exec' },
            ['t'] = {
              name = '+Toggle',
              ['c'] = { '<CMD>execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")<CR>', 'Colour Column' },
              ['d'] = { '<CMD>Windiff<CR>', 'Diff' },
              ['h'] = { '<CMD>noh<CR>', 'Clear Search Highlight' },
              ['j'] = { '<CMD>FormatJson<CR>', 'Format Json' },
              ['n'] = { '<CMD>set invnumber<CR> <BAR> <CMD>set invrelativenumber<CR>', 'Line Numbers' },
            },
            ['w'] = {
                name = '+Wiki'
            },
            ['.'] = {
              name = '+Code',
              ['.'] = { '<CMD>lua vim.lsp.buf.code_action()<CR>', 'Action' },
              ['k'] = { '<CMD>lua vim.lsp.buf.hover()<CR>', 'Show Hover Doc' },
              ['d'] = { '<CMD>lua vim.lsp.buf.definition()<CR>', 'Go To Definition' },
              ['s'] = { '<CMD>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>', 'Search Symbols' },
              ['n'] = { '<CMD>lua vim.lsp.diagnostic.goto_next()<CR>', 'Go To Next Diagnostic' },
              ['p'] = { '<CMD>lua vim.lsp.diagnostic.goto_prev()<CR>', 'Go To Previous Diagnostic' },
              ['f'] = { '<CMD>lua vim.lsp.buf.format { async = true }<CR>', 'Format' }
            },
          },
        })
      end
  })
  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      'nvim-tree/nvim-web-devicons',
    }
  })
end
