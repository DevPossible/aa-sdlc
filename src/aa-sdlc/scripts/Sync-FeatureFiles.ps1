#Requires -Version 7.0
<#
.SYNOPSIS
    Generates the repository's feature files from the feature pages of a knowledge base kept in a
    folder, or checks that they match (decision record 0019).
.DESCRIPTION
    Reads every feature page under <KnowledgeRoot>/Requirements/<topic>/ and writes the feature
    file each one generates to <FeaturesRoot>/<topic>/<File>.feature, with the Approved scenarios
    only and a provenance header. A page with no Approved scenario generates no file.

    With -Check nothing is written; the script returns one line per problem: a feature file that
    is missing, that differs from its page, or that no page generates (a repository edit not
    sourced from the knowledge base). An empty result means the feature files match the pages.
    This is the review gate a pre-commit hook and the pipeline run.

    Without -Check it writes what differs and removes a generated file whose page no longer
    generates it. A feature file with no provenance header is never removed; it is reported.
.PARAMETER KnowledgeRoot
    The knowledge base folder: the project's root, holding the Requirements section.
.PARAMETER FeaturesRoot
    The repository's features folder.
.PARAMETER Check
    Compare instead of write.
.EXAMPLE
    ./Sync-FeatureFiles.ps1 -KnowledgeRoot docs/knowledge -FeaturesRoot features
    ./Sync-FeatureFiles.ps1 -KnowledgeRoot docs/knowledge -FeaturesRoot features -Check
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$KnowledgeRoot,

    [Parameter(Mandatory)]
    [string]$FeaturesRoot,

    [Parameter()]
    [switch]$Check
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath 'AaFeatures.psm1') -Force

$requirements = Join-Path -Path $KnowledgeRoot -ChildPath 'Requirements'
$problems = [System.Collections.Generic.List[string]]::new()
$expected = @{}   # feature file path relative to FeaturesRoot -> text ('' when the page generates none)

if (Test-Path $requirements) {
    foreach ($page in Get-ChildItem -Path $requirements -Recurse -Filter '*.md' -File) {
        $markdown = Get-Content -Path $page.FullName -Raw
        if ($markdown -notmatch '(?m)^\|\s*Feature\s*\|') { continue } # a section index, not a feature page
        $topic = [System.IO.Path]::GetRelativePath($requirements, $page.DirectoryName) -replace '\\', '/'
        $source = "Requirements/$topic/$($page.BaseName)"
        try {
            $text = ConvertFrom-FeaturePage -Markdown $markdown -Source $source
            $file = [regex]::Match($markdown, '(?m)^\|\s*File\s*\|\s*([^|]+?)\s*\|').Groups[1].Value
            if (-not $file) { $file = $page.BaseName }
            $expected["$topic/$file.feature"] = $text
        } catch {
            $problems.Add("$source`: $($_.Exception.Message)")
        }
    }
}

$existing = @{}
if (Test-Path $FeaturesRoot) {
    foreach ($f in Get-ChildItem -Path $FeaturesRoot -Recurse -Filter '*.feature' -File) {
        $existing[([System.IO.Path]::GetRelativePath($FeaturesRoot, $f.FullName) -replace '\\', '/')] = $f.FullName
    }
}

foreach ($rel in $expected.Keys | Sort-Object) {
    $want = $expected[$rel]
    $path = Join-Path -Path $FeaturesRoot -ChildPath $rel
    $have = if ($existing.ContainsKey($rel)) { (Get-Content -Path $path -Raw) -replace "`r`n", "`n" } else { $null }
    if ($want -eq '') {
        if ($null -ne $have) {
            if ($Check) { $problems.Add("$rel`: its page has no Approved scenario, so it should not exist") }
            elseif (-not (Test-FeatureProvenance -Text $have)) { Remove-Item -Path $path; Write-Verbose "removed $rel" }
            else { $problems.Add("$rel`: its page has no Approved scenario, but the file was not generated from it; left in place") }
        }
        continue
    }
    if ($have -eq $want) { continue }
    if ($Check) {
        $problems.Add($(if ($null -eq $have) { "$rel`: missing; pull it from its page" } else { "$rel`: differs from its knowledge base page; change the page, then pull it" }))
        continue
    }
    New-Item -ItemType Directory -Path (Split-Path -Path $path -Parent) -Force | Out-Null
    Set-Content -Path $path -Value $want -NoNewline -Encoding utf8
    Write-Verbose "wrote $rel"
}

foreach ($rel in $existing.Keys | Sort-Object) {
    if ($expected.ContainsKey($rel)) { continue }
    $text = Get-Content -Path $existing[$rel] -Raw
    if (-not $Check -and -not (Test-FeatureProvenance -Text $text)) {
        Remove-Item -Path $existing[$rel]
        Write-Verbose "removed ${rel}: its page no longer exists"
        continue
    }
    $problems.Add("$rel`: no knowledge base page generates it; it was not sourced from the knowledge base")
}

$problems
