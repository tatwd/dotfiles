# Install scoop
# 可以通过下面方式修改到指定安装路径
# for current user (default: ~/scoop):
#   $env:SCOOP='Your_Scoop_Path'
#   [Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')
# for global user (default: C:\ProgramData\scoop):
#   $env:SCOOP_GLOBAL='F:\GlobalScoopApps'
#   [environment]::setEnvironmentVariable('SCOOP_GLOBAL',$env:SCOOP_GLOBAL,'Machine')
#
# Handle https connot connect error:
#   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# Open a PowerShell terminal (version 5.1 or later) and run:
#   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
#   iwr -useb get.scoop.sh | iex
# 国内镜像
#   iwr -useb https://gitee.com/glsnames/scoop-installer/raw/master/bin/install.ps1 | iex
#   scoop config SCOOP_REPO 'https://gitee.com/glsnames/scoop-installer'
# Uninstall scoop:
#   scoop uninstall scoop

$DOTFILES_DIR="$HOME\tatwd\dotfiles"
$SCOOP_DIR="$HOME\scoop"
#$my_dotfiles_prefix = "https://raw.githubusercontent.com/tatwd/dotfiles/master"

# scoop config proxy 127.0.0.1:7890
# scoop config proxy none # 直连
# scoop config proxy default # system proxy settings
# scoop config rm proxy

#scoop install 7zip git aria2
#scoop update
# scoop checkup
# scoop cleanup # clean old version apps

# scoop install aria2
# aria2 Scoop 中默认开起
# scoop config aria2-enabled true
# # 关于以下参数的作用，详见 aria2 的相关资料
# scoop config aria2-retry-wait 4
# scoop config aria2-split 16
# scoop config aria2-max-connection-per-server 16
# scoop config aria2-min-split-size 4M

# add buckets
@(
    "main",
    "extras",
    "nerd-fonts",
    "versions",
    "nirsoft",
    "nonportable",
# "java",
    "sysinternals",
    "games"
) | ForEach-Object {
    scoop bucket add $_
}

# 添加中国常用软件 bucket or not
# 更多 bucket 源可自行查找 https://scoop.sh/#/buckets
# scoop bucket add scoopcn https://github.com/scoopcn/scoopcn.git
# scoop bucket add scoop https://github.com/dodorz/scoop

@(
    @{name="dorado"; url="https://github.com/chawyehsu/dorado.git"}
    ,@{name="scoopet"; url="https://github.com/ivaquero/scoopet.git"}
    # ,@{name="anderlli0053_DEV-tools"; url="https://github.com/anderlli0053/DEV-tools.git"},
) | ForEach-Object {
    scoop bucket add $_.name $_.url
}

# scoop bucket list

# to install app list
# can search in https://scoop.sh/#/apps

$gloabal_apps = @(
    "FiraCode" #nerd-fonts
    ,"FiraCode-NF" #nerd-fonts
    ,"Maple-Mono" #nerd-fonts
    ,"Maple-Mono-NF" #nerd-fonts
    ,"Maple-Mono-NF-CN" #nerd-fonts
)

$apps = @(
    "pwsh", #main it's coress-platform instead of windows powershell
    "wezterm-nightly",
    "scoop-completion", #extras autocomplete in powershell, enable in $PROFILE
    "starship", # main
    # "figlet", # main
    # "pshazz", # main
    "neovim", #main
    # ,"openssh" #main
    "notepadplusplus", #extras
    # "typora", #extras
    # "marktext", #extras
    # "pandoc", #main
    "vscode", # extras
    #"windows-terminal", # extras
    "powertoys", #extras
    # "googlechrome", # extras
    "chromium", # extras
    #"firefox" # extras
    # "firefox-developer", # versions
    #,"ntop" #main likt `htop`
    #,"ctop" #main top-like container metrics

    # "tortoisesvn", #extras
    "rider", #extras
    # "datagrip", #extras
    # "docker", #main
    "podman", #main

    # "dotnet-sdk", # main
    # "dotnet-sdk-lts", # versions
    # "dotnet2-sdk", # versions
    # "dotnet3-sdk", # versions
    "nodejs-lts", # main
    # "rustup", #main
    # "go", #main
    # ,"python" #main
    "uv"

    # ,"vlc" #extras
    # ,"dbeaver" #extras

    #,"wpsoffice" #extras english version
    # ,"wps" #scoopcn
    # ,"wxwork" #scoopcn
    # ,"wechat" #scoopcn

    ,"sumatrapdf" #extras
    #,"mobaxterm" #extras
    #,"putty" #extras
    # ,"spacesniffer" #extras
    #,"dismplusplus" #extras
    # ,"draw.io" #extras
    ,"postman" #extras

    # ,"pstools" #sysinternals
    # ,"tcpview" #sysinternals
    # ."procdump" #sysinternals
    ,"ilspy"
    ,"perfview"
    ,"sysinternals-suite" #sysinternals
    #,"CurrPorts" #nirsoft
    #,"SmartSniff" #nirsoft
    ,"openwithplusplus" #extras

    #,"thunderbird" #extras email client
    # ,"sql-server-management-studio-np" #nonportable
    #,"tectonic" #main texlive wrapper
    # ,"vcpkg"

    # ,"trafficmonitor"
    #,"miller"
    #,"hostctl"
    ,"fd"
    ,"ripgrep"
    # ,"bat"
    ,"fzf"
    ,"jq"
    ,"cc-switch"
    ,"mitmproxy"

    # ,"clash-verge-rev"
    # ,"clash-verge" #dorado
    # ,"dingtalk" #dorado
    # ,"netneteasemusic" #dorado
    #,"pwsafe"
)

