#Requires -Version 7.0
$ErrorActionPreference = 'Stop'

Push-Location $PSScriptRoot
try {
    & ./test-smoke.ps1

    $testFiles = Get-ChildItem -Path 'tests' -Recurse -Filter '*.Tests.ps1' -ErrorAction SilentlyContinue
    if ($testFiles.Count -eq 0) {
        Write-Host 'No Pester tests found in tests/.' -ForegroundColor Yellow
        return
    }

    if (-not (Get-Module -ListAvailable -Name Pester)) {
        Write-Host 'Installing Pester...' -ForegroundColor Yellow
        Install-Module Pester -Scope CurrentUser -Force -SkipPublisherCheck
    }

    $result = Invoke-Pester -Path 'tests' -PassThru
    if ($result.FailedCount -gt 0) { throw "$($result.FailedCount) test(s) failed." }
}
finally { Pop-Location }
