#Requires -Version 7.0
#Requires -Modules powershell-yaml
<#
.SYNOPSIS
    Writes every skill's Guidance section from the workflow data and docs/guidance.md.
.DESCRIPTION
    For each SKILL.md under src/aa-sdlc/skills whose frontmatter names a workflow step, renders
    the Guidance section exactly as scripts/New-SkillScaffold.ps1 does: each guidance set the
    step cites with its purpose and its guidance lines, then the step's own guidance ids and
    inline guidance. The rendered section replaces the existing one (from the "## Guidance"
    heading to the next "## " heading), or is inserted before "## Report", or is appended when
    neither exists. Idempotent: a skill whose section already matches is left byte-identical.
    scripts/Test-SkillGuidance.ps1 is the check; this is the fix. Run it after editing
    docs/guidance.md, a guidance set, or a step's guidance, then commit the skills with that
    change (decision record 0011).
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

$guidanceText = @{}
foreach ($m in [regex]::Matches((Get-Content -Path (Join-Path -Path $DocsRoot -ChildPath 'guidance.md') -Raw), '\| (G-\d+) \| (.+?) \| (.+?) \| (.+?) \|')) {
    $guidanceText[$m.Groups[1].Value] = $m.Groups[2].Value.Trim()
}
$workflow = Join-Path -Path $SourceRoot -ChildPath 'workflow'
$sets = @{}
Get-ChildItem -Path (Join-Path -Path $workflow -ChildPath 'guidance-sets') -Filter '*.yaml' -File | ForEach-Object {
    $y = ConvertFrom-Yaml (Get-Content -Path $_.FullName -Raw); $sets[$y.id] = $y
}

function New-GuidanceSection([object]$step) {
    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.Append("## Guidance$nl$nl")
    $seen = [System.Collections.Generic.List[string]]::new()
    foreach ($setId in @($step.guidance_sets | Where-Object { $_ })) {
        $set = $sets[$setId]
        if (-not $set) { throw "guidance set '$setId' does not exist" }
        [void]$sb.Append("*From the ``$setId`` set:* $($set.purpose.Trim())$nl$nl")
        foreach ($g in @($set.guidance)) {
            if ($seen.Contains($g)) { continue }; $seen.Add($g)
            if (-not $guidanceText.ContainsKey($g)) { throw "guidance $g is not defined in docs/guidance.md" }
            [void]$sb.Append("- **$g** $($guidanceText[$g])$nl")
        }
        [void]$sb.Append($nl)
    }
    if ($step.guidance -or $step.guidance_inline) {
        [void]$sb.Append("*For this step:*$nl$nl")
        foreach ($g in @($step.guidance | Where-Object { $_ })) {
            if ($seen.Contains($g)) { continue }; $seen.Add($g)
            if (-not $guidanceText.ContainsKey($g)) { throw "guidance $g is not defined in docs/guidance.md" }
            [void]$sb.Append("- **$g** $($guidanceText[$g])$nl")
        }
        foreach ($g in @($step.guidance_inline | Where-Object { $_ })) { [void]$sb.Append("- $g$nl") }
        [void]$sb.Append($nl)
    }
    return $sb.ToString()
}

$changed = 0
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
    if ($new -ne $content) {
        Set-Content -Path $skillFile.FullName -Value $new -NoNewline -Encoding utf8
        Write-Host "Updated $($skillFile.Directory.Parent.Name)/$($skillFile.Directory.Name)"
        $changed++
    }
}
Write-Host "$changed skill(s) updated." -ForegroundColor Green
