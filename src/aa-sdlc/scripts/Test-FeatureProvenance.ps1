#Requires -Version 7.0
<#
.SYNOPSIS
    Checks that every feature file was generated from a knowledge base page and not edited since
    (decision record 0019).
.DESCRIPTION
    Each generated feature file starts with a provenance header naming its page and a checksum of
    the body. This check needs no access to the knowledge base, so a pre-commit hook and the
    pipeline can run it wherever the knowledge base lives. Returns one line per feature file that
    has no header or whose body no longer matches its checksum; an empty result means every file
    is as it was pulled.
.PARAMETER FeaturesRoot
    The repository's features folder.
.EXAMPLE
    ./Test-FeatureProvenance.ps1 -FeaturesRoot features
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$FeaturesRoot
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath 'AaFeatures.psm1') -Force

if (-not (Test-Path $FeaturesRoot)) { return }
foreach ($f in Get-ChildItem -Path $FeaturesRoot -Recurse -Filter '*.feature' -File | Sort-Object FullName) {
    $problem = Test-FeatureProvenance -Text (Get-Content -Path $f.FullName -Raw)
    if ($problem) {
        "$([System.IO.Path]::GetRelativePath($FeaturesRoot, $f.FullName) -replace '\\', '/'): $problem"
    }
}
