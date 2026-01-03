set-alias unzip Expand-Archive
set-alias zip Compress-Archive
set-alias trash Remove-ItemSafely
set-alias which Get-Command
set-alias open Invoke-Item

function cd.. { cd .. }
set-alias .. cd..

function cd... { cd ../../ }
set-alias ... cd...

# Set-Alias -Name tfc -Value D:\tools\TEE-CLC-14.135.3\tf.cmd 

function openhosts {
  notepad "C:\Windows\System32\drivers\etc\hosts"
}

function Test-Command($cmdname) {
  return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

function uprofile {
  . $PROFILE
}

function lspath {
  ($env:Path).Split(";")
}

function get-process-for-port($port) {
  # `sudo` is installed by scoop
  sudo Get-Process -Id (Get-NetTCPConnection -LocalPort $port).OwningProcess -IncludeUserName
}

function goworks {
  set-location "$HOME/works"
}

function psfd($v) {
  Get-Process | where {$_.ProcessName -match $v -or $_.Id -match $v}
}

function getproxysetting {
  $setting = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
  return @{ enable = $setting.ProxyEnable; server = $setting.ProxyServer  }
}

function setproxy {
  $setting = getproxysetting
  $server = $setting.server
  Write-Output "proxy server: $server"

  $env:http_proxy="http://$server";
  $env:https_proxy="http://$server"
  Write-Output "set env http_proxy,https_proxy done!"

  #git
  git config --global http.proxy $env:http_proxy
  git config --global https.proxy $env:https_proxy
  Write-Output "set git proxy done!"

  #scoop
  scoop config proxy $server
  Write-Output "set scoop proxy done!"
}

function unsetproxy {
  $env:http_proxy="";
  $env:https_proxy=""
  Write-Output "unset env http_proxy,https_proxy done!"

  #git
  git config --global --unset http.proxy
  git config --global --unset https.proxy
  Write-Output "unset git proxy ok"

    #scoop
  scoop config proxy none
  Write-Output "unset scoop proxy ok!"
}

# # making sure a bunch of folders exist:
# 'C:\test1', 'C:\test2' | Assert-FolderExists

# # making sure the path assigned to a variable exists:
# ($Path = 'c:\test3') | Assert-FolderExists
# filter Assert-FolderExists
# {
#   $exists = Test-Path -Path $_ -PathType Container
#   if (!$exists) { 
#     Write-Warning "$_ did not exist. Folder created."
#     $null = New-Item -Path $_ -ItemType Directory 
#   }
# }

function Assert-FolderExists
{
  param
  (
    [Parameter(Mandatory,ValueFromPipeline)]
    [string[]]
    $Path
  )
  
  process
  {
    foreach($_ in $Path)
    {
      $exists = Test-Path -Path $_ -PathType Container
      if (!$exists) { 
        Write-Warning "$_ did not exist. Folder created."
        $null = New-Item -Path $_ -ItemType Directory 
      }
    }
  }
}

function newpass {
  $source = '0123456789abcdefghijklmnopqistuvwxyzABCDEFGHIJKLMNOPQISTUVWXYZ_!@#$%.,-+=?'
  $passwords = 0..10

  for ($i = 0; $i -le ($passwords.length - 1); $i += 1) {
    $idx = random -Maximum $source.length
    $passwords[$i] = $source[$idx] 
  }

  return Join-String -InputObject $passwords
}

#set-location 'd:/works'

#try { $null = gcm pshazz -ea stop; pshazz init } catch { }
#Import-Module posh-git
#Import-Module oh-my-posh
#Set-Theme Sorin
#Set-Prompt
#Set-Theme Agnoster

$env:SCOOP="$HOME\scoop"

if (Test-Command podman) {
  set-alias docker podman
}

if (Test-Command starship) {
  Invoke-Expression (&starship init powershell)
}

if (Test-Command scoop.ps1) {
  $completeModulePath = "$env:SCOOP\modules\scoop-completion"
  if (Test-Path $completeModulePath) {
    Import-Module  $completeModulePath
  }
}

if (Test-Command rustup) {
  #$env:RUSTUP_DIST_SERVER="https://mirrors.tuna.tsinghua.edu.cn/rustup"
  $env:RUSTUP_DIST_SERVER="https://mirrors.ustc.edu.cn/rust-static"
}

if (Test-Command conda) {
  (& conda 'shell.powershell' 'hook') | Out-String | Invoke-Expression
}

# PowerShell parameter completion shim for the dotnet CLI
# from https://docs.microsoft.com/zh-cn/dotnet/core/tools/enable-tab-autocomplete?WT.mc_id=modinfra-35653-salean#powershell
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
  param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
      [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

#Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
#Set-PSReadlineKeyHandler -Key Ctrl+UpArrow -Function HistorySearchBackward
#Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward


# 关闭 dotnet-cli 遥测
$env:DOTNET_CLI_TELEMETRY_OPTOUT=1

$env:OLLAMA_MODELS="D:\cache\ollama-models"
#$env:OLLAMA_ORIGINS="https://ollama-ui.github.io"

$env:API_TIMEOUT_MS=600000
$env:CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
$env:CLAUDE_CODE_GIT_BASH_PATH="$env:SCOOP\apps\git\current\bin\bash.exe"
