#Requires -Version 7.0
#Requires -Modules Pester
<#
.SYNOPSIS
    End-to-end: install aa from the packed npm tarballs the way a user would, then set up and
    initialise a fresh repository, and check the health baseline covers every requirement.
.DESCRIPTION
    Needs the tarballs from ./pack.ps1 in .dist/npm/. The install goes into a temporary npm
    prefix and a temporary AA_HOME, so nothing on the machine changes (decision record 0005).
    The @health scenarios are verified by checking that the baseline in
    docs/development-environment.md names every requirement id in the registry.
#>

BeforeDiscovery {
    $script:repo = (Resolve-Path (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath '..')).Path
    $script:dist = Join-Path -Path $script:repo -ChildPath '.dist' -AdditionalChildPath 'npm'
    $script:havePack = (Test-Path $script:dist) -and ((Get-ChildItem -Path $script:dist -Filter 'aa-sdlc-*.tgz' -ErrorAction SilentlyContinue).Count -gt 0)
}

Describe 'Install from the packed npm tarballs' -Skip:(-not $script:havePack) {
    BeforeAll {
        # Discovery-time variables are not visible at run time in Pester, so the paths are computed again here
        $script:repo = (Resolve-Path (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath '..')).Path
        $script:dist = Join-Path -Path $script:repo -ChildPath '.dist' -AdditionalChildPath 'npm'
        $script:prefix = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ("aa-e2e-" + [guid]::NewGuid().ToString('N').Substring(0, 8))
        $script:aaHome = Join-Path -Path $script:prefix -ChildPath 'home'
        $script:project = Join-Path -Path $script:prefix -ChildPath 'project'
        New-Item -ItemType Directory -Path (Join-Path -Path $script:aaHome -ChildPath '.claude'), $script:project -Force | Out-Null

        $arch = if ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture -eq 'Arm64') { 'arm64' } else { 'x64' }
        $os = if ($IsWindows) { 'win32' } elseif ($IsMacOS) { 'darwin' } else { 'linux' }
        # array indexing rather than Select-Object -First: the latter stops the pipeline in a way Pester mistakes for a stray break (Pester issue 2669)
        $main = @(Get-ChildItem -Path $script:dist -Filter 'aa-sdlc-*.tgz' | Where-Object { $_.Name -match '^aa-sdlc-\d' })[0]
        $platform = @(Get-ChildItem -Path $script:dist -Filter "aa-sdlc-cli-$os-$arch-*.tgz")[0]
        if (-not $main -or -not $platform) { throw "tarballs for $os-$arch not found in $script:dist" }
        # npm.cmd rather than npm: on Windows, npm may resolve to a PowerShell shim that Pester cannot host (Pester issue 2669)
        $npm = if ($IsWindows) { 'npm.cmd' } else { 'npm' }
        $npmOut = & $npm install -g --prefix $script:prefix --silent $main.FullName $platform.FullName 2>&1
        if ($LASTEXITCODE -ne 0) { throw "npm install of the packed tarballs failed:`n$($npmOut -join "`n")" }
        $script:aa = if ($IsWindows) { Join-Path -Path $script:prefix -ChildPath 'aa.cmd' } else { Join-Path -Path $script:prefix -ChildPath 'bin' -AdditionalChildPath 'aa' }
        $env:AA_HOME = $script:aaHome
    }
    AfterAll {
        Remove-Item Env:AA_HOME -ErrorAction SilentlyContinue
        if ($script:prefix -and (Test-Path $script:prefix)) { Remove-Item -Path $script:prefix -Recurse -Force -ErrorAction SilentlyContinue }
    }

    It 'installs a launcher that runs the platform binary and reports the packed version' {
        $version = (Get-Content -Path (Join-Path -Path $script:repo -ChildPath '.dist' -AdditionalChildPath 'version.json') -Raw | ConvertFrom-Json).Version
        $out = & $script:aa version
        $LASTEXITCODE | Should -Be 0
        $out | Should -Match ([regex]::Escape("aa $version"))
    }

    It 'passes the exit code through: aa health explains itself and exits 2' {
        & $script:aa health 2>$null | Out-Null
        $LASTEXITCODE | Should -Be 2
    }

    It 'aa setup installs user-scope skills and commands and writes the user config' {
        $out = & $script:aa setup
        $LASTEXITCODE | Should -Be 0
        ($out -join "`n") | Should -Match 'Claude Code'
        Join-Path -Path $script:aaHome -ChildPath '.claude' -AdditionalChildPath 'commands', 'aa-fw-health.md' | Should -Exist
        Join-Path -Path $script:aaHome -ChildPath '.aa' -AdditionalChildPath 'aa.config.yaml' | Should -Exist
    }

    It 'aa init lays down a fresh repository and hands off to the agent' {
        $out = & $script:aa init -path $script:project -ticket-project AA -yes
        $LASTEXITCODE | Should -Be 0
        ($out -join "`n") | Should -Match '/aa-fw-health'
        foreach ($rel in 'aa.config.yaml', 'docs/decisions/0001-adopt-aa-sdlc.md', 'build.ps1', 'tests/e2e', '.claude/commands/aa-fw-init.md') {
            Join-Path -Path $script:project -ChildPath $rel | Should -Exist
        }
    }
}

Describe 'The health baseline covers every requirement (@health scenarios)' {
    It 'names every R-nn id from the registry' {
        $repo = (Resolve-Path (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath '..')).Path
        $registry = Get-Content -Path (Join-Path -Path $repo -ChildPath 'docs' -AdditionalChildPath 'requirements.md') -Raw
        $ids = [regex]::Matches($registry, '\| (R-\d\d) \|') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
        $ids.Count | Should -BeGreaterThan 30
        $env = Get-Content -Path (Join-Path -Path $repo -ChildPath 'docs' -AdditionalChildPath 'development-environment.md') -Raw
        $baseline = ($env -split '## Health baseline')[1]
        $baseline | Should -Not -BeNullOrEmpty
        $missing = $ids | Where-Object { $baseline -notmatch [regex]::Escape($_) }
        $missing | Should -BeNullOrEmpty -Because 'every requirement must have a status in the baseline'
    }
}
