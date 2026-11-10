#Requires -Version 7.0
#Requires -Modules Pester, powershell-yaml

Describe 'F-094-08 Installed checkpoint policy' {
    BeforeAll {
        $repo = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
        $binaryName = if ($IsWindows) { 'aa.exe' } else { 'aa' }
        $script:binary = Join-Path $repo ".build/aa-sdlc-cli/$binaryName"
        $script:savedAaHome = $env:AA_HOME
        $env:AA_HOME = Join-Path $TestDrive 'home'
        $project = Join-Path $TestDrive 'project'
        $userConfig = Join-Path $env:AA_HOME '.aa/aa.config.yaml'
        [IO.Directory]::CreateDirectory((Split-Path $userConfig)) | Out-Null
        [IO.Directory]::CreateDirectory($project) | Out-Null
        [IO.File]::WriteAllText($userConfig, @'
version: 1
scope: user
testing:
  fullSuite:
    mode: checkpoint
    integrationBranch: develop
    perMerge: [build, lint, smoke, changed-components]
    checkpointBefore: [release, exposure, demonstration]
    backstop: {merges: 10, days: 3}
'@)
    }

    AfterAll {
        $env:AA_HOME = $savedAaHome
    }

    It 'preserves an inherited policy through init and delivers its guidance' {
        & $script:binary init -path $project -targets codex -ticket-project ABC -yes | Out-Null
        $LASTEXITCODE | Should -Be 0
        $config = ConvertFrom-Yaml ([IO.File]::ReadAllText((Join-Path $project 'aa.config.yaml')))
        $policy = $config.testing.fullSuite
        $policy.mode | Should -Be 'checkpoint'
        $policy.integrationBranch | Should -Be 'develop'
        $policy.perMerge | Should -Be @('build', 'lint', 'smoke', 'changed-components')
        $policy.checkpointBefore | Should -Be @('release', 'exposure', 'demonstration')
        $policy.backstop.merges | Should -Be 10
        $policy.backstop.days | Should -Be 3
        $skill = [IO.File]::ReadAllText((Join-Path $project '.agents/skills/aa-dev-finish-branch/SKILL.md'))
        $skill | Should -Match 'Prove the configured gate'
        $skill | Should -Match 'full run owed at the next'
        $health = [IO.File]::ReadAllText((Join-Path $project '.agents/skills/aa-fw-health/SKILL.md'))
        $health | Should -Match 'R-49'
        $health | Should -Match 'missing or empty `checkpointBefore`'
    }
}
