#Requires -Version 7.0
#Requires -Modules powershell-yaml
<#
.SYNOPSIS
    Checks that the shared guidance set files and every skill's Guidance section are current
    with the workflow data and docs/guidance.md (decision record 0012).
.DESCRIPTION
    For each guidance set, requires skills/aa-guidance/sets/<set-id>.md to exist and to carry
    every rule of the set as the canonical line "**G-nn** <text>". For each SKILL.md, expands
    the sets and guidance ids in its frontmatter and requires: a reference to each cited set's
    file; each own guidance id (one no cited set supplies) present verbatim; and no set rule
    copied inline, so the shared text stays shared. Returns one string per problem; an empty
    list means current. scripts/Sync-SkillGuidance.ps1 is the fix.
.PARAMETER SourceRoot
    Path to the SDK content package. Defaults to src/aa-sdlc relative to the repository root.
.PARAMETER DocsRoot
    Path to the docs folder. Defaults to docs relative to the repository root.
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]$SourceRoot = (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'src', 'aa-sdlc'),

    [Parameter()]
    [string]$DocsRoot = (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'docs')
)

$ErrorActionPreference = 'Stop'
$problems = [System.Collections.Generic.List[string]]::new()
$setPathPrefix = 'src/aa-sdlc/skills/aa-guidance/sets'

$guidanceText = @{}
foreach ($m in [regex]::Matches((Get-Content -Path (Join-Path -Path $DocsRoot -ChildPath 'guidance.md') -Raw), '\| (G-\d+) \| (.+?) \| (.+?) \| (.+?) \|')) {
    $guidanceText[$m.Groups[1].Value] = $m.Groups[2].Value.Trim()
}
function Get-RuleLine([string]$g) { return "**$g** $($guidanceText[$g])" }

$sets = @{}
Get-ChildItem -Path (Join-Path -Path $SourceRoot -ChildPath 'workflow' -AdditionalChildPath 'guidance-sets') -Filter '*.yaml' -File | ForEach-Object {
    $sets[$_.BaseName] = ConvertFrom-Yaml (Get-Content -Path $_.FullName -Raw)
}
$skillsRoot = Join-Path -Path $SourceRoot -ChildPath 'skills'

# The shared set files
foreach ($setId in $sets.Keys) {
    $path = Join-Path -Path $skillsRoot -ChildPath 'aa-guidance' -AdditionalChildPath 'sets', "$setId.md"
    if (-not (Test-Path $path)) { $problems.Add("aa-guidance: sets/$setId.md is missing; run scripts/Sync-SkillGuidance.ps1"); continue }
    $text = Get-Content -Path $path -Raw
    foreach ($g in @($sets[$setId].guidance)) {
        if (-not $guidanceText.ContainsKey($g)) { $problems.Add("guidance set ${setId}: cites $g, which docs/guidance.md does not define"); continue }
        if (-not $text.Contains((Get-RuleLine $g))) { $problems.Add("aa-guidance/sets/${setId}.md: $g is missing or does not match docs/guidance.md verbatim") }
    }
}

# The skills
foreach ($skillFile in Get-ChildItem -Path $skillsRoot -Recurse -Filter 'SKILL.md' -File) {
    $label = "$($skillFile.Directory.Parent.Name)/$($skillFile.Directory.Name)"
    $content = Get-Content -Path $skillFile.FullName -Raw
    if ($content -notmatch '(?s)^---\r?\n(.*?)\r?\n---') { continue } # Test-SkillStructure reports this
    $front = ConvertFrom-Yaml $Matches[1]
    if (-not $front.aa -or -not $front.aa.step) { continue }

    $covered = [System.Collections.Generic.List[string]]::new()
    foreach ($setId in @($front.aa.guidance_sets | Where-Object { $_ })) {
        if (-not $sets.ContainsKey($setId)) { $problems.Add("${label}: guidance set '$setId' does not exist"); continue }
        if (-not $content.Contains("$setPathPrefix/$setId.md")) { $problems.Add("${label}: does not point at $setPathPrefix/$setId.md") }
        foreach ($g in @($sets[$setId].guidance)) {
            if (-not $covered.Contains($g)) { $covered.Add($g) }
            if ($guidanceText.ContainsKey($g) -and $content.Contains((Get-RuleLine $g))) {
                $problems.Add("${label}: copies set rule $g inline; it belongs to the shared set file only")
            }
        }
    }
    foreach ($g in @($front.aa.guidance | Where-Object { $_ })) {
        if ($covered.Contains($g)) { continue }
        if (-not $guidanceText.ContainsKey($g)) { $problems.Add("${label}: cites $g, which docs/guidance.md does not define"); continue }
        if (-not $content.Contains((Get-RuleLine $g))) { $problems.Add("${label}: guidance $g is missing or does not match docs/guidance.md verbatim") }
    }
}

return @($problems)
