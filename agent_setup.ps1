# execute this file:
#   sudo powershell .\agent_setup.ps1

# 创建一个指向现有文件的软链接
$sourceAgentFile = "$PSScriptRoot\AGENTS.md"

@(
  "$env:USERPROFILE\.pi\agent\AGENTS.md",
  "$env:USERPROFILE\.claude\CLAUDE.md"
) | ForEach-Object {

  $linkFile = $_

  if (Test-Path $linkFile) {
    Write-Host "$linkFile already created!"
  } else {
    New-Item -ItemType SymbolicLink -Path $linkFile -Target $sourceAgentFile
  }
}


