#Requires -Version 7.0
<#
.SYNOPSIS
    Bootstraps a fresh clone so build, test, and pack can run.
.DESCRIPTION
    The root initialize script required by opinion O-06. Installs the tools this repository
    needs if they are missing (Pester for the test tiers, powershell-yaml for the validators,
    PSScriptAnalyzer for the lint switch on build, the Go toolchain for the aa CLI), creates
    the local working folders, and reports what it did. Safe to run repeatedly. There is no
    seed data for this repository.
.PARAMETER SkipTools
    Do not install missing tools; only report them.
.EXAMPLE
    ./initialize.ps1
#>
[CmdletBinding()]
param(
    [Parameter()]
    [switch]$SkipTools
)

$ErrorActionPreference = 'Stop'

function Install-WingetPackageIfMissing {
    param([string]$PackageId, [string]$Command, [string]$Display)
    if (Get-Command $Command -ErrorAction SilentlyContinue) {
        Write-Host "  $Display present: $((& $Command version 2>$null | Select-Object -First 1))" -ForegroundColor Green
        return
    }
    if ($SkipTools) {
        Write-Host "  $Display missing (skipped)" -ForegroundColor Yellow
        return
    }
    Write-Host "  Installing $Display via winget..." -ForegroundColor Yellow
    winget install --id $PackageId --silent --accept-package-agreements --accept-source-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
    [System.Environment]::GetEnvironmentVariable('Path', 'User')
}

function Install-PSModuleIfMissing {
    param([string]$Name)
    if (Get-Module -ListAvailable -Name $Name) {
        Write-Host "  $Name present" -ForegroundColor Green
        return
    }
    if ($SkipTools) {
        Write-Host "  $Name missing (skipped)" -ForegroundColor Yellow
        return
    }
    Write-Host "  Installing $Name..." -ForegroundColor Yellow
    Install-Module $Name -Scope CurrentUser -Force -SkipPublisherCheck
}

Push-Location $PSScriptRoot
try {
    Write-Host 'Tools' -ForegroundColor Cyan
    Install-PSModuleIfMissing -Name 'Pester'
    Install-PSModuleIfMissing -Name 'powershell-yaml'
    Install-PSModuleIfMissing -Name 'PSScriptAnalyzer'
    Install-WingetPackageIfMissing -PackageId 'GoLang.Go' -Command 'go' -Display 'Go'

    Write-Host 'Folders' -ForegroundColor Cyan
    foreach ($dir in '.aitemp', (Join-Path 'tests' 'integration'), (Join-Path 'tests' 'e2e')) {
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        Write-Host "  $dir" -ForegroundColor Green
    }

    Write-Host 'Ready. Next: ./build.ps1, ./test.ps1, ./pack.ps1' -ForegroundColor Green
} finally { Pop-Location }
