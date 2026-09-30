# mpv-lazy 配置备份

$dest = Join-Path $PSScriptRoot "Backup" (Get-Date -Format "yyyyMMdd-HHmmss")
Write-Host "=== mpv-lazy 配置备份 ===" -ForegroundColor Cyan

$src = "D:\Tools\mpv-lazy\portable_config"
if (Test-Path $src) {
    $d = Join-Path $dest "portable_config"
    Copy-Item $src $d -Recurse -Force
    # 剔除着色器编译缓存：mpv 会自动重建，且每次播放都在变动
    Remove-Item (Join-Path $d "_cache") -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "→ $dest" -ForegroundColor Green
}
