set-alias unzip Expand-Archive
set-alias zip Compress-Archive
set-alias trash Remove-ItemSafely
set-alias which Get-Command

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
	Get-Process -Id (Get-NetTCPConnection -LocalPort $port).OwningProcess
}

function goworks {
  #replace yourself
	set-location 'd:/works'
}

function psfd($v) {
	Get-Process | where {$_.ProcessName -match $v -or $_.Id -match $v}
}

#set-location 'd:/works'

#try { $null = gcm pshazz -ea stop; pshazz init } catch { }
#Import-Module posh-git
#Import-Module oh-my-posh
#Set-Theme Sorin
#Set-Prompt
#Set-Theme Agnoster

Invoke-Expression (&starship init powershell)
