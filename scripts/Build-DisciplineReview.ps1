#Requires -Version 7.0
#Requires -Modules powershell-yaml
<#
.SYNOPSIS
    Generates docs/discipline-review.md from the workflow data.
.DESCRIPTION
    Reads disciplines, steps, and guidance and writes one readable document, ordered by each
    discipline's 'order', with the role and bounded responsibilities, the command list, and the
    full guidance for every command. The workflow YAML is the source of truth; this document is
    derived and should not be edited by hand.
.PARAMETER WorkflowRoot
    Path to the workflow folder.
.PARAMETER OutputPath
    Where to write the document.
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]$WorkflowRoot = (Join-Path $PSScriptRoot '..' 'src' 'aa-sdlc' 'workflow'),

    [Parameter()]
    [string]$DocsRoot = (Join-Path $PSScriptRoot '..' 'docs'),

    [Parameter()]
    [string]$OutputPath = (Join-Path $PSScriptRoot '..' 'docs' 'discipline-review.md')
)

$ErrorActionPreference = 'Stop'

function Read-YamlFolder {
    param([string]$Path)
    $result = @{}
    Get-ChildItem -Path $Path -Filter '*.yaml' -File | ForEach-Object {
        $result[$_.BaseName] = ConvertFrom-Yaml (Get-Content $_.FullName -Raw)
    }
    return $result
}

$disciplines = Read-YamlFolder (Join-Path $WorkflowRoot 'disciplines')
$steps = Read-YamlFolder (Join-Path $WorkflowRoot 'steps')
$sets = Read-YamlFolder (Join-Path $WorkflowRoot 'guidance-sets')

# Guidance text by id, from the table in docs/guidance.md
$guidanceText = @{}
foreach ($m in [regex]::Matches((Get-Content (Join-Path $DocsRoot 'guidance.md') -Raw), '\| (G-\d+) \| (.+?) \| (.+?) \| (.+?) \|')) {
    $guidanceText[$m.Groups[1].Value] = $m.Groups[2].Value
}

$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine('# Discipline Review')
[void]$sb.AppendLine()
[void]$sb.AppendLine('**Generated from `src/aa-sdlc/workflow/` by `scripts/Build-DisciplineReview.ps1`. Do not edit by hand; edit the YAML and regenerate.**')
[void]$sb.AppendLine()
[void]$sb.AppendLine('Every discipline in SDLC order: its role and bounded responsibilities, its commands, and the guidance the agent follows for each command. Shared guidance is cited by id and expanded inline; step-specific guidance follows it.')
[void]$sb.AppendLine()

[void]$sb.AppendLine('## Contents')
[void]$sb.AppendLine()
foreach ($d in ($disciplines.Values | Sort-Object order)) {
    [void]$sb.AppendLine("- $($d.order). [$($d.name)](#$($d.order)-$($d.name.ToLower() -replace '[^a-z0-9]+','-')) (``$($d.code)``): $(@($d.steps).Count) commands")
}
[void]$sb.AppendLine()

