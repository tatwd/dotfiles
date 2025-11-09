sh <(curl https://mirrors.tuna.tsinghua.edu.cn/nix/latest/install)

nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable nixpkgs
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# nix-channel --add https://gh.llkk.cc/https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

nix-channel --update
