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
  { "nvim-lua/plenary.nvim" },
  { "MunifTanjim/nui.nvim" },
  { "rcarriga/nvim-notify" },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  { "nvim-tree/nvim-web-devicons" },
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
        }

      })
    end
  },
  {
    "jackMort/ChatGPT.nvim",
    config = function()
      require("chatgpt").setup({
      })
    end,
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function ()
      require("copilot_cmp").setup()
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
  }
}
