# see options in https://nix-community.github.io/home-manager/options.xhtml
{ config, pkgs, ... }:

let 
  dotfilesDir = "${config.home.homeDirectory}/tatwd/dotfiles";
  homeConfigDir = "${config.home.homeDirectory}/.config";
in
{
  home.username = "jincl";
  home.homeDirectory = "/Users/jincl";

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    git
#    fzf
#    neovim
#    htop
    bottom
    inetutils
    go
    deno
    nodejs_22
#    dotnet-runtime
#    dotnet-sdk
#    dotnet-runtime_8
#    dotnet-sdk_8
    dotnet-sdk_9
    jdk8
    cmake
#    clang-tools

    tectonic
#    unrar
    p7zip

    vscode
    google-chrome
    jetbrains.rider

#    yabai
#    skhd
#    i3
#    keycastr
#    starship
    wezterm
#    alacritty
#    tmux
#    zellij
#    ghostty
#    iterm2
    avalonia-ilspy
    ollama
    podman
#    godot
    mitmproxy
#    postman

# zsh plugins
#    zsh-autosuggestions
#    zsh-syntax-highlighting
#    zsh-completions
#    nix-zsh-completions

# fonts
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    maple-mono.NF
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif

  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    GOPROXY = "https://goproxy.io,direct";
    DOTNET_ROOT = "${pkgs.dotnet-sdk_9}";
    JAVA_HOME = "${pkgs.jdk8}";
    HMNIX = "${homeConfigDir}/home-manager/home.nix";
  };

  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];

  home.file = {

# alacritty config file
#    ".config/alacritty/alacritty.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/alacritty.toml";

# starship config file
#    ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/starship.toml";

# wezterm config file
    ".config/wezterm/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/wezterm.lua";

    ".npmrc".text = ''
       prefix=${config.home.homeDirectory}/.npm-global
    '';

  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -lha";
      hm = "home-manager";
      nix-clean = "nix-collect-garbage --delete-old";
      chrome = "google-chrome-stable";
    };

 #   initContent = ''
 #     eval "$(starship init zsh)"
 #   '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    configPath = "${dotfilesDir}/starship.toml";
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "jincl";
      user.email = "tatwdo@gmail.com";
      init.defaultBranch = "main";
    };
    includes = [
      {
        condition = "gitdir:~/works/";
        path = "~/.gitconfig-work";
      }
      {
        condition = "gitdir:~/tatwd/";
        path = "~/.gitconfig-github";
      }
    ];
    ignores = [
      ".DS_Store"
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    extraLuaConfig = ''
      
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
      vim.opt.lazyredraw = true

      vim.g.mapleader = " "
      vim.g.maplocalleader = "\\"

      vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = "Save file" })
      vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })
      vim.keymap.set('n', '<leader>wq', '<cmd>wq<CR>', { desc = 'Save and quit' })
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
      
      -- Setup lazy.nvim
      require("lazy").setup({
        spec = {
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
        },
        --checker = { enabled = true },
      })

    '';

  };

}
