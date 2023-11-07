-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
vim.o.number = true
vim.o.tabstop = 2
vim.o.shiftwidt = 2
vim.o.relativenumber = true
vim.o.timeoutlen = 300
vim.o.updatetime = 300
vim.o.clipboard = 'unnamed'
vim.o.hlsearch = true
vim.opt.listchars:append({ trail =  '~', space = '⋅' })
vim.opt.list = true
vim.opt.mouse = nil
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 20
vim.opt.colorcolumn = "120"

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

vim.keymap.set('n', '<leader>gs', require('telescope.builtin').git_status, { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>gc', require('telescope.builtin').git_commits, { desc = '[G]it [C]ommits' })
vim.keymap.set('n', '<leader>gbc', require('telescope.builtin').git_bcommits, { desc = '[G]it [B]uffer [C]ommits' })
vim.keymap.set('n', '<leader>fj', ":set filetype=json | % !jq .<CR>", { desc = '[F]ormat buffer as [J]SON' })

local signs = { Error = "", Warn = " ", Hint = "", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

return {
  { "onsails/lspkind.nvim" },
  { "jparise/vim-graphql" },
  { "nvim-lua/plenary.nvim" },
  { "MunifTanjim/nui.nvim" },
  { "rcarriga/nvim-notify" },
  { "tikhomirov/vim-glsl" },
  {
      "dpayne/CodeGPT.nvim",
      dependencies = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
      },
      config = function()
          require("codegpt.config")
      end
  },
  {
    "sbdchd/neoformat",
  },
  {
    "David-Kunz/jester",
    config = function()
      require("jester").setup({
        path_to_jest_run = './node_modules/jest/bin/jest.js'
      })
      vim.keymap.set('n', '<leader>jr', require('jester').run, { desc = '[J]est [R]un test under the cursor' })
      vim.keymap.set('n', '<leader>jf', require('jester').run_file, { desc = 'Run all [J]est tests for the current [F]ile' })
      vim.keymap.set('n', '<leader>jl', require('jester').run_last, { desc = 'Run the [J]est test that was [L]as run' })
    end
  },
  {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup()
    end
  },
  {
    "tjdevries/colorbuddy.nvim",
    config = function()
      require('colorbuddy').setup()
    end
  },
  {
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup({
        auto_open = true,
        auto_close = true,
        mode = "document_diagnostics"
      })
    end
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require('nvim-tree').setup({
        filters = {
          dotfiles = false
        }
      })
      vim.keymap.set('n', '<leader>n', function () require('nvim-tree.api').tree.toggle { find_file = true, focus = true} end, { desc = 'Toggle File Explorer' })
    end
  },
  {
    "Mofiqul/vscode.nvim",
    config = function()
       require("vscode").setup({
         italic_comments = true,
       })
       require('vscode').load()
       require('lualine').setup({
           options = {
               theme = 'vscode',
           },
       })
    end
  },
  --{
  --  "svrana/neosolarized.nvim",
  --  requires = "tjdevries/colorbuddy.nvim",
  --  config = function()
  --    require('neosolarized').setup({
  --      comment_italics = true,
  --      background_set = true,
  --    })
  --  end
  --},


}
