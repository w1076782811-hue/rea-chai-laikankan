$ErrorActionPreference = 'Stop'

$skillRoot = Split-Path -Parent $PSScriptRoot
$runnerPath = Join-Path $PSScriptRoot 'run_rea.mjs'
$reaEntryPath = Join-Path $skillRoot 'node_modules\rea-agents\scripts\rea.mjs'
$nodeCommand = Get-Command 'node' -ErrorAction SilentlyContinue

if (-not $nodeCommand) {
    throw '未找到 Node.js。请安装受支持的 Node.js，再运行 scripts/install.ps1。'
}

if (-not (Test-Path -LiteralPath $reaEntryPath -PathType Leaf)) {
    throw '缺少 REA 运行依赖。请先运行 scripts/install.ps1。'
}

& $nodeCommand.Source $runnerPath @args
exit $LASTEXITCODE
