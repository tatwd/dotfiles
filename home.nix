# home-manager config file
# ~/.config/home-manager/home.nix

{ config, pkgs, ... }:

{
  home.username = "jincl";
  home.homeDirectory = "/Users/jincl";

  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    git
    fzf
#    neovim
#    htop
    bottom
    inetutils
    starship
    go
    deno
    nodejs_22
#    dotnet-runtime
#    dotnet-sdk
#    dotnet-runtime_8
#    dotnet-sdk_8
    dotnet-sdk_9
    jdk8
    tectonic
    cmake
#    unrar
    p7zip

    vscode
    google-chrome
    jetbrains.rider
#    iterm2
    alacritty
    avalonia-ilspy
    ollama
    podman
#    tmux
    zellij
#    godot
    mitmproxy
    postman

# zsh plugins
    zsh-autosuggestions
#    zsh-syntax-highlighting
#    zsh-completions
    nix-zsh-completions

# fonts
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    maple-mono.NF
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif

  ];

  home.sessionVariables = {
#    EDITOR = "emacs";
    EDITOR = "nvim";
    GOPROXY = "https://goproxy.io,direct";
    DOTNET_ROOT = "${pkgs.dotnet-sdk_9}";
    JAVA_HOME = "${pkgs.jdk8}";
  };

  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];

  home.file = {

# starship config file
    ".config/starship.toml".text = ''
      # Get editor completions based on the config schema
      "$schema" = 'https://starship.rs/config-schema.json'

      add_newline = false
      command_timeout = 1000

      [character]
      success_symbol = "[➜](bold green)"
      error_symbol = "[➜](bold red)"
      vicmd_symbol = "[➜](bold green)"

      [package]
      disabled = true

      [dotnet]
      symbol = ".net "

      [nodejs]
      symbol = "⬢ "
    '';

    ".npmrc".text = ''
       prefix=${config.home.homeDirectory}/.npm-global
    '';

  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
#    enableCompletion = true;
#    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -lha";
      hm = "home-manager";
      nix-clean = "nix-collect-garbage -d";
    };

    initContent = ''
      eval "$(starship init zsh)"
    '';
  };

  programs.git = {
    enable = true;
    userName = "tatwd";
    userEmail = "tatwdo@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
    includes = [
      #works
      {
        condition = "gitdir:~/works/";
        path = "~/.gitconfig-work";
      }
      # github
      {
        condition = "gitdir:~/tatwd/";
        path = "~/.gitconfig-github";
      }
    ];
  };

# 终端配置
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "Maple Mono NF"; style = "Regular";
        };
        size = 13.0;
      };
#      ligatures = true;
      window = {
        padding = { x = 3; y = 3; };
        dynamic_padding = true;
      };
      scrolling = {
        multiplier = 3;
      };
      selection = {
        save_to_clipboard = true;
      };
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    extraConfig = ''
      set number
      set relativenumber
      set list
      set listchars=tab:▸\ ,trail:·,nbsp:␣,space:·
      "set expandtab " replace tab -> space
    '';
    extraLuaConfig = ''
      vim.opt.inccommand = 'split'
      vim.opt.lazyredraw = true    -- 延迟重绘提高性能 
    '';

    plugins = with pkgs.vimPlugins; [
      vim-sleuth
    ];

  };

}
