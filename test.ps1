#Requires -Version 7.0
<#
.SYNOPSIS
    Runs the repository's tests, by tier.
.DESCRIPTION
    The root test script required by opinions O-06 and O-07. The unit tier runs the structural
    validators for the content package and feature files plus any Pester tests that live with a
    project under src/. The integration and e2e tiers run the Pester tests in tests/integration
    and tests/e2e. A tier with nothing to run passes and says so.
.PARAMETER Tier
    Which tier to run: unit, integration, e2e, or all (the default).
.PARAMETER Filter
    Optional Pester full-name filter (wildcards allowed) applied to every tier that runs Pester.
.EXAMPLE
    ./test.ps1
    ./test.ps1 -Tier unit
    ./test.ps1 -Tier e2e -Filter '*setup*'
#>
[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet('all', 'unit', 'integration', 'e2e')]
    [string]$Tier = 'all',

    [Parameter()]
    [string]$Filter
)

$ErrorActionPreference = 'Stop'

function Invoke-PesterTier {
    param([string]$Name, [string[]]$Paths)

    $files = foreach ($p in $Paths) {
        Get-ChildItem -Path $p -Recurse -Filter '*.Tests.ps1' -File -ErrorAction SilentlyContinue
    }
    if (-not $files) {
        Write-Host "[$Name] no Pester tests found." -ForegroundColor Yellow
        return
    }

    if (-not (Get-Module -ListAvailable -Name Pester)) {
        throw 'Pester is not installed. Run ./initialize.ps1 first.'
    }

    $config = New-PesterConfiguration
    $config.Run.Path = $files.FullName
    $config.Run.PassThru = $true
    if ($Filter) { $config.Filter.FullName = $Filter }

    $result = Invoke-Pester -Configuration $config
    if ($result.FailedCount -gt 0) { throw "[$Name] $($result.FailedCount) test(s) failed." }
    Write-Host "[$Name] $($result.PassedCount) passed." -ForegroundColor Green
}

Push-Location $PSScriptRoot
try {
    if ($Tier -in 'all', 'unit') {
        $problems = @()
        $problems += & (Join-Path 'scripts' 'Test-SkillStructure.ps1')
        $problems += & (Join-Path 'scripts' 'Test-FeatureStructure.ps1')
        $problems += & (Join-Path 'scripts' 'Test-WorkflowStructure.ps1')
        # Every skill carries its guidance verbatim from docs/guidance.md (decision record 0011)
        $problems += & (Join-Path 'scripts' 'Test-SkillGuidance.ps1')
        # The website must be current with the workflow data when its repository is checked out (decision record 0007)
        $problems += & (Join-Path 'scripts' 'Test-WebsiteCurrency.ps1')
        if ($problems.Count -gt 0) {
            $problems | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
            throw "[unit] structural validation failed with $($problems.Count) problem(s)."
        }
        Write-Host '[unit] structural validation passed.' -ForegroundColor Green

        # The aa CLI's Go tests live with the module (O-07); they need the embedded content present
        & (Join-Path 'scripts' 'Sync-EmbeddedContent.ps1') | Out-Null
        Push-Location (Join-Path 'src' 'aa-sdlc-cli')
        try {
            $goArgs = @('test', './...')
            if ($Filter) { $goArgs += @('-run', $Filter) }
            & go @goArgs
            if ($LASTEXITCODE -ne 0) { throw '[unit] go test failed.' }
            Write-Host '[unit] go test passed.' -ForegroundColor Green
        } finally { Pop-Location }

        Invoke-PesterTier -Name 'unit' -Paths @('src')
    }

    if ($Tier -in 'all', 'integration') {
        # The @cli feature files run with godog against the built binary (decision record 0005)
        $exe = if ($IsWindows) { 'aa.exe' } else { 'aa' }
        $bin = Join-Path $PSScriptRoot '.build' 'aa-sdlc-cli' $exe
        if (-not (Test-Path $bin)) { & (Join-Path $PSScriptRoot 'build.ps1') | Out-Null }
        Push-Location (Join-Path 'tests' 'integration')
        try {
            $env:AA_BIN = $bin
            $goArgs = @('test', './...', '-count=1')
            if ($Filter) { $goArgs += @('-run', $Filter) }
            & go @goArgs
            if ($LASTEXITCODE -ne 0) { throw '[integration] feature tests failed.' }
            Write-Host '[integration] feature tests passed.' -ForegroundColor Green
        } finally {
            Remove-Item Env:AA_BIN -ErrorAction SilentlyContinue
            Pop-Location
        }
        Invoke-PesterTier -Name 'integration' -Paths @((Join-Path 'tests' 'integration'))
    }

    if ($Tier -in 'all', 'e2e') {
        Invoke-PesterTier -Name 'e2e' -Paths @((Join-Path 'tests' 'e2e'))
    }
} finally { Pop-Location }
