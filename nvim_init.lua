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
    opts = { theme = "catppuccin" }
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
  }
}
require("lazy").setup({
  spec = lazyPluginSpec,
  --checker = { enabled = true },
})
