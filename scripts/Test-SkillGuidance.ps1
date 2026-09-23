#Requires -Version 7.0
#Requires -Modules powershell-yaml
<#
.SYNOPSIS
    Checks that every skill carries its guidance verbatim from docs/guidance.md.
.DESCRIPTION
    For each SKILL.md under src/aa-sdlc/skills, expands the guidance sets and guidance ids in its
    frontmatter and requires the file to contain the canonical line "**G-nn** <text>" for each,
    with the text exactly as the registry states it. Guidance is cited by id and must read the
    same in every skill; a paraphrase, however careful, is drift. Returns one string per problem;
    an empty list means every skill is current. This is the rail that lets the skill prose be
    optimised (decision record 0011) without touching the guidance.
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

$guidanceText = @{}
foreach ($m in [regex]::Matches((Get-Content -Path (Join-Path -Path $DocsRoot -ChildPath 'guidance.md') -Raw), '\| (G-\d+) \| (.+?) \| (.+?) \| (.+?) \|')) {
    $guidanceText[$m.Groups[1].Value] = $m.Groups[2].Value.Trim()
}

$sets = @{}
Get-ChildItem -Path (Join-Path -Path $SourceRoot -ChildPath 'workflow' -AdditionalChildPath 'guidance-sets') -Filter '*.yaml' -File | ForEach-Object {
    $sets[$_.BaseName] = ConvertFrom-Yaml (Get-Content -Path $_.FullName -Raw)
}

foreach ($skillFile in Get-ChildItem -Path (Join-Path -Path $SourceRoot -ChildPath 'skills') -Recurse -Filter 'SKILL.md' -File) {
    $label = "$($skillFile.Directory.Parent.Name)/$($skillFile.Directory.Name)"
    $content = Get-Content -Path $skillFile.FullName -Raw
    if ($content -notmatch '(?s)^---\r?\n(.*?)\r?\n---') { continue } # Test-SkillStructure reports this
    $front = ConvertFrom-Yaml $Matches[1]
    if (-not $front.aa) { continue }

    $ids = [System.Collections.Generic.List[string]]::new()
    foreach ($setId in @($front.aa.guidance_sets | Where-Object { $_ })) {
        if (-not $sets.ContainsKey($setId)) { $problems.Add("${label}: guidance set '$setId' does not exist"); continue }
        foreach ($g in @($sets[$setId].guidance)) { if (-not $ids.Contains($g)) { $ids.Add($g) } }
    }
    foreach ($g in @($front.aa.guidance | Where-Object { $_ })) { if (-not $ids.Contains($g)) { $ids.Add($g) } }

    foreach ($g in $ids) {
        if (-not $guidanceText.ContainsKey($g)) { $problems.Add("${label}: cites $g, which docs/guidance.md does not define"); continue }
        $expected = "**$g** $($guidanceText[$g])"
        if (-not $content.Contains($expected)) {
            $problems.Add("${label}: guidance $g is missing or does not match docs/guidance.md verbatim")
        }
    }
}

return @($problems)
