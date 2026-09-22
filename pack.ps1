#Requires -Version 7.0
param(
    [string]$Version = $null,
    [switch]$SkipTests
)

$ErrorActionPreference = 'Stop'
$DistDir = Join-Path $PSScriptRoot '.dist'
$BuildDir = Join-Path $PSScriptRoot '.build'

function Get-NextVersion {
    $lastTag = git describe --tags --abbrev=0 2>$null
    if ($lastTag) {
        $current = [Version]($lastTag -replace '^v', '')
        return "$($current.Major).$($current.Minor).$($current.Build + 1)"
    }
    return "0.1.0"
}

Push-Location $PSScriptRoot
try {
    if (-not $Version) {
        $Version = Get-NextVersion
        Write-Host "Auto-detected version: $Version" -ForegroundColor Yellow
    }

    if (Test-Path $DistDir) { Remove-Item $DistDir -Recurse -Force }
    New-Item -ItemType Directory -Path $DistDir -Force | Out-Null

    & ./build.ps1; if ($LASTEXITCODE -ne 0) { throw "Build failed" }
    if (-not $SkipTests) { & ./test.ps1; if ($LASTEXITCODE -ne 0) { throw "Tests failed" } }

    $zipPath = Join-Path $DistDir "aa-sdlc-$Version.zip"
    Compress-Archive -Path (Join-Path $BuildDir 'aa-sdlc') -DestinationPath $zipPath

    @{ Version = $Version; BuildDate = (Get-Date -Format 'o'); GitCommit = (git rev-parse HEAD 2>$null) } |
        ConvertTo-Json | Set-Content (Join-Path $DistDir 'version.json')

    Write-Host "Packaging complete: $zipPath" -ForegroundColor Green
} finally { Pop-Location }
