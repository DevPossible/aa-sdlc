#Requires -Version 7.4
#Requires -Modules Pester

BeforeAll {
    $scripts = Join-Path $PSScriptRoot '../../src/aa-sdlc/scripts'
    Import-Module (Join-Path $scripts 'ConfluenceFeatureImport.psd1') -Force
    $script:entry = Join-Path $scripts 'Import-ConfluenceFeatureSnapshot.ps1'
    $script:storage = @'
<h1>Fixture</h1>
<table><tr><th>Feature</th><th>F-910</th></tr><tr><td>Name</td><td>Configured source</td></tr><tr><td>Tags</td><td>@fixture</td></tr><tr><td>File</td><td>configured</td></tr></table>
<h2>Behavior</h2>
<table><tr><th>Scenario</th><th>F-910-01</th></tr><tr><td>Name</td><td>Configured identity</td></tr><tr><td>Kind</td><td>Scenario</td></tr><tr><td>Status</td><td>Approved</td></tr></table>
<table><tr><th>Step</th><th>Text</th></tr><tr><td>Given</td><td>an offline snapshot</td></tr><tr><td>Then</td><td>the configured source survives</td></tr></table>
'@
}

Describe 'F-093-04 Versioned public modules' {
    It 'declares converter version, PowerShell requirement and only public exports' {
        $manifest = Test-ModuleManifest (Join-Path $scripts 'AaFeatures.psd1')
        $manifest.Version | Should -Be '0.1.2'
        $manifest.PowerShellVersion | Should -Be '7.4'
        @($manifest.ExportedFunctions.Keys | Sort-Object) -join ',' | Should -Be 'ConvertFrom-FeaturePage,ConvertTo-FeaturePage,Get-FeatureChecksum,Test-FeatureProvenance'
    }

    It 'declares the importer version and its single public export' {
        $manifest = Test-ModuleManifest (Join-Path $scripts 'ConfluenceFeatureImport.psd1')
        $manifest.Version | Should -Be '0.1.2'
        $manifest.PowerShellVersion | Should -Be '7.4'
        @($manifest.ExportedFunctions.Keys) | Should -Be @('ConvertFrom-ConfluenceFeatureSnapshot')
    }
}

Describe 'F-093-05 Configured offline source' {
    BeforeEach {
        $page = @{ id = '123'; type = 'page'; title = 'Fixture'; space = @{ key = 'AS' }; version = @{ number = 1 }; body = @{ storage = @{ representation = 'storage'; value = $storage } } }
        $caseRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [IO.Directory]::CreateDirectory($caseRoot) | Out-Null
        $configPath = Join-Path $caseRoot 'aa[project].yaml'
        $snapshotPath = Join-Path $caseRoot 'snapshot.json'
        $script:outputPath = Join-Path $caseRoot 'output.feature'
        $configText = "version: 1`nscope: project`nconventions:`n  knowledge:`n    space: AS`n    url: https://docs.example.test/wiki/spaces/AS`n"
        [IO.File]::WriteAllText($configPath, $configText)
        [IO.File]::WriteAllText($snapshotPath, ($page | ConvertTo-Json -Depth 10))
    }

    It 'accepts arbitrary configured spaces and trailing URL slashes' -ForEach @('AS', 'PROJECT2') {
        $page.space.key = $_
        $result = ConvertFrom-ConfluenceFeatureSnapshot -Json ($page | ConvertTo-Json -Depth 10) -KnowledgeSpace $_ -KnowledgeUrl "https://docs.example.test/wiki/spaces/$_/"
        $result.Source | Should -Be "https://docs.example.test/wiki/spaces/$_/pages/123"
        $result.FeatureText | Should -Match ([regex]::Escape($result.Source))
    }

    It 'refuses invalid or conflicting knowledge URLs' -ForEach @(
        '/wiki/spaces/AS', 'file:///wiki/spaces/AS', 'https://docs.example.test/wiki/spaces/OTHER',
        'https://user:secret@docs.example.test/wiki/spaces/AS', 'https://docs.example.test/wiki/spaces/AS?x=1',
        'https://docs.example.test/wiki/spaces/AS#fragment', "https://docs.example.test/wiki/spaces/AS`n"
    ) {
        { ConvertFrom-ConfluenceFeatureSnapshot -Json ($page | ConvertTo-Json -Depth 10) -KnowledgeSpace AS -KnowledgeUrl $_ } | Should -Throw '*KnowledgeUrl*'
    }

    It 'uses the explicit config file and verifies its generated output' {
        & $entry -SnapshotPath $snapshotPath -OutputPath $outputPath -ConfigPath $configPath | Out-Null
        [IO.File]::ReadAllText($outputPath) | Should -Match 'https://docs.example.test/wiki/spaces/AS/pages/123'
        & $entry -SnapshotPath $snapshotPath -OutputPath $outputPath -ConfigPath $configPath -Check | Should -Match 'Feature matches'
    }

    It 'uses aa.config.yaml in the working directory when no path is supplied' {
        [IO.File]::WriteAllText((Join-Path $caseRoot 'aa.config.yaml'), $configText)
        Push-Location $caseRoot
        try { & $entry -SnapshotPath $snapshotPath -OutputPath $outputPath | Out-Null } finally { Pop-Location }
        Test-Path -LiteralPath $outputPath | Should -BeTrue
    }

    It 'refuses incomplete or malformed configuration before creating output' -ForEach @(
        'version: 1', "version: 1`nscope: user`n", "version: 1`nscope: project`nconventions: []`n",
        "version: 1`nscope: project`nconventions:`n  knowledge: []`n",
        "version: 1`nscope: project`nconventions:`n  knowledge:`n    space: []`n    url: https://docs.example.test/wiki/spaces/AS`n",
        "version: 1`nscope: project`nconventions:`n  knowledge:`n    space: AS`n    url: []`n", 'invalid: [yaml'
    ) {
        [IO.File]::WriteAllText($configPath, $_)
        { & $entry -SnapshotPath $snapshotPath -OutputPath $outputPath -ConfigPath $configPath } | Should -Throw
        Test-Path -LiteralPath $outputPath | Should -BeFalse
    }

    It 'rejects a missing config file while preserving an existing destination' {
        [IO.File]::WriteAllText($outputPath, 'keep me')
        { & $entry -SnapshotPath $snapshotPath -OutputPath $outputPath -ConfigPath (Join-Path $TestDrive 'missing.yaml') } | Should -Throw
        [IO.File]::ReadAllText($outputPath) | Should -Be 'keep me'
    }
}
