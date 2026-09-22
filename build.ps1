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
.PARAMETER Version
    The package version stamped into the CLI binary and build-info.json. Defaults to "dev".
.EXAMPLE
    ./build.ps1
    ./build.ps1 -Lint
#>
[CmdletBinding()]
param(
    [Parameter()]
    [switch]$Lint,

    [Parameter()]
    [string]$Version = 'dev'
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

    # Text conventions for YAML, Gherkin, Markdown, and JSON stand in for a formatter (decision record 0006)
    $textFiles = Get-ChildItem -Path $PSScriptRoot -Recurse -Include '*.yaml', '*.feature', '*.md', '*.json' -File |
        Where-Object { $_.FullName -notmatch '[\\/](\.build|\.dist|\.tools|\.aitemp|node_modules|\.git)[\\/]' -and $_.FullName -notmatch '[\\/]internal[\\/]content[\\/]data[\\/]' }
    foreach ($file in $textFiles) {
        $raw = Get-Content -Path $file.FullName -Raw
        if ($null -eq $raw -or $raw.Length -eq 0) { continue }
        if ($raw.Contains("`r")) { $findings += [pscustomobject]@{ File = $file.FullName; Line = 0; Rule = 'LineEndings'; Message = 'CRLF found; files are LF (.gitattributes).' } }
        if (-not $raw.EndsWith("`n")) { $findings += [pscustomobject]@{ File = $file.FullName; Line = 0; Rule = 'FinalNewline'; Message = 'File does not end with a newline.' } }
        $n = 0
        foreach ($line in ($raw -split "`n")) {
            $n++
            if ($line.Contains("`t")) { $findings += [pscustomobject]@{ File = $file.FullName; Line = $n; Rule = 'Tabs'; Message = 'Tab character; use spaces.' } }
            if ($line -match '[ \t]+$') { $findings += [pscustomobject]@{ File = $file.FullName; Line = $n; Rule = 'TrailingWhitespace'; Message = 'Trailing whitespace.' } }
            if ($file.Extension -eq '.yaml' -and $line -match '^( +)\S' -and ($Matches[1].Length % 2) -ne 0) { $findings += [pscustomobject]@{ File = $file.FullName; Line = $n; Rule = 'YamlIndent'; Message = 'Indentation is not a multiple of two spaces.' } }
        }
    }

    if ($findings.Count -gt 0) {
        $findings | ForEach-Object { Write-Host "  $($_.File):$($_.Line) [$($_.Rule)] $($_.Message)" -ForegroundColor Red }
        throw "Lint failed with $($findings.Count) finding(s) across $($scripts.Count) script(s) and $($textFiles.Count) text file(s)."
    }
    Write-Host "[lint] $($scripts.Count) script(s) formatted and clean; $($textFiles.Count) text file(s) conform." -ForegroundColor Green
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

    # The aa CLI: refresh the embedded content, then build for this platform (decision record 0004)
    & (Join-Path 'scripts' 'Sync-EmbeddedContent.ps1') -Version $Version | Out-Null
    $cliDir = Join-Path $PSScriptRoot 'src' 'aa-sdlc-cli'
    $cliOut = Join-Path $BuildDir 'aa-sdlc-cli'
    New-Item -ItemType Directory -Path $cliOut -Force | Out-Null
    $exe = if ($IsWindows) { 'aa.exe' } else { 'aa' }
    $commit = (git rev-parse HEAD 2>$null)
    $ldflags = "-s -w -X aasdlc.com/aa/internal/version.Version=$Version -X aasdlc.com/aa/internal/version.Commit=$commit -X aasdlc.com/aa/internal/version.BuildDate=$(Get-Date -Format 'o')"
    Push-Location $cliDir
    try {
        $env:CGO_ENABLED = '0'
        if ($Lint) {
            $unformatted = & gofmt -l .
            if ($unformatted) { $unformatted | ForEach-Object { Write-Host "  not gofmt-formatted: $_" -ForegroundColor Red }; throw 'Lint failed: run gofmt -w on the files above.' }
            & go vet ./...
            if ($LASTEXITCODE -ne 0) { throw 'go vet reported problems.' }
        }
        & go build -trimpath -ldflags $ldflags -o (Join-Path $cliOut $exe) ./cmd/aa
        if ($LASTEXITCODE -ne 0) { throw 'go build failed.' }
    } finally { Pop-Location }
    Write-Host "CLI: $(Join-Path $cliOut $exe)" -ForegroundColor Green

    $packageDir = Join-Path $BuildDir 'aa-sdlc'
    New-Item -ItemType Directory -Path $packageDir -Force | Out-Null
    Copy-Item -Path (Join-Path $SourceRoot '*') -Destination $packageDir -Recurse

    # Requirement definitions ship with the package so /aa-fw-health can resolve ids (decision record 0003)
    $requirementsDir = Join-Path $packageDir 'requirements'
    New-Item -ItemType Directory -Path $requirementsDir -Force | Out-Null
    Copy-Item -Path (Join-Path 'features' 'requirements' '*.feature') -Destination $requirementsDir
    Copy-Item -Path (Join-Path 'docs' 'requirements.md') -Destination (Join-Path $requirementsDir 'registry.md')

    @{ BuildDate = (Get-Date -Format 'o'); GitCommit = (git rev-parse HEAD 2>$null) } |
        ConvertTo-Json | Set-Content (Join-Path $packageDir 'build-info.json')

    Write-Host "Build outputs: $BuildDir" -ForegroundColor Green
} finally { Pop-Location }
