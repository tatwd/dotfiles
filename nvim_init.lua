-- windows: $env:LOCALAPPDATA\nvim\init.lua
-- macOS: $HOME/.config/nvim/init.lua

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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

-- key mappings
vim.keymap.set('n', '<leader>w', function()
  if vim.bo.modified then
    vim.cmd('w')
  else
    print('No changes to save')
  end
end, { desc = "Save modified file" })
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })
--vim.keymap.set('n', '<leader>wq', '<cmd>wq<CR>', { desc = 'Save and quit' })
-- vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file tree' })
vim.keymap.set('n', '<leader>t', '<cmd>tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<C-[>', '<cmd>tabprevious<CR>', { desc = 'Previous tab' })
vim.keymap.set('n', '<C-]>', '<cmd>tabnext<CR>', { desc = 'Next tab' })


-- 根据环境变量设置默认shell
if vim.fn.has('win32') == 1 then
  vim.opt.shell = vim.fn.executable('pwsh') == 1 and 'pwsh' or 'powershell'
  vim.opt.shellcmdflag = '-nologo'
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
  -- { "nvim-tree/nvim-web-devicons", lazy = true },
  -- { "nvim-tree/nvim-tree.lua", opts = {} },
  { "nvim-mini/mini.icons", opts = {}, lazy = true },
  {
    "stevearc/oil.nvim",
    lazy = false,
    keys = {
      { '-', '<CMD>Oil<CR>', 'Open parent directory' }
    },
    opts = {
      default_file_explorer = true,
    },
  },
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
      ensure_installed = {"c","cpp","c_sharp","lua","bash","markdown","http"},
      highlight = { enable = true },
    }
  },
  {
    -- more docs: https://cmp.saghen.dev/
    'saghen/blink.cmp',
    -- dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    event = { 'BufReadPost','BufNewFile' },
    opts = {},
  },  -- dev env pkg manager
  {
    "mason-org/mason.nvim",
    event = { 'BufReadPost','BufNewFile','VimEnter' },
    opts = {}
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    -- opts = { preview = { enable= false } }
  }
  -- {
  --   "rest-nvim/rest.nvim",
  -- }
  -- {
    -- "mistweaverco/kulala.nvim",
   -- ft = { "http", "rest" },
    -- keys = {
    --   { "<leader>Rs", desc = "Send request" },
    --   { "<leader>Ra", desc = "Send all requests" },
    --   { "<leader>Rb", desc = "Open scratchpad" },
    -- },
    -- opts = {
    --   -- your configuration comes here
    --   global_keymaps = false,
    --   global_keymaps_prefix = "<leader>R",
    --   kulala_keymaps_prefix = "",
    -- },
--    config = function ()
--      require("kulala").setup({
--        -- 禁用 treesitter 如果还有问题
--        -- treesitter = false,
--      })
--     vim.api.nvim_create_autocmd("FileType", {
--       pattern = "http",
--       callback = function()
--         -- 可选：禁用 treesitter 对于 http 文件
--         if vim.treesitter then
--           vim.treesitter.stop()
--         end
--       end,
--     })
--    end
  -- },
}
require("lazy").setup({
  spec = lazyPluginSpec,
  --checker = { enabled = true },
})
--- lazy.nvim config end

-- vim.filetype.add({
--   extension = {
--     ['http'] = 'http',
--   },
-- })

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "http",
--   callback = function()
--     print("hello world")
--     vim.treesitter.stop()
--   end,
-- })

-- lsp
vim.lsp.config("lua_ls", {
  -- :MasonInatll lua-language-server
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  settings = {
    Lua = {
      -- runtime = {
      --   version = "LuaJIT",
      -- },
      diagnostics = {
        globals = { "vim", "require" }
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
})
vim.lsp.enable("lua_ls")

--vim.lsp.config("omnisharp", {
--  cmd = {
--    vim.fn.executable('OmniSharp') == 1 and 'OmniSharp' or 'omnisharp',
--    '-z', -- https://github.com/OmniSharp/omnisharp-vscode/pull/4300
--    '--hostPID',
--    tostring(vim.fn.getpid()),
--    --'DotNet:enablePackageRestore=false',
--    '--encoding',
--    'utf-8',
--    '--languageserver',
--  },
--  filetypes = { 'cs', 'vb' },
--  root_markers = { '.git', '.sln' }
--})
--vim.lsp.enable("omnisharp")

-- vim.lsp.config("csharp_ls", {
--   cmd = {"csharp-ls"},
--   filetypes = {"cs"},
-- })
-- vim.lsp.enable("csharp_ls")

-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(ev)
--     local client = vim.lsp.get_client_by_id(ev.data.client_id)
--     if client:supports_method('textDocument/completion') then
--       vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
--     end
--   end,
-- })

-- vim.opt.completeopt = "menuone,noselect,noinsert"


