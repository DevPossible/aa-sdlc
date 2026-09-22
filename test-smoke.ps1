#Requires -Version 7.0
$ErrorActionPreference = 'Stop'

Push-Location $PSScriptRoot
try {
    $problems = @()
    $problems += & (Join-Path 'scripts' 'Test-SkillStructure.ps1')
    $problems += & (Join-Path 'scripts' 'Test-FeatureStructure.ps1')
    if ($problems.Count -gt 0) {
        $problems | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
        throw "Smoke tests failed with $($problems.Count) problem(s)."
    }
    Write-Host 'Smoke tests passed.' -ForegroundColor Green
}
finally { Pop-Location }
