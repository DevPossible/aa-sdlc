#Requires -Version 7.0
#Requires -Modules powershell-yaml
<#
.SYNOPSIS
    Validates the workflow data: disciplines, steps, processes, and guidance sets.
.DESCRIPTION
    Checks every discipline lists only steps that exist and belong to it, every step names an
    existing discipline and is listed by it, every command equals /aa-<code>-<id>, every process
    lists only existing steps, every guidance set names only defined ids, and every guidance,
    requirement, tenet, and opinion id cited in the workflow (directly or through a guidance set)
    is defined in docs/. A step may not cite superseded guidance, nor repeat an id that one of
    its sets already supplies. Returns the list of problems; empty means valid.
.PARAMETER WorkflowRoot
    Path to the workflow folder. Defaults to src/aa-sdlc/workflow relative to the repo root.
.PARAMETER DocsRoot
    Path to the docs folder. Defaults to docs relative to the repo root.
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]$WorkflowRoot = (Join-Path $PSScriptRoot '..' 'src' 'aa-sdlc' 'workflow'),

    [Parameter()]
    [string]$DocsRoot = (Join-Path $PSScriptRoot '..' 'docs')
)

$ErrorActionPreference = 'Stop'
$problems = [System.Collections.Generic.List[string]]::new()

function Read-YamlFolder {
    param([string]$Path)
    $result = @{}
    if (-not (Test-Path $Path)) { return $result }
    Get-ChildItem -Path $Path -Filter '*.yaml' -File | ForEach-Object {
        $result[$_.BaseName] = ConvertFrom-Yaml (Get-Content $_.FullName -Raw)
    }
    return $result
}

function Get-DefinedIds {
    param([string]$File, [string]$Pattern)
    if (-not (Test-Path $File)) { return @() }
    return [regex]::Matches((Get-Content $File -Raw), $Pattern) | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
}

$disciplines = Read-YamlFolder (Join-Path $WorkflowRoot 'disciplines')
$steps = Read-YamlFolder (Join-Path $WorkflowRoot 'steps')
$processes = Read-YamlFolder (Join-Path $WorkflowRoot 'processes')
$sets = Read-YamlFolder (Join-Path $WorkflowRoot 'guidance-sets')

$guidanceIds = Get-DefinedIds (Join-Path $DocsRoot 'guidance.md') '\| (G-\d+) \|'
$supersededGuidance = Get-DefinedIds (Join-Path $DocsRoot 'guidance.md') '\| (G-\d+) \| Superseded by'
$requirementIds = Get-DefinedIds (Join-Path $DocsRoot 'requirements.md') '\| (R-\d+) \|'
$tenetIds = Get-DefinedIds (Join-Path $DocsRoot 'tenets.md') '\*\*(T-\d+)'
$opinionIds = Get-DefinedIds (Join-Path $DocsRoot 'opinions.md') '\*\*(O-\d+)'

# Guidance sets: id matches file, fields present, ids defined and not superseded
foreach ($id in $sets.Keys) {
    $g = $sets[$id]
    if ($g.id -ne $id) { $problems.Add("guidance set ${id}: id '$($g.id)' does not match file name") }
    foreach ($field in 'purpose', 'guidance', 'requires') {
        if (-not $g.ContainsKey($field)) { $problems.Add("guidance set ${id}: missing '$field'") }
    }
    foreach ($x in @($g.guidance | Where-Object { $_ })) {
        if ($x -notin $guidanceIds) { $problems.Add("guidance set ${id}: unknown guidance '$x'") }
        elseif ($x -in $supersededGuidance) { $problems.Add("guidance set ${id}: cites superseded guidance '$x'") }
    }
    foreach ($r in @($g.requires | Where-Object { $_ })) { if ($r -notin $requirementIds) { $problems.Add("guidance set ${id}: unknown requirement '$r'") } }
}

function Expand-Citations {
    # Returns @{ guidance = [string[]]; requires = [string[]] } for a step or process: its sets' ids plus its own.
    param($Item)
    $g = [System.Collections.Generic.List[string]]::new()
    $r = [System.Collections.Generic.List[string]]::new()
    foreach ($setId in @($Item.guidance_sets | Where-Object { $_ })) {
        if ($sets.ContainsKey($setId)) {
            foreach ($x in @($sets[$setId].guidance)) { if ($x -and $x -notin $g) { $g.Add($x) } }
            foreach ($x in @($sets[$setId].requires)) { if ($x -and $x -notin $r) { $r.Add($x) } }
        }
    }
    foreach ($x in @($Item.guidance | Where-Object { $_ })) { if ($x -notin $g) { $g.Add($x) } }
    foreach ($x in @($Item.requires | Where-Object { $_ })) { if ($x -notin $r) { $r.Add($x) } }
    return @{ guidance = $g.ToArray(); requires = $r.ToArray() }
}

foreach ($id in $disciplines.Keys) {
    $d = $disciplines[$id]
    if ($d.id -ne $id) { $problems.Add("discipline ${id}: id '$($d.id)' does not match file name") }
    foreach ($field in 'code', 'name', 'purpose', 'owns', 'does_not_own', 'steps') {
        if (-not $d.ContainsKey($field)) { $problems.Add("discipline ${id}: missing '$field'") }
    }
    foreach ($s in @($d.steps)) {
        if (-not $steps.ContainsKey($s)) { $problems.Add("discipline ${id}: step '$s' has no file") }
        elseif ($steps[$s].discipline -ne $id) { $problems.Add("step ${s}: discipline '$($steps[$s].discipline)' but listed under '$id'") }
    }
    foreach ($o in @($d.opinions | Where-Object { $_ })) { if ($o -notin $opinionIds) { $problems.Add("discipline ${id}: unknown opinion '$o'") } }
}

