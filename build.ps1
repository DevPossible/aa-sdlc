#Requires -Version 7.0
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
        }
        catch [System.IO.IOException] { $lockedFiles += $_.FullName }
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

    $packageDir = Join-Path $BuildDir 'aa-sdlc'
    New-Item -ItemType Directory -Path $packageDir -Force | Out-Null
    Copy-Item -Path (Join-Path $SourceRoot '*') -Destination $packageDir -Recurse

    @{ BuildDate = (Get-Date -Format 'o'); GitCommit = (git rev-parse HEAD 2>$null) } |
        ConvertTo-Json | Set-Content (Join-Path $packageDir 'build-info.json')

    Write-Host "Build outputs: $BuildDir" -ForegroundColor Green
}
finally { Pop-Location }
