#Requires -Version 7.4
#Requires -Modules Pester

BeforeAll {
    $script:scripts = Join-Path $PSScriptRoot '../../src/aa-sdlc/scripts'
}

Describe 'Backported feature tooling' {
    It 'F-093-01 F-093-02 F-093-03 F-093-09 F-093-10 preserves pages, projections and invalid-batch protections' {
        & (Join-Path $PSScriptRoot 'cases/Test-FeaturePageConversion.ps1') -ScriptsRoot $scripts
    }

    It 'F-093-05 F-093-06 F-093-07 F-093-08 F-093-09 F-093-10 imports snapshots and guards generated destinations' {
        & (Join-Path $PSScriptRoot 'cases/Test-ConfluenceFeatureImport.ps1') -ScriptsRoot $scripts
    }
}
