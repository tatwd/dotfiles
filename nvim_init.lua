-- windows: $env:LOCALAPPDATA\nvim\init.lua
-- macOS: $HOME/.config/nvim/init.lua

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = {
  tab = "▸ ",
  space = "·",
  --trail = "·",
  precedes = "«",
  extends = "»",
  nbsp = "␣",
  --eol = "¬",
}
vim.opt.inccommand = 'split'
--vim.opt.lazyredraw = true

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set('n', '<leader>w', function()
  if vim.bo.modified then
    vim.cmd('w')
  else
    print('No changes to save')
  end
end, { desc = "Save modified file" })
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })
--vim.keymap.set('n', '<leader>wq', '<cmd>wq<CR>', { desc = 'Save and quit' })
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file tree' })
vim.keymap.set('n', '<leader>t', '<cmd>tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<C-[>', '<cmd>tabprevious<CR>', { desc = 'Previous tab' })
vim.keymap.set('n', '<C-]>', '<cmd>tabnext<CR>', { desc = 'Next tab' })


-- 根据环境变量设置默认shell
if vim.fn.has('win32') == 1 then
  vim.opt.shell = vim.fn.executable('pwsh') == 1 and 'pwsh' or 'powershell'
  vim.opt.shellcmdflag = '-nolog'
end


-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim & plugins
local CACHES = {
  cnHourMap = {
    "🐭", --"子", --"夜半",
    "🐮", --"丑", --"雞鳴",
    "🐯", --"寅", --"平旦",
    "🐇", --"卯", --"日出",
    "🐲", --"辰", --"食時",
    "🐍", --"巳", --"隅中",
    "🐴", --"午", --"日中",
    "🐑", --"未", --"日昳",
    "🙉", --"申", --"哺時",
    "🐔", --"酉", --"日入",
    "🐶", --"戌", --"黃昏",
    "🐷", --"亥", --"人定"
  }
}
local lazyPluginSpec = {
  { "tpope/vim-sleuth" },
  { "tpope/vim-commentary"  },
  { "tpope/vim-surround" },
  { "tpope/vim-repeat" },
  -- { "tpope/vim-fugitive" },
  { 
    "catppuccin/nvim", 
    name = "catppuccin", 
    priority = 1000,
    opts = {
      flavour = "mocha",
      --transparent_background = true,
    },
    config = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-tree/nvim-tree.lua", opts = {} },
  { 
    "nvim-lualine/lualine.nvim", 
    opts = {
      options = {
        theme = "catppuccin",
        component_separators = { left = "·", right = "·" },
        -- section_separators = '',
      },
      sections = {
        -- lualine_z = { {"datetime", style="%I:%M %p"} },
        -- lualine_y = {"progress"},
        lualine_x = {
          "encoding","fileformat","filetype",
          -- "location",
          {
            "datetime",
            style="%H",
            fmt = function(str)
              local lastH = CACHES.lualine_dt;
              if lastH == str then
                return CACHES.lualine_dt_fmt
              end
              local h = tonumber(str)
              local index = (h == 23 or h == 0) and 0
                or math.floor((h + 1) / 2)
              local fmtH = CACHES.cnHourMap[index + 1]
              CACHES.lualine_dt = str
              CACHES.lualine_dt_fmt = fmtH
              return fmtH
            end
          } 
        },
      },
    }
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "nvim-telescope/telescope.nvim", tag = "v0.1.9",
    -- dependencies = { 'nvim-lua/plenary.nvim' }
    opts = {
      -- defaults = {
      --   preview = { treesitter = false },
      -- },
    },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter", branch = "main",
    lazy = false, build = ":TSUpdate",
    opts = {
      -- ensure_installed = {"c","cpp","lua","bash","markdown"},
      -- highlight = { enable = true },
    }
  },
  -- dev env pkg manager
  -- {
  --   "mason-org/mason.nvim", 
  --   opts = {}
  -- }
  -- { "neovim/nvim-lspconfig" },
  { "hrsh7th/cmp-nvim-lsp", lazy = true },
  { "hrsh7th/cmp-buffer", lazy = true },
  { 
    "L3MON4D3/LuaSnip", version = "v2.4.1",
    lazy = true
    -- build = "make install_jsregexp"
  },
  { 
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end
        },
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<CR>'] = cmp.mapping.confirm({select = true}),
          ['<C-Space>'] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name='nvim_lsp' }, --cmp-nvim-lsp
          { name='luasnip' },
        }, { {name='buffer'} })
      })
    end,
  }
}
require("lazy").setup({
  spec = lazyPluginSpec,
  --checker = { enabled = true },
})
