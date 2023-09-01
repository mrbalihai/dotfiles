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

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

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
  { "nvim-tree/nvim-web-devicons" },
  { "dpayne/CodeGPT.nvim" },
  { "tikhomirov/vim-glsl" },
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
        auto_close = true
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
      vim.keymap.set('n', '<leader>n', require('nvim-tree.api').tree.toggle, { desc = 'Toggle File Explorer' })
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
