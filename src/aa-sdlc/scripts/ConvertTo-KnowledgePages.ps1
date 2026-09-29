#Requires -Version 7.0
<#
.SYNOPSIS
    Seeds knowledge base feature pages from existing feature files (decision record 0019).
.DESCRIPTION
    For a repository whose requirements were written as feature files first: writes one feature
    page per feature file to <KnowledgeRoot>/Requirements/<topic>/<name>.md, where <topic> is
    the file's folder under the features folder. Every scenario is marked Approved. Upload the
    pages to the knowledge base, or keep them in the documents folder as the knowledge base, then
    pull the feature files from them with Sync-FeatureFiles.ps1. An existing page is never
    overwritten without -Force.
.PARAMETER FeaturesRoot
    The repository's features folder.
.PARAMETER KnowledgeRoot
    The folder to write the pages under: the project's knowledge base root.
.PARAMETER Force
    Overwrite pages that already exist.
.EXAMPLE
    ./ConvertTo-KnowledgePages.ps1 -FeaturesRoot features -KnowledgeRoot docs/knowledge
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$FeaturesRoot,

    [Parameter(Mandatory)]
    [string]$KnowledgeRoot,

    [Parameter()]
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath 'AaFeatures.psm1') -Force

foreach ($f in Get-ChildItem -Path $FeaturesRoot -Recurse -Filter '*.feature' -File | Sort-Object FullName) {
    $topic = [System.IO.Path]::GetRelativePath($FeaturesRoot, $f.DirectoryName) -replace '\\', '/'
    $page = Join-Path -Path $KnowledgeRoot -ChildPath 'Requirements' -AdditionalChildPath $topic, "$($f.BaseName).md"
    if ((Test-Path $page) -and -not $Force) { Write-Warning "$page exists; use -Force to overwrite"; continue }
    $markdown = ConvertTo-FeaturePage -Text (Get-Content -Path $f.FullName -Raw) -File $f.BaseName
    if ($PSCmdlet.ShouldProcess($page, 'write feature page')) {
        New-Item -ItemType Directory -Path (Split-Path -Path $page -Parent) -Force | Out-Null
        Set-Content -Path $page -Value $markdown -NoNewline -Encoding utf8
        [pscustomobject]@{ Feature = "$topic/$($f.Name)"; Page = $page }
    }
}
