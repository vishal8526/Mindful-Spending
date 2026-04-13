param(
  [string]$Message = "chore: daily graph update"
)

$ErrorActionPreference = 'Stop'
Set-Location "$PSScriptRoot\.."

$today = Get-Date -Format 'yyyy-MM-dd'
$dailyDir = 'daily-log'
$dailyFile = Join-Path $dailyDir "$today.md"

if (-not (Test-Path $dailyDir)) {
  New-Item -ItemType Directory -Path $dailyDir | Out-Null
}

$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
Add-Content -Path $dailyFile -Value "- update at $timestamp"

if ((git status --porcelain).Length -eq 0) {
  Write-Host 'No changes to commit.'
  exit 0
}

git add $dailyFile
git commit -m $Message
git push

Write-Host "Daily commit pushed: $dailyFile"
