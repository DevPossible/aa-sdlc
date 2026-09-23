#Requires -Version 7.0
#Requires -Modules powershell-yaml
<#
.SYNOPSIS
    Scaffolds a skill from its workflow step so the two cannot drift.
.DESCRIPTION
    Reads src/aa-sdlc/workflow/steps/<step>.yaml, its discipline, its guidance sets, and the
    guidance registry, and writes src/aa-sdlc/skills/<discipline>/<step>/SKILL.md with the
    frontmatter the validator requires (name, description, aa.discipline, aa.step,
    aa.guidance_sets, aa.guidance, aa.requires all equal to the step) and the generated
    sections: command heading, summary, anchor, inputs, artifacts with acceptance, expanded
    guidance, and report. The procedure section holds a marker; a person writes it. Also
    writes the Claude Code command wrapper under .claude/commands/ for this repository.
    Refuses to overwrite an existing skill unless -Force is given (plan task F1).
.PARAMETER Step
    The step id.
.PARAMETER OutputRoot
    Where to write the skill folder tree. Defaults to src/aa-sdlc/skills. Point it elsewhere to
    compare a scaffold against an existing skill without touching it.
.PARAMETER Force
    Overwrite an existing SKILL.md.
.EXAMPLE
    ./scripts/New-SkillScaffold.ps1 -Step implement
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$Step,

    [Parameter()]
    [string]$OutputRoot = (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'src', 'aa-sdlc', 'skills'),

    [Parameter()]
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path -Path $PSScriptRoot -ChildPath '..')).Path
$workflow = Join-Path -Path $repo -ChildPath 'src' -AdditionalChildPath 'aa-sdlc', 'workflow'

$stepFile = Join-Path -Path $workflow -ChildPath 'steps' -AdditionalChildPath "$Step.yaml"
if (-not (Test-Path $stepFile)) { throw "No workflow step '$Step' at $stepFile" }
$s = ConvertFrom-Yaml (Get-Content -Path $stepFile -Raw)
$d = ConvertFrom-Yaml (Get-Content -Path (Join-Path -Path $workflow -ChildPath 'disciplines' -AdditionalChildPath "$($s.discipline).yaml") -Raw)

function Format-IdList([object[]]$items) { if ($items) { '[' + (($items | Where-Object { $_ }) -join ', ') + ']' } else { '[]' } }
$oneLine = ($s.summary -replace '\s+', ' ').Trim()
$anchorText = switch ($s.anchor) {
    'required' { 'Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).' }
    'optional' { 'A ticket is optional here. When one is given, read it, its linked scenarios, and its page first (G-22) and write the outcome back to it; when none is, produce the artifacts locally and say so.' }
    default { 'No ticket anchor. This command runs against the install or the repository, not a unit of work.' }
}

$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine('---')
[void]$sb.AppendLine("name: $($s.id)")
[void]$sb.AppendLine("description: `"$($oneLine -replace '\\', '\\' -replace '"', '\"')`"")
[void]$sb.AppendLine('aa:')
[void]$sb.AppendLine("  discipline: $($s.discipline)")
[void]$sb.AppendLine("  step: $($s.id)")
if ($s.guidance_sets) { [void]$sb.AppendLine("  guidance_sets: $(Format-IdList $s.guidance_sets)") }
if ($s.guidance) { [void]$sb.AppendLine("  guidance: $(Format-IdList $s.guidance)") }
if ($s.requires) { [void]$sb.AppendLine("  requires: $(Format-IdList $s.requires)") }
[void]$sb.AppendLine('---')
[void]$sb.AppendLine()
[void]$sb.AppendLine("# $($s.command)")
[void]$sb.AppendLine()
[void]$sb.AppendLine($s.summary.Trim())
[void]$sb.AppendLine()
[void]$sb.AppendLine('## Anchor')
[void]$sb.AppendLine()
[void]$sb.AppendLine($anchorText)
[void]$sb.AppendLine()
if ($s.inputs) {
    [void]$sb.AppendLine('## Inputs')
    [void]$sb.AppendLine()
    foreach ($i in $s.inputs) { [void]$sb.AppendLine("- $i") }
    [void]$sb.AppendLine()
}
[void]$sb.AppendLine('## Procedure')
[void]$sb.AppendLine()
[void]$sb.AppendLine('<!-- SCAFFOLD: write the procedure. Numbered steps, each producing something observable. The first reads (anchor, currency check where the step starts work); the last stages and presents, never commits (O-17). -->')
[void]$sb.AppendLine()
[void]$sb.AppendLine('## Artifacts')
[void]$sb.AppendLine()
foreach ($a in $s.artifacts) {
    [void]$sb.AppendLine("**$($a.name)** in $($a.location). Done when:")
    [void]$sb.AppendLine()
    foreach ($c in $a.acceptance) { [void]$sb.AppendLine("- $c") }
    [void]$sb.AppendLine()
}
# The Guidance section is written by Sync-SkillGuidance.ps1 after the file exists, so there is one renderer
[void]$sb.AppendLine('## Guidance')
[void]$sb.AppendLine()
[void]$sb.AppendLine('## Report')
[void]$sb.AppendLine()
[void]$sb.AppendLine('State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).')

$skillDir = Join-Path -Path $OutputRoot -ChildPath $s.discipline -AdditionalChildPath $s.id
$skillPath = Join-Path -Path $skillDir -ChildPath 'SKILL.md'
if ((Test-Path $skillPath) -and -not $Force) { throw "$skillPath exists; use -Force to overwrite" }
New-Item -ItemType Directory -Path $skillDir -Force | Out-Null
Set-Content -Path $skillPath -Value ($sb.ToString() -replace "`r`n", "`n") -NoNewline -Encoding utf8
Write-Host "Wrote $skillPath" -ForegroundColor Green
# Fill the Guidance section from the workflow data with the one renderer (decision record 0011)
& (Join-Path -Path $PSScriptRoot -ChildPath 'Sync-SkillGuidance.ps1') -SkillsRoot $OutputRoot | Out-Null

# Claude Code command wrapper for this repository (project scope), only when writing into the real skills tree
$realRoot = (Resolve-Path (Join-Path -Path $repo -ChildPath 'src' -AdditionalChildPath 'aa-sdlc', 'skills')).Path
if ((Resolve-Path $OutputRoot).Path -eq $realRoot) {
    $cmdDir = Join-Path -Path $repo -ChildPath '.claude' -AdditionalChildPath 'commands'
    New-Item -ItemType Directory -Path $cmdDir -Force | Out-Null
    $cmdPath = Join-Path -Path $cmdDir -ChildPath "aa-$($d.code)-$($s.id).md"
    if (-not (Test-Path $cmdPath) -or $Force) {
        $quoted = '"' + ($oneLine -replace '\\', '\\' -replace '"', '\"') + '"'
        $wrapper = "---`ndescription: $quoted`n---`nRead src/aa-sdlc/skills/$($s.discipline)/$($s.id)/SKILL.md and follow it exactly, with these arguments: `$ARGUMENTS`n"
        Set-Content -Path $cmdPath -Value $wrapper -NoNewline -Encoding utf8
        Write-Host "Wrote $cmdPath" -ForegroundColor Green
    }
}
