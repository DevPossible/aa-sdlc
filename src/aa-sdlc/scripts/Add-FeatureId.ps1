#Requires -Version 7.0
<#
.SYNOPSIS
    Gives every feature and scenario on the knowledge base feature pages that has no id the next
    free one (G-49, decision record 0019).
.DESCRIPTION
    Ids are assigned on the page, where the requirement lives. A feature id is F-nnn, unique in
    the project, in the header of the page's Feature table; a scenario id is its feature's id
    plus -nn, unique within the feature, in the header of its Scenario table. An empty header
    cell ("| Feature |  |" or "| Scenario |  |") is filled, and the page title or the scenario's
    heading gains the id in front. Ids already present are kept: nothing is renumbered, and a
    number is never reused, because the next free number is always one past the highest in use.
    Pages without a feature id are numbered in path order, and scenarios in page order.
.PARAMETER KnowledgeRoot
    The knowledge base folder: the project's root, holding the Requirements section.
.EXAMPLE
    ./Add-FeatureId.ps1 -KnowledgeRoot docs/knowledge
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$KnowledgeRoot
)

$ErrorActionPreference = 'Stop'

$requirements = Join-Path -Path $KnowledgeRoot -ChildPath 'Requirements'
$candidates = Get-ChildItem -Path $requirements -Recurse -Filter '*.md' -File -ErrorAction SilentlyContinue
$pages = @($candidates | Where-Object { (Get-Content -Path $_.FullName -Raw) -match '(?m)^\|\s*Feature\s*\|' } | Sort-Object -Property FullName)

$emptyFeature = '^\|\s*Feature\s*\|\s*\|\s*$'
$emptyScenario = '^\|\s*Scenario\s*\|\s*\|\s*$'

# The highest feature number in use across the project, so a new one is never a reused one.
$nextFeature = 1
foreach ($page in $pages) {
    foreach ($m in [regex]::Matches((Get-Content -Path $page.FullName -Raw), '(?m)^\|\s*Feature\s*\|\s*F-(\d+)\s*\|')) {
        $nextFeature = [Math]::Max($nextFeature, [int]$m.Groups[1].Value + 1)
    }
}

function Add-IdToHeading {
    # Puts the id in front of the nearest heading above line $At, unless it is already there.
    param([System.Collections.Generic.List[string]]$Lines, [int]$At, [string]$Id, [string]$Level)
    for ($h = $At - 1; $h -ge 0; $h--) {
        if ($Lines[$h] -match "^$Level (.*)$") {
            if ($Matches[1] -notmatch "^$([regex]::Escape($Id))\b") { $Lines[$h] = "$Level $Id $($Matches[1].Trim())" }
            return
        }
    }
}

$changed = 0
foreach ($page in $pages) {
    $raw = Get-Content -Path $page.FullName -Raw
    $newline = if ($raw -match "`r`n") { "`r`n" } else { "`n" }
    $lines = [System.Collections.Generic.List[string]]($raw -split "\r?\n")

    $featureAt = $lines.FindIndex({ param($l) $l -match '^\|\s*Feature\s*\|' })
    if ($lines[$featureAt] -match $emptyFeature) {
        $featureId = 'F-{0:D3}' -f $nextFeature
        $nextFeature++
        $lines[$featureAt] = "| Feature | $featureId |"
        Add-IdToHeading -Lines $lines -At $featureAt -Id $featureId -Level '#'
    } else {
        $featureId = [regex]::Match($lines[$featureAt], 'F-\d+').Value
    }

    # The highest scenario number in use on this page.
    $escaped = [regex]::Escape($featureId)
    $nextScenario = 1
    foreach ($m in [regex]::Matches(($lines -join "`n"), "(?m)^\|\s*Scenario\s*\|\s*$escaped-(\d+)\s*\|")) {
        $nextScenario = [Math]::Max($nextScenario, [int]$m.Groups[1].Value + 1)
    }
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -notmatch $emptyScenario) { continue }
        $scenarioId = '{0}-{1:D2}' -f $featureId, $nextScenario
        $nextScenario++
        $lines[$i] = "| Scenario | $scenarioId |"
        Add-IdToHeading -Lines $lines -At $i -Id $scenarioId -Level '##'
    }

    $after = $lines -join $newline
    if ($after -ne $raw) {
        [System.IO.File]::WriteAllText($page.FullName, $after)
        $changed++
        Write-Verbose "ids added: $($page.Name) ($featureId)"
    }
}
Write-Host "Feature ids: $changed page(s) updated; next free feature id is F-$('{0:D3}' -f $nextFeature)"
