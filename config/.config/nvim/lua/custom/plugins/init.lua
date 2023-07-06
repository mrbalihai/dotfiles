-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
vim.o.number = true
vim.o.relativenumber = true
vim.o.timeoutlen = 300
vim.o.updatetime = 300
vim.o.clipboard = 'unnamed'
vim.o.hlsearch = true
vim.opt.listchars:append({ trail =  '~', space = '⋅' })
vim.opt.list = true
vim.opt.mouse = nil

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

return {
  { "jparise/vim-graphql" },
  { "nvim-lua/plenary.nvim" },
  { "MunifTanjim/nui.nvim" },
  { "rcarriga/nvim-notify" },
  { "nvim-tree/nvim-web-devicons" },
  { "dpayne/CodeGPT.nvim" },
  { "tjdevries/colorbuddy.nvim" },
  {
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup({
        signs = {
          error = signs.Error,
          warning = signs.Warn,
          hint = signs.Hint,
          information = signs.Info,
        },
        mode = "document_diagnostics",
        auto_open = true
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
      vim.keymap.set('n', '<C-n>', require('nvim-tree.api').tree.toggle)
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
  -- {
  --   "svrana/neosolarized.nvim",
  --   requires = "tjdevries/colorbuddy.nvim",
  --   config = function()
  --     require('neosolarized').setup({
  --       comment_italics = true,
  --       background_set = false,
  --     })
  --   end
  -- },


}
