# Install scoop
# 可以通过下面方式修改到指定安装路径: 
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

# scoop config proxy 127.0.0.1:8980
# scoop config proxy none # 直连
# scoop config proxy default # system proxy settings
# scoop config rm proxy

scoop update
# scoop checkup
# scoop cleanup # clean old version apps

# scoop install aria2
# aria2 在 Scoop 中默认开启
# scoop config aria2-enabled true
# # 关于以下参数的作用，详见aria2的相关资料
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
    "nonportable"
) | ForEach-Object {
    scoop bucket add $_
}

# 添加中国常用软件 bucket or not
# 更多 bucket 源可自行查找 https://scoop.sh/#/buckets
# scoop bucket add scoopcn https://github.com/scoopcn/scoopcn.git

# scoop bucket list

# to install app list
# can search in https://scoop.sh/#/apps
$apps = @(
    "7zip", # main
    "sudo", # main
    ,"pwsh" #main it's coress-platform instead of windows powershell
    ,"scoop-completion" #extras autocomplete in powershell, enable in $PROFILE
    "starship", # main
    # "figlet", # main
    # "pshazz", # main
    "git", # main
    # ,"vim" #main
    # ,"openssh" #main
    "notepadplusplus", #extras
    # "typora", #extras
    # "marktext", #extras
    # "pandoc", #main
    "vscode", # extras
    "windows-terminal", # extras
    "powertoys", #extras
    # "googlechrome", # extras
    "chromium", # extras
    "firefox" # extras
    # "firefox-developer", # versions
    #,"ntop" #main likt `htop`
    #,"ctop" #main top-like container metrics

    # "tortoisesvn", #extras
    "rider", #extras
    # "datagrip", #extras
    # "docker", #main
    # "podman", #main

    "dotnet-sdk", # main
    # "dotnet-sdk-lts", # versions
    # "dotnet2-sdk", # versions
    # "dotnet3-sdk", # versions
    "nodejs-lts", # main
    # "rustup", #main
    # "go", #main
    # ,"python" #main

    ,"FiraCode" #nerd-fonts
    #,"FiraCode-NF" #nerd-fonts

    # ,"vlc" #extras
    # ,"dbeaver" #extras

    ,"wpsoffice" #extras english version
    # ,"wps" #scoopcn
    # ,"wxwork" #scoopcn
    # ,"wechat" #scoopcn

    ,"sumatrapdf" #extras
    #,"mobaxterm" #extras
    #,"putty" #extras
    #,"spacesniffer" #extras
    #,"dismplusplus" #extras
    #,"draw.io" #extras
    #,"postman" #extras

    ,"CurrPorts" #nirsoft
    #,"SmartSniff" #nirsoft
    ,"openwithplusplus" #extras

    #,"thunderbird" #extras email client
    #,"sql-server-management-studio-np" #nonportable
    #,"tectonic" #main texlive wrapper
)
# Write-Output $apps.length
$apps | ForEach-Object {
    scoop install $_
}

#switch version of your app
#scoop reset version_you_selected

function download {
    param(
        [string]$url,
        [string]$dist
    )

    $dist_full_path = [System.IO.Path]::GetFullPath($dist)
    $dist_full_dir = [System.IO.Path]::GetDirectoryName($dist_full_path)

    if (!(Test-Path -LiteralPath $dist_full_dir)) {
        New-Item -Path $dist_full_dir -ItemType Directory
    }

    $tmp = New-TemporaryFile

    try {
        Invoke-WebRequest -Uri $url -OutFile $tmp
        Copy-Item $tmp $dist_full_path
    } finally {
        Remove-Item $tmp
        # Write-Output "remove Temporary File"
    }
}

# my dotfiles repository raw url prefix
$my_dotfiles_prefix = "https://raw.githubusercontent.com/tatwd/dotfiles/master"

$config_files = [System.Collections.ArrayList]@(
    # set powershell profile
    @{url="$my_dotfiles_prefix/Microsoft.PowerShell_profile.ps1"; dist="$PROFILE"},
)

# set starship config
if ($app.Contains("starship")) {
    $config_files.Add(@{url="$my_dotfiles_prefix/starship.toml"; dist="$HOME/.config/starship.toml"})
}

# if ($apps.Contains("rustup")) {
#     $config_files.Add(@{url="$my_dotfiles_prefix/.cargo_config"; dist="$HOME/.cargo/config"})
#     $env:RUSTUP_DIST_SERVER='https://mirrors.tuna.tsinghua.edu.cn/rustup'
#     [Environment]::SetEnvironmentVariable('RUSTUP_DIST_SERVER', $env:RUSTUP_DIST_SERVER, 'User')
# }

if ($apps.Contains("docker")) {
    $config_files.Add(@{url="$my_dotfiles_prefix/.docker/daemon.json"; dist="$HOME/.docker/daemon.toml"})
}

foreach ($item in $config_files) {
    $url = $item.url
    $dist = $item.dist

    Write-Output "Download $url -> $dist"
    download -url $url -dist $dist
}

# 下载目录
$downloadDir = "$HOME/Downloads"

# Download & Install vs2022
$vsVersion = "VS2022"
$sku = "community"
$downloadVSLink = "https://c2rsetup.officeapps.live.com/c2r/downloadVS.aspx?sku=$sku&channel=Release&version=$vsVersion&source=powershell"
$vsSetupExe = "$downloadDir/vsSetup.exe"
download -url $downloadVSLink -dist $vsSetupExe 
# 立即执行安装 or not
# Invoke-Item $outSetupExe 

# 下载 SQL Server Management Studio (SSMS)
# https://docs.microsoft.com/zh-cn/sql/ssms/download-sql-server-management-studio-ssms
# $ssmsLanguageCode = "0x804" #简体中文版
# $ssmsDownloadLink = "https://aka.ms/ssmsfullsetup?clcid=$ssmsLanguageCode"
# $ssmsSetupExe = "$downloadDir/ssmsfullsetup.exe"
# download -url $ssmsDownloadLink -dist $ssmsSetupExe

# 打开下载目录
Invoke-Item $downloadDir 
