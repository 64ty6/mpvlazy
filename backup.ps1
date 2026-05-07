# mpv-lazy 配置备份

$dest = Join-Path $PSScriptRoot "Backup" (Get-Date -Format "yyyyMMdd-HHmmss")
Write-Host "=== mpv-lazy 配置备份 ===" -ForegroundColor Cyan

$src = "D:\Tools\mpv-lazy\portable_config"
if (Test-Path $src) {
    Copy-Item $src (Join-Path $dest "portable_config") -Recurse -Force
    Write-Host "→ $dest" -ForegroundColor Green
}
