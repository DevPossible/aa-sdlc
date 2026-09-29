#Requires -Version 7.0
<#
.SYNOPSIS
    Gives every feature and scenario on this repository's feature pages that has no id the next
    free one (G-49), then pulls the feature files from the pages (decision record 0019).
.DESCRIPTION
    The framework's requirements live in docs/knowledge/Requirements/, one page per feature.
    Write or change the page, run this, and commit the page with the feature files it regenerates.
.EXAMPLE
    ./scripts/Add-FeatureId.ps1
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path -Path $PSScriptRoot -ChildPath '..')).Path
$shipped = Join-Path -Path $repo -ChildPath 'src' -AdditionalChildPath 'aa-sdlc', 'scripts'
$knowledge = Join-Path -Path $repo -ChildPath 'docs' -AdditionalChildPath 'knowledge'
$features = Join-Path -Path $repo -ChildPath 'features'

& (Join-Path -Path $shipped -ChildPath 'Add-FeatureId.ps1') -KnowledgeRoot $knowledge
$problems = @(& (Join-Path -Path $shipped -ChildPath 'Sync-FeatureFiles.ps1') -KnowledgeRoot $knowledge -FeaturesRoot $features)
if ($problems.Count -gt 0) {
    $problems | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
    throw "Pulling the feature files from the pages found $($problems.Count) problem(s)."
}
Write-Host 'Feature files pulled from docs/knowledge/Requirements.'
