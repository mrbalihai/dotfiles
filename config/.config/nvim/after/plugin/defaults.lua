require('nvim-tree').setup({
  filters = {
    dotfiles = false
  }
})

require("vscode").setup({
  italic_comments = true,
})

require('lualine').setup({
  options = {
    theme = "vscode"
  }
});

vim.o.number = true
vim.o.relativenumber = true
vim.o.timeoutlen = 300
vim.o.updatetime = 300
vim.o.clipboard = 'unnamed'
vim.o.hlsearch = true
vim.opt.listchars:append({ trail =  '~', space = '⋅' })
vim.opt.list = true
vim.opt.mouse = nil

vim.keymap.set('n', '<C-n>', require('nvim-tree.api').tree.toggle)
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local nvim_lsp = require('lspconfig')
local whichkey = require("which-key")
local on_attach = function(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
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
        ['f'] = { '<CMD>lua vim.lsp.buf.format { async = true }<CR>', 'Format' }
      },
    }
  })
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
  vim.api.nvim_command('autocmd CursorHold * lua vim.diagnostic.open_float(0, { focusable = false, scope = "line", border = "single" })')
  vim.api.nvim_command('autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()')

end

-- local servers = { 'tsserver', 'eslint', 'pyright', 'yamlls' }
-- for _, lsp in ipairs(servers) do
--  nvim_lsp[lsp].setup {
--    on_attach = on_attach,
--    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
--    flags = {
--      debounce_text_changes = 150,
--    }
--  }
-- end

nvim_lsp['tsserver'].setup{
  on_attach = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()), flags = {
    debounce_text_changes = 150,
  }
}

nvim_lsp['eslint'].setup{
  on_attach = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
  flags = {
    debounce_text_changes = 150,
  }
}

nvim_lsp['pyright'].setup{
  on_attach = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
  flags = {
    debounce_text_changes = 150,
  }
}

nvim_lsp['pylsp'].setup{
  on_attach = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
  flags = {
    debounce_text_changes = 150,
  }
}

nvim_lsp['yamlls'].setup {
  on_attach = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    yaml = {
      customTags = {
        "!And scalar",
        "!If scalar",
        "!Not",
        "!Equals scalar",
        "!Or scalar",
        "!FindInMap scalar",
        "!Base64",
        "!Cidr",
        "!Ref",
        "!Sub",
        "!GetAtt",
        "!GetAZs",
        "!ImportValue sequence",
        "!Select sequence",
        "!Split sequence",
        "!Join sequence"
      }
    }
  }
}
