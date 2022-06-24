set-alias unzip Expand-Archive
set-alias zip Compress-Archive
set-alias trash Remove-ItemSafely
set-alias which Get-Command

function Test-Command($cmdname) {
  return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

function open($file) {
  invoke-item $file
}

function uprofile {
  & $profile
}

function lspath {
  ($Env:Path).Split(";")
}

function get-process-for-port($port) {
  # `sudo` is installed by scoop
  sudo Get-Process -Id (Get-NetTCPConnection -LocalPort $port).OwningProcess -IncludeUserName
}

function goworks {
  set-location 'd:/works'
}

function psfd($v) {
  Get-Process | where {$_.ProcessName -match $v -or $_.Id -match $v}
}

function setproxy {
  #git
  git config --global http.proxy "http://127.0.0.1:7890"
  git config --global https.proxy "http://127.0.0.1:7890"
  echo "set git proxy ok"
}

function unsetproxy($v) {
  #git
  git config --global --unset http.proxy
  git config --global --unset https.proxy
  echo "unset git proxy ok"
}

#set-location 'd:/works'

#try { $null = gcm pshazz -ea stop; pshazz init } catch { }
#Import-Module posh-git
#Import-Module oh-my-posh
#Set-Theme Sorin
#Set-Prompt
#Set-Theme Agnoster

if (Test-Command starship) {
  Invoke-Expression (&starship init powershell)
}

if (Test-Command scoop.ps1) {
  $completeModulePath = "$($(Get-Item $(Get-Command scoop.ps1).Path).Directory.Parent.FullName)\modules\scoop-completion"
  if (Test-Path $completeModulePath) {
    Import-Module  $completeModulePath
  }
}

if (Test-Command rustup) {
  #$env:RUSTUP_DIST_SERVER="https://mirrors.tuna.tsinghua.edu.cn/rustup"
  $env:RUSTUP_DIST_SERVER="https://mirrors.ustc.edu.cn/rust-static"
}



