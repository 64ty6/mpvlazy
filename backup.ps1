#requires -Version 7.0
# mpv-lazy 配置备份，播放进度一并保留。
param(
    [string]$SourceDirectory = 'D:\Tools\mpv-lazy\portable_config',
    [string]$Destination = (Join-Path $PSScriptRoot 'Backup' (Get-Date -Format 'yyyyMMdd-HHmmss-fffffff'))
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'scripts/config-common.ps1')

Assert-ApplicationStopped @('mpv')
Assert-RequiredPaths $SourceDirectory @('mpv.conf', 'profiles.conf', 'script-opts.conf', 'input_uosc.conf')
Assert-SeparatePaths $SourceDirectory $Destination
New-BackupDirectory $Destination
$dst = Join-Path $Destination 'portable_config'
Copy-DirectoryContents $SourceDirectory $dst @('_cache')
$progress = Join-Path $SourceDirectory '_cache/watch_later'
if (Test-Path -LiteralPath $progress -PathType Container) {
    Copy-DirectoryContents $progress (Join-Path $dst '_cache/watch_later')
}
Complete-Backup $Destination

