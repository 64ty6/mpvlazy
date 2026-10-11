#requires -Version 7.0
# mpv-lazy 配置恢复，现有配置先备份。
param(
    [string]$Source = $PSScriptRoot,
    [string]$ProgramDirectory = 'D:\Tools\mpv-lazy'
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'scripts/config-common.ps1')

Assert-ApplicationStopped @('mpv')
Assert-RequiredPaths $ProgramDirectory @('mpv.exe')
$src = Join-Path $Source 'portable_config'
Assert-RequiredPaths $src @('mpv.conf', 'profiles.conf', 'script-opts.conf', 'input_uosc.conf')
if (Test-Path -LiteralPath (Join-Path $Source '.backup-incomplete')) { throw '该备份尚未完成，不能恢复。' }
Restore-Configuration @(@{ Source = $src; Destination = (Join-Path $ProgramDirectory 'portable_config') })

