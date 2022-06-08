# Install scoop
# Change scoop home path: 
#   $env:SCOOP='Your_Scoop_Path'
#   [Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')
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
    "extras",
    "nerd-fonts",
    "versions"
    # "jetbrains",
) | ForEach-Object {
    scoop bucket add $_
}

# scoop bucket list

# to install app list
# can search in https://scoop.sh/#/apps
$apps = @(
    "7zip", # main
    "sudo", # main
    # "starship", # main
    # "figlet", # main
    # "pshazz", # main
    "git", # main
    # "notepadplusplus", #extras
    "vscode", # extras
    "windows-terminal", # extras
    "powertoys", #extras
    # "googlechrome", # extras
    "chromium", # extras
    "firefox" # extras
    # "firefox-developer", # versions

    # "tortoisesvn", #extras
    "rider", #extras
    # "datagrip", #extras
    # "docker", #main
    "podman", #main

    "dotnet-sdk", # main
    # "dotnet-sdk-lts", # versions
    # "dotnet2-sdk", # versions
    # "dotnet3-sdk", # versions
    "nodejs-lts", # main
    # "rustup", #main
    # "go", #main

    #,"FiraCode" #nerd-fonts
    ,"FiraCode-NF" #nerd-fonts

    #,"vlc" #extras
    #,"dbeaver" #extras
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
    # set starship config
    @{url="$my_dotfiles_prefix/starship.toml"; dist="$env:USERPROFILE/.config/starship.toml"}
)

# if ($apps.Contains("rustup")) {
#     $config_files.Add(@{url="$my_dotfiles_prefix/.cargo_config"; dist="~/.cargo/config"})
# }

if ($apps.Contains("docker")) {
    $config_files.Add(@{url="$my_dotfiles_prefix/.docker/daemon.json"; dist="~/.docker/daemon.toml"})
}

foreach ($item in $config_files) {
    $url = $item.url
    $dist = $item.dist

    Write-Output "Download $url -> $dist"
    download -url $url -dist $dist
}


# Download & Install vs2022
$vsVersion = "VS2022"
$sku = "community"
$downloadVSLink = "https://c2rsetup.officeapps.live.com/c2r/downloadVS.aspx?sku=$sku&channel=Release&version=$vsVersion&source=powershell"
download -url $downloadVSLink -dist "$env:USERPROFILE/Downloads/vsSetup.exe"
