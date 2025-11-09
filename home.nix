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
    bottom
    inetutils
#    unrar
    p7zip

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

    vscode
    google-chrome
    jetbrains.rider
    avalonia-ilspy
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

# wezterm config file
    ".config/wezterm/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/wezterm.lua";

# neovim config file
    ".config/nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/nvim_init.lua";

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
      ".." = "cd ..";
      "..." = "cd ../../";
      hm = "home-manager";
      nix-clean = "nix-collect-garbage --delete-old";
      chrome = "google-chrome-stable";
    };
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

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    configPath = "${dotfilesDir}/starship.toml";
  };

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--max-columns-preview"
      "--colors=line:style:bold"
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
  };

}
