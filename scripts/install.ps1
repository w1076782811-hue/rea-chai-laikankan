param(
    [string]$SkillHome = (Join-Path ([Environment]::GetFolderPath('UserProfile')) '.agents\skills\rea_chai_laikankan')
)

$ErrorActionPreference = 'Stop'

function Test-SupportedNodeVersion {
    param([version]$NodeVersion)

    if ($NodeVersion.Major -eq 22) {
        return $NodeVersion -ge [version]'22.19.0'
    }
    if ($NodeVersion.Major -eq 24) {
        return $NodeVersion -ge [version]'24.11.0'
    }
    return $NodeVersion.Major -ge 26
}

$skillRoot = Split-Path -Parent $PSScriptRoot
$nodeCommand = Get-Command 'node' -ErrorAction SilentlyContinue
$npmCommand = Get-Command 'npm.cmd' -ErrorAction SilentlyContinue

if (-not $nodeCommand -or -not $npmCommand) {
    throw '需要 Node.js 和 npm。请先安装 Node.js 22.19+、24.11+ 或 26+。'
}

$nodeVersionText = (& $nodeCommand.Source --version).TrimStart('v')
$nodeVersion = [version]$nodeVersionText
if (-not (Test-SupportedNodeVersion -NodeVersion $nodeVersion)) {
    throw "Node.js $nodeVersionText 不受 REA 6.4.0 支持。请安装 22.19+、24.11+ 或 26+。"
}

& $npmCommand.Source ci --prefix $skillRoot --ignore-scripts --omit=optional
if ($LASTEXITCODE -ne 0) {
    throw "npm ci 失败，退出码：$LASTEXITCODE"
}

$skillParent = Split-Path -Parent $SkillHome
New-Item -ItemType Directory -Path $skillParent -Force | Out-Null

if (Test-Path -LiteralPath $SkillHome) {
    $existingItem = Get-Item -LiteralPath $SkillHome -Force
    $existingPath = if ($existingItem.LinkType -eq 'Junction') {
        [System.IO.Path]::GetFullPath([string]$existingItem.Target)
    } else {
        [System.IO.Path]::GetFullPath($existingItem.FullName)
    }
    $expectedPath = [System.IO.Path]::GetFullPath($skillRoot)
    if ($existingPath -ne $expectedPath) {
        throw "Skill 目录已经存在：$SkillHome。请先确认并移除旧版本，再重新运行安装脚本。"
    }
} else {
    New-Item -ItemType Junction -Path $SkillHome -Target $skillRoot | Out-Null
}

Write-Output "REA 运行依赖已安装：$skillRoot"
Write-Output "Codex Skill 已注册：$SkillHome"
Write-Output '重新打开 Codex 对话后，可输入 $REA拆来看看 调用。'
