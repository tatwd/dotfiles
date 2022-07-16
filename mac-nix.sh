sh <(curl https://mirrors.tuna.tsinghua.edu.cn/nix/latest/install)

nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable nixpkgs

nix-channel --update
