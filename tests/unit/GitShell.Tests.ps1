#Requires -Version 7.0
#Requires -Modules Pester

BeforeAll {
    $script:entry = Join-Path $PSScriptRoot '../../scripts/Add-GitShellToPath.ps1'
}

Describe 'AP-553 Windows hook test shell discovery' -Skip:(-not $IsWindows) {
    BeforeEach {
        $script:originalPath = $env:Path
        $script:gitRoot = Join-Path $TestDrive 'Git with spaces'
        Mock Get-Command { $null }
        Mock Write-Warning {}
    }

    AfterEach {
        $env:Path = $originalPath
    }

    It 'keeps an existing shell and PATH' {
        Mock Get-Command { [pscustomobject]@{ Source = 'existing/sh.exe' } } -ParameterFilter { $Name -eq 'sh' }
        & $entry
        $env:Path | Should -BeExactly $originalPath
        Should -Invoke Get-Command -Times 0 -ParameterFilter { $Name -eq 'git' }
        Should -Invoke Write-Warning -Times 0
    }

    It 'finds the shell for Git on PATH through <Directory>' -ForEach @(
        @{ Directory = 'cmd' }, @{ Directory = 'bin' }, @{ Directory = 'mingw64/bin' }
    ) {
        $gitDirectory = Join-Path $gitRoot $Directory
        $shellDirectory = Join-Path $gitRoot 'bin'
        New-Item -ItemType Directory -Path $gitDirectory, $shellDirectory -Force | Out-Null
        New-Item -ItemType File -Path (Join-Path $shellDirectory 'sh.exe') -Force | Out-Null
        $gitExecutable = Join-Path $gitDirectory 'git.exe'
        Mock Get-Command { [pscustomobject]@{ Source = $gitExecutable } } -ParameterFilter { $Name -eq 'git' }

        & $entry

        $env:Path | Should -BeExactly ($shellDirectory + [IO.Path]::PathSeparator + $originalPath)
        Should -Invoke Write-Warning -Times 0
    }

    It 'reports missing Git without changing PATH' {
        & $entry
        $env:Path | Should -BeExactly $originalPath
        Should -Invoke Write-Warning -Times 1 -ParameterFilter { $Message -like '*hook test will skip*' }
    }

    It 'reports Git without a bundled shell without changing PATH' {
        Mock Get-Command { [pscustomobject]@{ Source = (Join-Path $TestDrive 'Git without shell/cmd/git.exe') } } -ParameterFilter { $Name -eq 'git' }
        & $entry
        $env:Path | Should -BeExactly $originalPath
        Should -Invoke Write-Warning -Times 1 -ParameterFilter { $Message -like '*hook test will skip*' }
    }
}