foreach ($d in ($disciplines.Values | Sort-Object order)) {
    [void]$sb.AppendLine("## $($d.order). $($d.name)")
    [void]$sb.AppendLine()
    [void]$sb.AppendLine("**Code:** ``$($d.code)`` | **Id:** ``$($d.id)`` | **Commands:** " + ((@($d.steps) | ForEach-Object { "``$($steps[$_].command)``" }) -join ', '))
    [void]$sb.AppendLine()
    [void]$sb.AppendLine('### Role')
    [void]$sb.AppendLine()
    [void]$sb.AppendLine($d.purpose.Trim())
    [void]$sb.AppendLine()
    [void]$sb.AppendLine('**Owns**')
    [void]$sb.AppendLine()
    foreach ($o in @($d.owns)) { [void]$sb.AppendLine("- $o") }
    [void]$sb.AppendLine()
    [void]$sb.AppendLine('**Does not own**')
    [void]$sb.AppendLine()
    foreach ($o in @($d.does_not_own)) { [void]$sb.AppendLine("- $o") }
    [void]$sb.AppendLine()
    if ($d.hands_off_to) {
        [void]$sb.AppendLine('**Hands off to**')
        [void]$sb.AppendLine()
        foreach ($h in @($d.hands_off_to)) {
            $target = $disciplines[$h.discipline]
            [void]$sb.AppendLine("- **$($target.name)** when $($h.when)")
        }
        [void]$sb.AppendLine()
    }
    $refs = @()
    if ($d.tenets) { $refs += "Tenets: " + (@($d.tenets) -join ', ') }
    if ($d.opinions) { $refs += "Opinions: " + (@($d.opinions) -join ', ') }
    if ($refs) { [void]$sb.AppendLine("*$($refs -join ' | ')*"); [void]$sb.AppendLine() }

    [void]$sb.AppendLine('### Commands')
    [void]$sb.AppendLine()
    [void]$sb.AppendLine('| Command | Step | Anchor | Primary artifact |')
    [void]$sb.AppendLine('|---------|------|--------|------------------|')
    foreach ($sid in @($d.steps)) {
        $s = $steps[$sid]
        $primary = if ($s.artifacts) { $s.artifacts[0].name } else { '' }
        [void]$sb.AppendLine("| ``$($s.command)`` | $($s.name) | $($s.anchor) | $primary |")
    }
    [void]$sb.AppendLine()

    foreach ($sid in @($d.steps)) {
        $s = $steps[$sid]
        [void]$sb.AppendLine("### ``$($s.command)``")
        [void]$sb.AppendLine()
        [void]$sb.AppendLine($s.summary.Trim())
        [void]$sb.AppendLine()
        if ($s.inputs) {
            [void]$sb.AppendLine('**Inputs**')
            [void]$sb.AppendLine()
            foreach ($i in @($s.inputs)) { [void]$sb.AppendLine("- $i") }
            [void]$sb.AppendLine()
        }
        [void]$sb.AppendLine('**Artifacts**')
        [void]$sb.AppendLine()
        foreach ($a in @($s.artifacts)) {
            [void]$sb.AppendLine("- **$($a.name)** in $($a.location)")
            foreach ($c in @($a.acceptance)) { [void]$sb.AppendLine("  - $c") }
        }
        [void]$sb.AppendLine()
        [void]$sb.AppendLine('**Guidance**')
        [void]$sb.AppendLine()
        $seen = [System.Collections.Generic.List[string]]::new()
        $allRequires = [System.Collections.Generic.List[string]]::new()
        foreach ($setId in @($s.guidance_sets | Where-Object { $_ })) {
            if (-not $sets.ContainsKey($setId)) { continue }
            $set = $sets[$setId]
            [void]$sb.AppendLine("- *From the ``$setId`` set:* $($set.purpose.Trim())")
            foreach ($g in @($set.guidance)) {
                if ($g -in $seen) { continue }
                $seen.Add($g)
                $text = if ($guidanceText.ContainsKey($g)) { $guidanceText[$g] } else { '(undefined)' }
                [void]$sb.AppendLine("  - **$g** $text")
            }
            foreach ($r in @($set.requires)) { if ($r -notin $allRequires) { $allRequires.Add($r) } }
        }
        foreach ($g in @($s.guidance | Where-Object { $_ })) {
            if ($g -in $seen) { continue }
            $seen.Add($g)
            $text = if ($guidanceText.ContainsKey($g)) { $guidanceText[$g] } else { '(undefined)' }
            [void]$sb.AppendLine("- **$g** $text")
        }
        foreach ($g in @($s.guidance_inline | Where-Object { $_ })) { [void]$sb.AppendLine("- $g") }
        [void]$sb.AppendLine()
        foreach ($r in @($s.requires | Where-Object { $_ })) { if ($r -notin $allRequires) { $allRequires.Add($r) } }
        $meta = @()
        if ($allRequires.Count) { $meta += "Requires: " + ($allRequires -join ', ') }
        if ($s.tenets) { $meta += "Tenets: " + (@($s.tenets) -join ', ') }
        if ($s.opinions) { $meta += "Opinions: " + (@($s.opinions) -join ', ') }
        if ($s.methodology) {
            $m = "Methodology: phase $($s.methodology.phase)"
            if ($s.methodology.steps) { $m += " step " + (@($s.methodology.steps) -join ', ') }
            $meta += $m
        }
        if ($meta) { [void]$sb.AppendLine("*$($meta -join ' | ')*"); [void]$sb.AppendLine() }
    }
}

Set-Content -Path $OutputPath -Value ($sb.ToString() -replace "`r`n", "`n") -Encoding utf8 -NoNewline
Write-Host "Wrote $OutputPath" -ForegroundColor Green
