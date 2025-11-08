# see options in https://nix-community.github.io/home-manager/options.xhtml

{ config, pkgs, ... }:

let 
  dotfilesDir = "${config.home.homeDirectory}/tatwd/dotfiles";
  homeConfigDir = "${config.home.homeDirectory}/.config";
in
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
    cmake
#    clang-tools

    tectonic
#    unrar
    p7zip

    vscode
    google-chrome
    jetbrains.rider
#    iterm2
    alacritty
    wezterm
#    ghostty
    avalonia-ilspy
    ollama
    podman
#    tmux
    zellij
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
    ".config/alacritty/alacritty.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/alacritty.toml";

# starship config file
    ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/starship.toml";

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
    };

    initContent = ''
      eval "$(starship init zsh)"
    '';
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
