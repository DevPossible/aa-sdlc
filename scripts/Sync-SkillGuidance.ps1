#Requires -Version 7.0
#Requires -Modules powershell-yaml
<#
.SYNOPSIS
    Writes the shared guidance set files and every skill's Guidance section from the workflow
    data and docs/guidance.md (decision record 0012).
.DESCRIPTION
    Two outputs, both generated and both checked by scripts/Test-SkillGuidance.ps1:

    1. skills/aa-guidance/sets/<set-id>.md, one per guidance set: the set's purpose and each of
       its rules verbatim from docs/guidance.md.
    2. Each SKILL.md's Guidance section: the sets the step cites, each with its purpose and the
       path of its set file, then the step's own guidance ids verbatim and its inline guidance.
       The rendered section replaces the existing one (from "## Guidance" to the next "## "
       heading), or is inserted before "## Report", or is appended when neither exists.

    Idempotent: unchanged files are left byte-identical. Run after editing docs/guidance.md, a
    guidance set, or a step's guidance, then commit the skills and set files with that change.
.PARAMETER SourceRoot
    Path to the SDK content package. Defaults to src/aa-sdlc relative to the repository root.
.PARAMETER DocsRoot
    Path to the docs folder. Defaults to docs relative to the repository root.
.PARAMETER SkillsRoot
    The skills tree to update. Defaults to <SourceRoot>/skills; the scaffold passes its output
    root so a skill written elsewhere is filled from the real workflow data.
.EXAMPLE
    ./scripts/Sync-SkillGuidance.ps1
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]$SourceRoot = (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'src', 'aa-sdlc'),

    [Parameter()]
    [string]$DocsRoot = (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'docs'),

    [Parameter()]
    [string]$SkillsRoot
)

$ErrorActionPreference = 'Stop'
if (-not $SkillsRoot) { $SkillsRoot = Join-Path -Path $SourceRoot -ChildPath 'skills' }
$nl = "`n"
# The path a skill gives for the set files. It resolves from the framework repository's root;
# the installer rewrites it to the scope's path when it copies the skills (decision record 0012).
$setPathPrefix = 'src/aa-sdlc/skills/aa-guidance/sets'

$guidanceText = @{}
foreach ($m in [regex]::Matches((Get-Content -Path (Join-Path -Path $DocsRoot -ChildPath 'guidance.md') -Raw), '\| (G-\d+) \| (.+?) \| (.+?) \| (.+?) \|')) {
    $guidanceText[$m.Groups[1].Value] = $m.Groups[2].Value.Trim()
}
$workflow = Join-Path -Path $SourceRoot -ChildPath 'workflow'
$sets = [ordered]@{}
Get-ChildItem -Path (Join-Path -Path $workflow -ChildPath 'guidance-sets') -Filter '*.yaml' -File | Sort-Object Name | ForEach-Object {
    $y = ConvertFrom-Yaml (Get-Content -Path $_.FullName -Raw); $sets[$y.id] = $y
}

function Get-RuleLine([string]$g) {
    if (-not $guidanceText.ContainsKey($g)) { throw "guidance $g is not defined in docs/guidance.md" }
    return "- **$g** $($guidanceText[$g])"
}

function Write-IfChanged([string]$path, [string]$text) {
    $current = if (Test-Path $path) { (Get-Content -Path $path -Raw) -replace "`r`n", "`n" } else { $null }
    if ($current -eq $text) { return $false }
    New-Item -ItemType Directory -Path (Split-Path -Path $path) -Force | Out-Null
    Set-Content -Path $path -Value $text -NoNewline -Encoding utf8
    return $true
}

# 1. The set files
$changed = 0
foreach ($set in $sets.Values) {
    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.Append("# Guidance set ``$($set.id)``$nl$nl")
    [void]$sb.Append("$($set.purpose.Trim())$nl$nl")
    [void]$sb.Append("Generated from ``src/aa-sdlc/workflow/guidance-sets/$($set.id).yaml`` and ``docs/guidance.md`` by ``scripts/Sync-SkillGuidance.ps1``; do not edit by hand.$nl$nl")
    foreach ($g in @($set.guidance)) { [void]$sb.Append((Get-RuleLine $g) + $nl) }
    $path = Join-Path -Path $SkillsRoot -ChildPath 'aa-guidance' -AdditionalChildPath 'sets', "$($set.id).md"
    if (Write-IfChanged $path $sb.ToString()) { Write-Host "Updated aa-guidance/sets/$($set.id).md"; $changed++ }
}

# 2. The skills
function New-GuidanceSection([object]$step) {
    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.Append("## Guidance$nl$nl")
    $setIds = @($step.guidance_sets | Where-Object { $_ })
    $covered = [System.Collections.Generic.List[string]]::new()
    if ($setIds.Count -gt 0) {
        [void]$sb.Append("Read these guidance sets before starting; each is one file, installed beside this skill:$nl$nl")
        foreach ($setId in $setIds) {
            $set = $sets[$setId]
            if (-not $set) { throw "guidance set '$setId' does not exist" }
            [void]$sb.Append("- ``$setPathPrefix/$setId.md``: $($set.purpose.Trim())$nl")
            foreach ($g in @($set.guidance)) { if (-not $covered.Contains($g)) { $covered.Add($g) } }
        }
        [void]$sb.Append($nl)
    }
    $own = @($step.guidance | Where-Object { $_ -and -not $covered.Contains($_) })
    $inline = @($step.guidance_inline | Where-Object { $_ })
    if ($own.Count -gt 0 -or $inline.Count -gt 0) {
        [void]$sb.Append("*For this step:*$nl$nl")
        foreach ($g in $own) { [void]$sb.Append((Get-RuleLine $g) + $nl) }
        foreach ($g in $inline) { [void]$sb.Append("- $g$nl") }
        [void]$sb.Append($nl)
    }
    return $sb.ToString()
}

foreach ($skillFile in Get-ChildItem -Path $SkillsRoot -Recurse -Filter 'SKILL.md' -File) {
    $content = (Get-Content -Path $skillFile.FullName -Raw) -replace "`r`n", "`n"
    if ($content -notmatch '(?s)^---\n(.*?)\n---') { continue }
    $front = ConvertFrom-Yaml $Matches[1]
    if (-not $front.aa -or -not $front.aa.step) { continue }
    $stepFile = Join-Path -Path $workflow -ChildPath 'steps' -AdditionalChildPath "$($front.aa.step).yaml"
    if (-not (Test-Path $stepFile)) { throw "$($skillFile.FullName): no workflow step '$($front.aa.step)'" }
    $step = ConvertFrom-Yaml (Get-Content -Path $stepFile -Raw)
    $section = New-GuidanceSection $step

    $existing = [regex]::Match($content, '(?ms)^## Guidance\n.*?(?=^## |\z)')
    $report = [regex]::Match($content, '(?m)^## Report\b')
    $new = if ($existing.Success) {
        $content.Substring(0, $existing.Index) + $section + $content.Substring($existing.Index + $existing.Length)
    } elseif ($report.Success) {
        $content.Insert($report.Index, $section)
    } else {
        $content.TrimEnd("`n") + "$nl$nl" + $section.TrimEnd("`n") + $nl
    }
    if (Write-IfChanged $skillFile.FullName $new) {
        Write-Host "Updated $($skillFile.Directory.Parent.Name)/$($skillFile.Directory.Name)"
        $changed++
    }
}
Write-Host "$changed file(s) updated." -ForegroundColor Green
