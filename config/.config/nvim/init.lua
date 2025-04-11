local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

local options = {
  number = true,
  relativenumber = true,
  mouse = nil,
  showmode = false,
  clipboard = "unnamedplus",
  breakindent = true,
  undofile = true,
  ignorecase = true,
  smartcase = true,
  signcolumn = "yes",
  updatetime = 250,
  timeoutlen = 300,
  splitright = true,
  splitbelow = true,
  list = true,
  listchars = { tab = "» ", trail = "·", nbsp = "␣" },
  inccommand = "split",
  cursorline = true,
  scrolloff = 10,
  colorcolumn = "120",
  hlsearch = true,
  tabstop = 2,
  shiftwidth = 2,
  foldcolumn = "1",
  foldlevel = 99,
  foldlevelstart = 99,
  foldenable = true,
  conceallevel = 2,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

local diagnostic_signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(diagnostic_signs) do
  vim.fn.sign_define(sign.name, { text = sign.text, texthl = sign.name, numhl = "" })
end

vim.diagnostic.config({ virtual_text = false })
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single", focusable = false })

vim.filetype.add({
  pattern = {
    [".*/templates/.*%.yaml"] = "helm",
  },
})

vim.api.nvim_create_autocmd("CursorHold", {
  desc = "Open diagnostic messages on cursor hold",
  group = vim.api.nvim_create_augroup("diagnostics-hover", { clear = true }),
  callback = function()
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(winid).zindex then
        return
      end
    end
    vim.diagnostic.open_float({ border = "single" }, { focusable = false })
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local key_groups = {
  { "<leader>c", group = "[c]ode" },
  { "<leader>o", group = "[o]rg mode" },
  { "<leader>d", group = "[d]ocument" },
  { "<leader>r", group = "[r]ename" },
  { "<leader>s", group = "[s]earch" },
  { "<leader>w", group = "[w]orkspace" },
  { "<leader>t", group = "[t]oggle" },
  { "<leader>g", group = "[g]it" },
  { "<leader>gh", group = "git [h]unk" },
  { "<leader>n", group = "[n]eotree toggle" },
}

local keys = {
  generic = {
    { "[d", vim.diagnostic.goto_prev, desc = "Go to previous [D]iagnostic message" },
    { "]d", vim.diagnostic.goto_next, desc = "Go to next [D]iagnostic message" },
    { "<leader>e", vim.diagnostic.open_float, desc = "Show diagnostic [E]rror messages" },
    { "<leader>q", vim.diagnostic.setloclist, desc = "Open diagnostic [Q]uickfix list" },
    { "<C-h>", "<C-w><C-h>", desc = "Move focus to the left window" },
    { "<C-l>", "<C-w><C-l>", desc = "Move focus to the right window" },
    { "<C-j>", "<C-w><C-j>", desc = "Move focus to the lower window" },
    { "<C-k>", "<C-w><C-k>", desc = "Move focus to the upper window" },
    { "<leader>jf", ":set filetype=json | % !jq .<CR>", desc = "[J]SON [F]ormat" },
    { "<Esc>", function() vim.opt.hlsearch = false end, desc = "Clear search highlight" },
  },
  snacks = {
    { "<leader>sf", function() Snacks.picker.smart() end, desc = "[S]earch Files" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "[S]earch [G]rep" },
    { "<leader>sn", function() Snacks.picker.notifications() end, desc = "[S]earch [N]otification History" },
    { "<leader><leader>", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "[G]it [S]tatus" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "[G]it [L]og" },
    { "<leader>sn", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "[S]earch [N]eovim files" },
    { "<leader>n", function() Snacks.explorer() end, desc = "Toggle File Explorer" },
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "[G]oto [D]efinition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "[G]oto [D]eclaration" },
    { "gr", function() Snacks.picker.lsp_references() end, desc = "[G]oto [R]eferences" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "[G]oto [I]mplementation" },
    { "<leader>D", function() Snacks.picker.lsp_type_definitions() end, desc = "Type [D]efinition" },
    { "<leader>ds", function() Snacks.picker.lsp_symbols() end, desc = "[D]ocument [S]ymbols" },
    { "<leader>ws", function() Snacks.picker.lsp_workspace_symbols() end, desc = "[W]orkspace [S]ymbols" },
    { "<leader>go", function() Snacks.gitbrowse.open() end, desc = "[G]it [O]pen in Github" },
  },
  lspconfig = {
    { "<leader>rn", vim.lsp.buf.rename, desc = "[R]e[n]ame" },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "[C]ode [A]ction" },
    { "K", vim.lsp.buf.hover, desc = "Hover Documentation" },
  },
  conform = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  gitsigns = {
    { "<leader>ghS", "<cmd>Gitsigns stage_buffer<cr>", desc = "[S]tage buffer" },
    { "<leader>ghu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "[u]ndo stage hunk" },
    { "<leader>ghR", "<cmd>Gitsigns reset_buffer<cr>", desc = "[R]eset buffer" },
    { "<leader>ghp", "<cmd>Gitsigns preview_hunk<cr>", desc = "[p]review hunk" },
    { "<leader>ghb", "<cmd>Gitsigns blame_line<cr>", desc = "[b]lame line" },
    { "<leader>ghd", "<cmd>Gitsigns diffthis<cr>", desc = "[d]iff against index" },
    { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle [b]lame line" },
    { "<leader>gD", "<cmd>Gitsigns toggle_deleted<cr>", desc = "Toggle show [D]eleted" },
    {
      "<leader>gd",
      function()
        require("gitsigns").diffthis("@")
      end,
      desc = "git [d]iff against last commit",
    },
    {
      "]c",
      function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          require("gitsigns").nav_hunk("next")
        end
      end,
      desc = "Jump to next [c]hange",
    },
    {
      "[c",
      function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          require("gitsigns").nav_hunk("prev")
        end
      end,
      desc = "Jump to previous [c]hange",
    },
    {
      "v<leader>ghs",
      function()
        require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end,
      desc = "[s]tage hunk",
    },
    {
      "v<leader>ghr",
      function()
        require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end,
      desc = "[r]eset hunk",
    },
  },
  trouble = {
    { "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>", desc = "[T]rouble Diagnostics [t]oggle" },
  },
  codecompanion = {
    { "<leader>cca", "<cmd>CodeCompanionActions<cr>", desc = "[C]ode [C]ompanion [A]ctions" },
    { "<leader>ccc", "<cmd>CodeCompanionChat<cr>", desc = "[C]ode [C]ompanion [C]hat" },
    { "<leader>cci", "<cmd>CodeCompanionInline<cr>", desc = "[C]ode [C]ompanion [I]nline" },
  },
}

require("lazy").setup({
  "tpope/vim-sleuth",
  "tpope/vim-fugitive",
  "github/copilot.vim",
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = {

        enabled = true,
        sources = {
          explorer = {
            auto_close = true,
          },
        },

        layout = 'my_layout',
        layouts = {
          my_layout = {
            layout = {
              box = 'horizontal',
              backdrop = true,
              width = 0.8,
              height = 0.9,
              border = 'none',
              {
                box = 'vertical',
                { win = 'input', height = 1, border = 'single', title = '{title} {live} {flags}', title_pos = 'center' },
                { win = 'list', title = ' Results ', title_pos = 'center', border = 'single' },
              },
              {
                win = 'preview',
                title = '{preview:Preview}',
                width = 0.45,
                border = 'single',
                title_pos = 'center',
              },
            },
          },
        },

      },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      toggle = { enabled = true },
    },
    keys = keys.snacks,
  },
  {
    "folke/trouble.nvim",
    opts = {
      modes = {
        diagnostics = { auto_open = false, auto_close = true },
      },
    },
    keys = keys.trouble,
  },
  {
    "kevinhwang91/nvim-ufo",
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
    dependencies = { "kevinhwang91/promise-async" },
  },
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      return { options = { theme = "codedark" } }
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        for _, key in ipairs(keys.gitsigns) do
          vim.keymap.set("n", key[1], key[2], { buffer = bufnr, desc = key.desc })
        end
      end,
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({ icons = { mappings = false }})
      require("which-key").add(key_groups)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          for _, key in ipairs(keys.lspconfig) do
            vim.keymap.set("n", key[1], key[2], { buffer = event.buf, desc = key[3] })
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
              end,
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      local servers = {
        ts_ls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      }
      require("mason").setup()
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua",
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    lazy = false,
    keys = keys.conform,
    opts = {
      notify_on_error = false,
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        build = (function()
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {},
      },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = "menu,menuone,noinsert" },

        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete({}),
          ["<C-l>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        },
      })
    end,
  },
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    opts = {
      italic_comments = true,
    },
    init = function()
      vim.cmd.colorscheme("vscode")
      vim.cmd.hi("Comment gui=none")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "lua",
        "luadoc",
        "markdown",
        "vim",
        "vimdoc",
        "typescript",
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = { enable = true, disable = { "ruby" } },
    },
    config = function(_, opts)
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        markdown = { "vale" },
      }
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    main = "render-markdown",
    opts = {},
    name = "render-markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = {
      strategies = {
        chat = {
          adapter = "copilot",
        },
        inline = {
          adapter = "ollama",
        },
        display = {
          action_palette = {
            provider = "snacks",
          },
        },
      },
    },
    keys = keys.codecompanion,
  },
})
