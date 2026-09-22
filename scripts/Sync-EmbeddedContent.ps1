#Requires -Version 7.0
<#
.SYNOPSIS
    Copies the content package into the CLI module so it can be embedded in the binary.
.DESCRIPTION
    The aa CLI compiles the content package in with Go's embed (decision record 0004), so the
    binary and the skills, workflow, schemas, and requirement definitions it installs are one
    identity. This script refreshes src/aa-sdlc-cli/internal/content/data/ from src/aa-sdlc/
    and features/requirements/ and writes build-info.json. The data folder is not committed.
.PARAMETER Version
    The package version to record in build-info.json. Defaults to "dev".
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]$Version = 'dev'
)

$ErrorActionPreference = 'Stop'
$repo = Join-Path -Path $PSScriptRoot -ChildPath '..'
$source = Join-Path -Path $repo -ChildPath 'src' -AdditionalChildPath 'aa-sdlc'
$target = Join-Path -Path $repo -ChildPath 'src' -AdditionalChildPath 'aa-sdlc-cli', 'internal', 'content', 'data'

if (Test-Path $target) { Remove-Item -Path $target -Recurse -Force }
New-Item -ItemType Directory -Path $target -Force | Out-Null

foreach ($part in 'skills', 'workflow', 'commands', 'targets', 'plugins', 'schemas') {
    $from = Join-Path -Path $source -ChildPath $part
    if (Test-Path $from) { Copy-Item -Path $from -Destination (Join-Path -Path $target -ChildPath $part) -Recurse }
}

$requirements = Join-Path -Path $target -ChildPath 'requirements'
New-Item -ItemType Directory -Path $requirements -Force | Out-Null
Copy-Item -Path (Join-Path -Path $repo -ChildPath 'features' -AdditionalChildPath 'requirements', '*.feature') -Destination $requirements
Copy-Item -Path (Join-Path -Path $repo -ChildPath 'docs' -AdditionalChildPath 'requirements.md') -Destination (Join-Path -Path $requirements -ChildPath 'registry.md')

$commit = (git -C $repo rev-parse HEAD 2>$null)
@{ Version = $Version; BuildDate = (Get-Date -Format 'o'); GitCommit = $commit } |
    ConvertTo-Json | Set-Content -Path (Join-Path -Path $target -ChildPath 'build-info.json')

Write-Host "Embedded content refreshed: $target" -ForegroundColor Green
