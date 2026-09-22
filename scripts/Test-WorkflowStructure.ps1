#Requires -Version 7.0
#Requires -Modules powershell-yaml
<#
.SYNOPSIS
    Validates the workflow data: disciplines, steps, and processes.
.DESCRIPTION
    Checks every discipline lists only steps that exist and belong to it, every step names an
    existing discipline and is listed by it, every command equals /aa-<code>-<id>, every process
    lists only existing steps, and every guidance, requirement, tenet, and opinion id cited in
    the workflow is defined in docs/. Returns the list of problems; empty means valid.
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

$guidanceIds = Get-DefinedIds (Join-Path $DocsRoot 'guidance.md') '\| (G-\d+) \|'
$supersededGuidance = Get-DefinedIds (Join-Path $DocsRoot 'guidance.md') '\| (G-\d+) \| Superseded by'
$requirementIds = Get-DefinedIds (Join-Path $DocsRoot 'requirements.md') '\| (R-\d+) \|'
$tenetIds = Get-DefinedIds (Join-Path $DocsRoot 'tenets.md') '\*\*(T-\d+)'
$opinionIds = Get-DefinedIds (Join-Path $DocsRoot 'opinions.md') '\*\*(O-\d+)'

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
    foreach ($g in @($s.guidance | Where-Object { $_ })) {
        if ($g -notin $guidanceIds) { $problems.Add("step ${id}: unknown guidance '$g'") }
        elseif ($g -in $supersededGuidance) { $problems.Add("step ${id}: cites superseded guidance '$g'") }
    }
    foreach ($r in @($s.requires | Where-Object { $_ })) { if ($r -notin $requirementIds) { $problems.Add("step ${id}: unknown requirement '$r'") } }
    foreach ($t in @($s.tenets | Where-Object { $_ })) { if ($t -notin $tenetIds) { $problems.Add("step ${id}: unknown tenet '$t'") } }
    foreach ($o in @($s.opinions | Where-Object { $_ })) { if ($o -notin $opinionIds) { $problems.Add("step ${id}: unknown opinion '$o'") } }
}

# Skills that declare aa.step must match their step's requires and guidance exactly
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
        foreach ($field in 'requires', 'guidance') {
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
    foreach ($g in @($p.guidance | Where-Object { $_ })) {
        if ($g -notin $guidanceIds) { $problems.Add("process ${id}: unknown guidance '$g'") }
        elseif ($g -in $supersededGuidance) { $problems.Add("process ${id}: cites superseded guidance '$g'") }
    }
}

return $problems
