#Requires -Version 7.4
#Requires -Modules Pester

BeforeAll {
    $script:scripts = Join-Path $PSScriptRoot '../../src/aa-sdlc/scripts'
}

Describe 'Backported feature tooling' {
    It 'F-093-01/02/03/09/10 preserves pages, projections and invalid-batch protections' {
        & (Join-Path $PSScriptRoot 'cases/Test-FeaturePageConversion.ps1') -ScriptsRoot $scripts
    }

    It 'F-093-05/06/07/08/09/10 imports snapshots and guards generated destinations' {
        & (Join-Path $PSScriptRoot 'cases/Test-ConfluenceFeatureImport.ps1') -ScriptsRoot $scripts
    }
}