if ($apps.Contains("rustup")) {
    $env:RUSTUP_DIST_SERVER="https://mirrors.ustc.edu.cn/rust-static"
}

# Write-Output $apps.length

$gloabal_apps | ForEach-Object {
    # must enabled sudo in window developer setting
    sudo scoop install -g $_
}

$apps | ForEach-Object {
    scoop install $_
}

#switch version of your app
#scoop reset version_you_selected

# function download {
#     param(
#         [string]$url,
#         [string]$dist
#     )

#     $dist_full_path = [System.IO.Path]::GetFullPath($dist)
#     $dist_full_dir = [System.IO.Path]::GetDirectoryName($dist_full_path)

#     if (!(Test-Path -LiteralPath $dist_full_dir)) {
#         New-Item -Path $dist_full_dir -ItemType Directory
#     }

#     $tmp = New-TemporaryFile

#     try {
#         Invoke-WebRequest -Uri $url -OutFile $tmp
#         Copy-Item $tmp $dist_full_path
#     } finally {
#         Remove-Item $tmp
#         # Write-Output "remove Temporary File"
#     }
# }

$my_ps_profile="$DOTFILES_DIR/Microsoft.PowerShell_profile.ps1"
$user_doc_dir="$HOME\Documents"
$pwsh_profile="$user_doc_dir\Powershell\Microsoft.PowerShell_profile.ps1"
$powershell_profile="$user_doc_dir\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
$vscode_powershell_profile="$user_doc_dir\PowerShell\Microsoft.VSCode_profile.ps1"

$config_files = [System.Collections.ArrayList]@(
    @{url="$DOTFILES_DIR\wezterm.lua"; dist="$HOME\.wezterm.lua"},
    @{url="$DOTFILES_DIR\nvim_init.lua"; dist="$env:LOCALAPPDATA\nvim\init.lua"},
    # set powershell profile
    @{url=$my_ps_profile; dist="$pwsh_profile"},
    @{url=$my_ps_profile; dist="$powershell_profile"}
    # maven settings
    # ,@{url="$my_dotfiles_prefix/.m2.settings.xml"; dist="$HOME/.m2/settings.xml"}
)

if ($apps.Contains("vscode")) {
    $config_files.Add(@{url=$my_ps_profile; dist="$vscode_powershell_profile"})
}

# set starship config
if ($apps.Contains("starship")) {
    $config_files.Add(@{url="$DOTFILES_DIR\starship.toml"; dist="$HOME\.config\starship.toml"})
}

if ($apps.Contains("rustup")) {
    # $config_files.Add(@{url="$my_dotfiles_prefix/.cargo_config"; dist="$HOME/.cargo/config"})
    $config_files.Add(@{url="$DOTFILES_DIR\.cargo_config"; dist="$SCOOP_DIR\persist\rustup\.cargo\config"})
}

# if ($apps.Contains("docker")) {
#     $config_files.Add(@{url="$DOTFILES_DIR\.docker\daemon.json"; dist="$HOME/.docker/daemon.toml"})
# }

if ($apps.Contains("python")) {
    $config_files.Add(@{url="$DOTFILES_DIR\pip.conf"; dist="$HOME\pip\pip.ini"})
}


foreach ($item in $config_files) {
    $url = $item.url
    $dist = $item.dist

#     Write-Output "Download $url -> $dist"
#     download -url $url -dist $dist

    if (Test-Path $dist) {
        Write-Output "Already exists $dist"
        continue
    }

    $distDir = [System.IO.Path]::GetDirectoryName($dist)
    if (!(Test-Path -LiteralPath $distDir)) {
        New-Item -Path $distDir -ItemType Directory
    }

    Write-Output "Create SymbolicLink $dist -> $url"
    New-Item -ItemType SymbolicLink -Path $dist  -Target $url
}

# 下载目录
# $downloadDir = "$HOME/Downloads"

# Download & Install vs2022
# $vsVersion = "VS2022"
# $sku = "community"
# $downloadVSLink = "https://c2rsetup.officeapps.live.com/c2r/downloadVS.aspx?sku=$sku&channel=Release&version=$vsVersion&source=powershell"
# $vsSetupExe = "$downloadDir/vsSetup.exe"
# download -url $downloadVSLink -dist $vsSetupExe 

# 立即执行安装 or not
# Invoke-Item $outSetupExe 

# 下载 SQL Server Management Studio (SSMS)
# https://docs.microsoft.com/zh-cn/sql/ssms/download-sql-server-management-studio-ssms
# $ssmsLanguageCode = "0x804" #简体中文版
# $ssmsDownloadLink = "https://aka.ms/ssmsfullsetup?clcid=$ssmsLanguageCode"
# $ssmsSetupExe = "$downloadDir/ssmsfullsetup.exe"
# download -url $ssmsDownloadLink -dist $ssmsSetupExe

# 打开下载目录
# Invoke-Item $downloadDir 
