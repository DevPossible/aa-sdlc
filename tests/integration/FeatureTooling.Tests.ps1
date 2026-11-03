#Requires -Version 7.4
#Requires -Modules Pester

BeforeAll {
    $repo = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
    $binaryName = if ($IsWindows) { 'aa.exe' } else { 'aa' }
    $binary = Join-Path $repo ".build/aa-sdlc-cli/$binaryName"
    $project = Join-Path $TestDrive 'project'
    $script:savedAaHome = $env:AA_HOME
    $env:AA_HOME = Join-Path $TestDrive 'home'
    [IO.Directory]::CreateDirectory((Join-Path $env:AA_HOME '.codex')) | Out-Null
    [IO.Directory]::CreateDirectory($project) | Out-Null
    & $binary init -path $project -targets codex -ticket-project AA -knowledge-space PROOF -knowledge-url https://docs.example.test/wiki/spaces/PROOF -yes | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'Disposable CLI initialization failed' }
    $script:installed = Join-Path $project 'scripts/aa-sdlc'
    $script:configPath = Join-Path $project 'aa.config.yaml'
}

AfterAll {
    $env:AA_HOME = $savedAaHome
}

Describe 'Installed feature tooling' {
    It 'F-093-04 delivers exact source helper and manifest bytes through the CLI' {
        foreach ($source in Get-ChildItem -LiteralPath (Join-Path $repo 'src/aa-sdlc/scripts') -File) {
            (Get-FileHash -LiteralPath (Join-Path $installed $source.Name)).Hash | Should -Be (Get-FileHash -LiteralPath $source.FullName).Hash
        }
    }

    It 'F-093-05/08/09/10 generates and verifies a selected offline snapshot after installation' {
        $storage = @'
<table><tr><th>Feature</th><th>F-910</th></tr><tr><td>Name</td><td>Installed importer</td></tr><tr><td>Tags</td><td>@fixture</td></tr><tr><td>File</td><td>installed</td></tr></table>
<h2>Behavior</h2>
<table><tr><th>Scenario</th><th>F-910-01</th></tr><tr><td>Name</td><td>Installed behavior</td></tr><tr><td>Status</td><td>Approved</td></tr></table>
<table><tr><th>Step</th><th>Text</th></tr><tr><td>Given</td><td>installed helpers</td></tr><tr><td>Then</td><td>the real command works</td></tr></table>
'@
        $snapshot = @{ id = '42'; type = 'page'; title = 'Installed'; space = @{ key = 'PROOF' }; version = @{ number = 3 }; body = @{ storage = @{ representation = 'storage'; value = $storage } } }
        $snapshotPath = Join-Path $project 'snapshot.json'
        $outputPath = Join-Path $project 'installed.feature'
        [IO.File]::WriteAllText($snapshotPath, ($snapshot | ConvertTo-Json -Depth 10))
        $command = Join-Path $installed 'Import-ConfluenceFeatureSnapshot.ps1'
        & $command -SnapshotPath $snapshotPath -OutputPath $outputPath -ConfigPath $configPath -ScenarioId F-910-01 | Out-Null
        $generated = [IO.File]::ReadAllText($outputPath)
        $generated | Should -Match 'https://docs.example.test/wiki/spaces/PROOF/pages/42 \(version 3\)'
        $generated | Should -Match '# Selected scenario IDs: F-910-01'
        $generated | Should -Match '# Source Markdown checksum: sha256:[0-9a-f]{64}'
        & $command -SnapshotPath $snapshotPath -OutputPath $outputPath -ConfigPath $configPath -ScenarioId F-910-01 -Check | Should -Match 'Feature matches'
        (Get-ChildItem -LiteralPath $project -Filter '*.tmp').Count | Should -Be 0
    }

    It 'F-093-04 restores replaced helpers with aa update and preserves project configuration' {
        $before = [IO.File]::ReadAllText($configPath)
        [IO.File]::WriteAllText((Join-Path $installed 'ConfluenceFeatureImport.psm1'), 'stale helper')
        & $binary update -path $project | Out-Null
        $LASTEXITCODE | Should -Be 0
        [IO.File]::ReadAllText($configPath) | Should -Be $before
        (Get-FileHash -LiteralPath (Join-Path $installed 'ConfluenceFeatureImport.psm1')).Hash | Should -Be (Get-FileHash -LiteralPath (Join-Path $repo 'src/aa-sdlc/scripts/ConfluenceFeatureImport.psm1')).Hash
    }
}
