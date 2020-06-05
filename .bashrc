if [ -f ~/.bash_init ]; then
    . ~/.bash_init
fi

export PATH="/usr/local/golang/1.14.1/bin:$PATH"
export GOPATH="$HOME/works/go"
export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct

#export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static

export NVS_HOME="$HOME/.nvs"
[ -s "$NVS_HOME/nvs.sh" ] && . "$NVS_HOME/nvs.sh"

export DENO_INSTALL="/home/jaron/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

export PATH="$HOME/.yarn/bin:$PATH"