$codes = @($disciplines.Values | ForEach-Object { $_.code })
$codes | Group-Object | Where-Object Count -gt 1 | ForEach-Object { $problems.Add("discipline code '$($_.Name)' used more than once") }

foreach ($id in $steps.Keys) {
    $s = $steps[$id]
    if ($s.id -ne $id) { $problems.Add("step ${id}: id '$($s.id)' does not match file name") }
    foreach ($field in 'name', 'discipline', 'command', 'summary', 'anchor', 'artifacts') {
        if (-not $s.ContainsKey($field)) { $problems.Add("step ${id}: missing '$field'") }
    }
    if ($s.anchor -and $s.anchor -notin 'required', 'optional', 'none') { $problems.Add("step ${id}: anchor '$($s.anchor)' is not required, optional, or none") }
    if (-not $disciplines.ContainsKey($s.discipline)) { $problems.Add("step ${id}: unknown discipline '$($s.discipline)'") }
    else {
        if ($id -notin @($disciplines[$s.discipline].steps)) { $problems.Add("step ${id}: not listed in discipline '$($s.discipline)'") }
        $expected = "/aa-$($disciplines[$s.discipline].code)-$id"
        if ($s.command -ne $expected) { $problems.Add("step ${id}: command '$($s.command)' should be '$expected'") }
    }
    $fromSets = @{ guidance = @(); requires = @() }
    foreach ($setId in @($s.guidance_sets | Where-Object { $_ })) {
        if (-not $sets.ContainsKey($setId)) { $problems.Add("step ${id}: unknown guidance set '$setId'"); continue }
        $fromSets.guidance += @($sets[$setId].guidance)
        $fromSets.requires += @($sets[$setId].requires)
    }
    foreach ($g in @($s.guidance | Where-Object { $_ })) {
        if ($g -notin $guidanceIds) { $problems.Add("step ${id}: unknown guidance '$g'") }
        elseif ($g -in $supersededGuidance) { $problems.Add("step ${id}: cites superseded guidance '$g'") }
        elseif ($g -in $fromSets.guidance) { $problems.Add("step ${id}: guidance '$g' is already supplied by one of its sets") }
    }
    foreach ($r in @($s.requires | Where-Object { $_ })) {
        if ($r -notin $requirementIds) { $problems.Add("step ${id}: unknown requirement '$r'") }
        elseif ($r -in $fromSets.requires) { $problems.Add("step ${id}: requirement '$r' is already supplied by one of its sets") }
    }
    foreach ($t in @($s.tenets | Where-Object { $_ })) { if ($t -notin $tenetIds) { $problems.Add("step ${id}: unknown tenet '$t'") } }
    foreach ($o in @($s.opinions | Where-Object { $_ })) { if ($o -notin $opinionIds) { $problems.Add("step ${id}: unknown opinion '$o'") } }
}

# Skills that declare aa.step must match their step's guidance_sets, guidance, and requires exactly
$skillsRoot = Join-Path $WorkflowRoot '..' 'skills'
if (Test-Path $skillsRoot) {
    Get-ChildItem -Path $skillsRoot -Recurse -Filter 'SKILL.md' -File | ForEach-Object {
        $content = Get-Content $_.FullName -Raw
        if ($content -notmatch '(?s)^---\r?\n(.*?)\r?\n---') { return }
        $front = ConvertFrom-Yaml $Matches[1]
        if (-not $front.aa -or -not $front.aa.step) { return }
        $stepId = $front.aa.step
        $label = "skill $($_.Directory.Parent.Name)/$($_.Directory.Name)"
        if (-not $steps.ContainsKey($stepId)) { $problems.Add("${label}: aa.step '$stepId' has no workflow step"); return }
        if ($front.name -ne $stepId) { $problems.Add("${label}: name '$($front.name)' does not equal aa.step '$stepId'") }
        if ($front.aa.discipline -ne $steps[$stepId].discipline) { $problems.Add("${label}: aa.discipline '$($front.aa.discipline)' does not match step's '$($steps[$stepId].discipline)'") }
        foreach ($field in 'guidance_sets', 'guidance', 'requires') {
            $a = @($front.aa[$field] | Where-Object { $_ }) | Sort-Object
            $b = @($steps[$stepId][$field] | Where-Object { $_ }) | Sort-Object
            if (($a -join ',') -ne ($b -join ',')) { $problems.Add("${label}: aa.$field [$($a -join ', ')] differs from step's [$($b -join ', ')]") }
        }
    }
}

foreach ($id in $processes.Keys) {
    $p = $processes[$id]
    if ($p.id -ne $id) { $problems.Add("process ${id}: id '$($p.id)' does not match file name") }
    foreach ($s in @($p.steps)) {
        if (-not $steps.ContainsKey($s)) { $problems.Add("process ${id}: step '$s' has no file") }
    }
    foreach ($setId in @($p.guidance_sets | Where-Object { $_ })) { if (-not $sets.ContainsKey($setId)) { $problems.Add("process ${id}: unknown guidance set '$setId'") } }
    foreach ($g in @($p.guidance | Where-Object { $_ })) {
        if ($g -notin $guidanceIds) { $problems.Add("process ${id}: unknown guidance '$g'") }
        elseif ($g -in $supersededGuidance) { $problems.Add("process ${id}: cites superseded guidance '$g'") }
    }
}

return $problems
