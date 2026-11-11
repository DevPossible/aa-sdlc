#Requires -Version 7.0
<#
.SYNOPSIS
    Makes Git for Windows' shell available to the current process's hook tests.
#>
[CmdletBinding()]
param()

if (-not $IsWindows -or (Get-Command sh -CommandType Application -ErrorAction SilentlyContinue)) { return }

$git = Get-Command git -CommandType Application -ErrorAction SilentlyContinue
if ($git) {
    $gitDirectory = Split-Path $git.Source -Parent
    # Git may be on PATH through cmd/, bin/, or mingw64/bin/ (including portable installs).
    foreach ($relative in 'sh.exe', '../bin/sh.exe', '../../bin/sh.exe') {
        $shell = Join-Path $gitDirectory $relative
        if (Test-Path -LiteralPath $shell -PathType Leaf) {
            $shellDirectory = Split-Path (Resolve-Path -LiteralPath $shell).Path -Parent
            $env:Path = $shellDirectory + [IO.Path]::PathSeparator + $env:Path
            return
        }
    }
}

Write-Warning 'Git sh was not found; the Go commit-message hook test will skip its shell checks.'
