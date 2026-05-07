# mpv-lazy 配置还原

param([string]$Source = $PSScriptRoot)

Write-Host "=== mpv-lazy 配置还原 ===" -ForegroundColor Cyan

$src = Join-Path $Source "portable_config"
$dst = "D:\Tools\mpv-lazy\portable_config"

if (Test-Path $src) {
    if (-not (Test-Path $dst)) { New-Item -ItemType Directory -Path $dst -Force | Out-Null }
    Get-ChildItem $src | Copy-Item -Destination $dst -Recurse -Force
    Write-Host "已还原到 $dst" -ForegroundColor Green
} else {
    Write-Host "未找到 portable_config/" -ForegroundColor Red
}
