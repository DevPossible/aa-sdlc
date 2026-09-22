#Requires -Version 7.0
<#
.SYNOPSIS
    Validates the content package and feature files and assembles .build/aa-sdlc.
.DESCRIPTION
    The root build script required by opinion O-06. Cleans .build, runs the structural
    validators, and copies the content package into .build/aa-sdlc with a build-info file.
    With -Lint it also runs the conventions the repository enforces by tool (O-21, R-35): the
    PowerShell formatter in check mode and the PowerShell static analyser over every *.ps1, and
    fails on any finding. The structural validators serve as the linters for YAML, feature, and
    markdown content; see docs/development-environment.md.
.PARAMETER Lint
    Run the formatter check and the static analyser in addition to the build.
.EXAMPLE
    ./build.ps1
    ./build.ps1 -Lint
#>
[CmdletBinding()]
param(
    [Parameter()]
    [switch]$Lint
)

$ErrorActionPreference = 'Stop'

$BuildDir = Join-Path $PSScriptRoot '.build'
$SourceRoot = Join-Path $PSScriptRoot 'src' 'aa-sdlc'

#region Build Directory Cleanup
function Clear-BuildDirectory {
    param([string]$Path)

    if (-not (Test-Path $Path)) { return }

    Write-Host "Cleaning previous build..." -ForegroundColor Yellow

    $lockedFiles = @()
    Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
        try {
            $stream = [System.IO.File]::Open($_.FullName, 'Open', 'ReadWrite', 'None')
            $stream.Close()
            $stream.Dispose()
        } catch [System.IO.IOException] { $lockedFiles += $_.FullName }
        catch [System.UnauthorizedAccessException] { $lockedFiles += $_.FullName }
    }

    if ($lockedFiles.Count -gt 0) {
        Write-Host "`nBuild failed: Files are locked by another process." -ForegroundColor Red
        $lockedFiles | ForEach-Object { Write-Host "  $_" -ForegroundColor Yellow }
        throw "Cannot clean build directory: $($lockedFiles.Count) file(s) are locked."
    }

    Remove-Item $Path -Recurse -Force
}
#endregion

#region Lint
function Invoke-Lint {
    if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
        throw 'PSScriptAnalyzer is not installed. Run ./initialize.ps1 first.'
    }
    Import-Module PSScriptAnalyzer

    $scripts = Get-ChildItem -Path $PSScriptRoot -Recurse -Filter '*.ps1' -File |
        Where-Object { $_.FullName -notmatch '[\\/](\.build|\.dist|\.tools|\.aitemp|node_modules)[\\/]' }
    $settings = Join-Path $PSScriptRoot 'PSScriptAnalyzerSettings.psd1'

    $findings = @()
    foreach ($file in $scripts) {
        $content = Get-Content $file.FullName -Raw
        $formatted = Invoke-Formatter -ScriptDefinition $content -Settings $settings
        if ($formatted -ne $content) {
            $findings += [pscustomobject]@{ File = $file.FullName; Line = 0; Rule = 'Formatting'; Message = 'File is not formatted; run Invoke-Formatter on it.' }
        }
        $findings += Invoke-ScriptAnalyzer -Path $file.FullName -Settings $settings |
            ForEach-Object { [pscustomobject]@{ File = $_.ScriptPath; Line = $_.Line; Rule = $_.RuleName; Message = $_.Message } }
    }

    if ($findings.Count -gt 0) {
        $findings | ForEach-Object { Write-Host "  $($_.File):$($_.Line) [$($_.Rule)] $($_.Message)" -ForegroundColor Red }
        throw "Lint failed with $($findings.Count) finding(s) across $($scripts.Count) script(s)."
    }
    Write-Host "[lint] $($scripts.Count) script(s) formatted and clean." -ForegroundColor Green
}
#endregion

Push-Location $PSScriptRoot
try {
    Clear-BuildDirectory -Path $BuildDir

    $problems = @()
    $problems += & (Join-Path 'scripts' 'Test-SkillStructure.ps1') -SourceRoot $SourceRoot
    $problems += & (Join-Path 'scripts' 'Test-FeatureStructure.ps1')
    $problems += & (Join-Path 'scripts' 'Test-WorkflowStructure.ps1')
    if ($problems.Count -gt 0) {
        $problems | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
        throw "Validation failed with $($problems.Count) problem(s)."
    }

    if ($Lint) { Invoke-Lint }

    $packageDir = Join-Path $BuildDir 'aa-sdlc'
    New-Item -ItemType Directory -Path $packageDir -Force | Out-Null
    Copy-Item -Path (Join-Path $SourceRoot '*') -Destination $packageDir -Recurse

    @{ BuildDate = (Get-Date -Format 'o'); GitCommit = (git rev-parse HEAD 2>$null) } |
        ConvertTo-Json | Set-Content (Join-Path $packageDir 'build-info.json')

    Write-Host "Build outputs: $BuildDir" -ForegroundColor Green
} finally { Pop-Location }
