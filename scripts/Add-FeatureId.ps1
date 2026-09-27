#Requires -Version 7.0
<#
.SYNOPSIS
    Gives every feature and scenario that has no id the next free one (G-49).
.DESCRIPTION
    A feature id is @F-nnn, unique in the repository, on the tag line above "Feature:". A
    scenario id is its feature's id plus -nn, unique within the feature, on the tag line above
    the scenario. Ids already present are kept: nothing is renumbered, and a number is never
    reused, because the next free number is always one past the highest in use. Features
    without an id are numbered in path order, and scenarios in file order.
.PARAMETER Path
    The features folder. Defaults to features/ in this repository.
.EXAMPLE
    ./scripts/Add-FeatureId.ps1
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]$Path = (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'features')
)

$ErrorActionPreference = 'Stop'

$scenarioPattern = '^(\s*)(Scenario Outline|Scenario|Example):'
$files = Get-ChildItem -Path $Path -Recurse -Filter '*.feature' | Sort-Object -Property FullName

function Get-TagLineIndex {
    # The index of the tag line directly above line $At, or -1 when there is none.
    param([string[]]$Lines, [int]$At)
    if ($At -gt 0 -and $Lines[$At - 1] -match '^\s*@') { return $At - 1 }
    return -1
}

# The highest feature number in use across the repository, so a new one is never a reused one.
$nextFeature = 1
foreach ($file in $files) {
    foreach ($m in [regex]::Matches((Get-Content -Path $file.FullName -Raw), '@F-(\d+)(?![-\d])')) {
        $nextFeature = [Math]::Max($nextFeature, [int]$m.Groups[1].Value + 1)
    }
}

$changed = 0
foreach ($file in $files) {
    $raw = Get-Content -Path $file.FullName -Raw
    $newline = if ($raw -match "`r`n") { "`r`n" } else { "`n" }
    $lines = [System.Collections.Generic.List[string]]($raw -split "\r?\n")
    $before = $raw

    $featureAt = $lines.FindIndex({ param($l) $l -match '^\s*Feature:' })
    if ($featureAt -lt 0) { continue }
    $tagAt = Get-TagLineIndex -Lines $lines -At $featureAt
    $featureId = if ($tagAt -ge 0 -and $lines[$tagAt] -match '@(F-\d+)(?![-\d])') { $Matches[1] } else { $null }
    if (-not $featureId) {
        $featureId = 'F-{0:D3}' -f $nextFeature
        $nextFeature++
        if ($tagAt -ge 0) {
            $lines[$tagAt] = "$($lines[$tagAt].TrimEnd()) @$featureId"
        } else {
            $lines.Insert($featureAt, "@$featureId")
        }
    }

    # The highest scenario number in use in this feature.
    $escaped = [regex]::Escape($featureId)
    $nextScenario = 1
    foreach ($m in [regex]::Matches(($lines -join "`n"), "@$escaped-(\d+)")) {
        $nextScenario = [Math]::Max($nextScenario, [int]$m.Groups[1].Value + 1)
    }

    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -notmatch $scenarioPattern) { continue }
        $indent = $Matches[1]
        $tagAt = Get-TagLineIndex -Lines $lines -At $i
        if ($tagAt -ge 0 -and $lines[$tagAt] -match "@$escaped-\d+") { continue }
        $scenarioId = '{0}-{1:D2}' -f $featureId, $nextScenario
        $nextScenario++
        if ($tagAt -ge 0) {
            $lines[$tagAt] = "$($lines[$tagAt].TrimEnd()) @$scenarioId"
        } else {
            $lines.Insert($i, "$indent@$scenarioId")
            $i++
        }
    }

    $after = $lines -join $newline
    if ($after -ne $before) {
        [System.IO.File]::WriteAllText($file.FullName, $after)
        $changed++
        Write-Verbose "ids added: $($file.Name) ($featureId)"
    }
}
Write-Host "Feature ids: $changed file(s) updated; next free feature id is F-$('{0:D3}' -f $nextFeature)"
