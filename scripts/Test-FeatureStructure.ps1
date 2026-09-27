#Requires -Version 7.0
<#
.SYNOPSIS
    Validates the structure of the framework's feature files.
.DESCRIPTION
    Checks every .feature file under features/ declares exactly one Feature, has at least one
    Scenario, and that every Scenario has a Then step and a Given or When step (either its own
    or inherited from a Background). Returns the list of problems found; an empty list means
    the feature files are structurally valid. This is a shape check, not a Gherkin parse.
.PARAMETER FeaturesRoot
    Path to the features folder. Defaults to features/ relative to the repo root.
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]$FeaturesRoot = (Join-Path $PSScriptRoot '..' 'features')
)

$ErrorActionPreference = 'Stop'
$problems = [System.Collections.Generic.List[string]]::new()

if (-not (Test-Path $FeaturesRoot)) {
    $problems.Add("Missing features directory: $FeaturesRoot")
    return $problems
}
$FeaturesRoot = (Resolve-Path $FeaturesRoot).Path

$featureFiles = Get-ChildItem -Path $FeaturesRoot -Recurse -Filter '*.feature' -File
if ($featureFiles.Count -eq 0) {
    Write-Warning 'No feature files defined yet.'
}

$seenFeatureIds = @{}
foreach ($file in $featureFiles) {
    $name = $file.FullName.Substring($FeaturesRoot.Length).TrimStart('\', '/')
    $lines = Get-Content $file.FullName

    $featureCount = ($lines | Where-Object { $_ -match '^\s*Feature:' }).Count
    if ($featureCount -ne 1) {
        $problems.Add("${name}: expected exactly one 'Feature:', found $featureCount")
    }

    # Every feature says what can execute it: exactly one of @cli, @health, @agent (decision record 0005)
    $featureLine = ($lines | Select-String '^\s*Feature:' | Select-Object -First 1).LineNumber
    $tagLines = if ($featureLine -gt 1) { $lines[0..($featureLine - 2)] | Where-Object { $_ -match '^\s*@' } } else { @() }
    $executorTags = @([regex]::Matches(($tagLines -join ' '), '@(cli|health|agent)\b') | ForEach-Object { $_.Value } | Sort-Object -Unique)
    if ($executorTags.Count -ne 1) {
        $problems.Add("${name}: expected exactly one executor tag (@cli, @health, or @agent) on the feature, found: $($executorTags -join ' ')")
    }

    # Every feature has one stable id, unique in the repository, and every scenario one derived
    # from it, so tests can name what they prove (G-49); scripts/Add-FeatureId.ps1 assigns them
    $featureIds = @([regex]::Matches(($tagLines -join ' '), '@(F-\d+)(?![-\d])') | ForEach-Object { $_.Groups[1].Value })
    $featureId = $null
    if ($featureIds.Count -ne 1) {
        $problems.Add("${name}: expected exactly one feature id (@F-nnn) on the feature, found $($featureIds.Count); run scripts/Add-FeatureId.ps1")
    } else {
        $featureId = $featureIds[0]
        if ($seenFeatureIds.ContainsKey($featureId)) {
            $problems.Add("${name}: feature id $featureId is also used by $($seenFeatureIds[$featureId])")
        } else {
            $seenFeatureIds[$featureId] = $name
        }
    }
    $seenScenarioIds = @{}

    $blockPattern = '^\s*(Background|Scenario Outline|Scenario|Example):'
    $blockIndexes = @()
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match $blockPattern) { $blockIndexes += $i }
    }

    $backgroundHasSetup = $false
    $scenarioCount = 0
    for ($b = 0; $b -lt $blockIndexes.Count; $b++) {
        $start = $blockIndexes[$b]
        $end = if ($b + 1 -lt $blockIndexes.Count) { $blockIndexes[$b + 1] - 1 } else { $lines.Count - 1 }
        $body = $lines[$start..$end]
        $hasSetup = [bool]($body | Where-Object { $_ -match '^\s*(Given|When)\b' })
        $hasThen = [bool]($body | Where-Object { $_ -match '^\s*Then\b' })

        if ($lines[$start] -match '^\s*Background:') {
            $backgroundHasSetup = $hasSetup
            continue
        }

        $scenarioCount++
        $title = ($lines[$start] -replace $blockPattern, '').Trim()
        if ($featureId) {
            $scenarioTags = if ($start -gt 0 -and $lines[$start - 1] -match '^\s*@') { $lines[$start - 1] } else { '' }
            $scenarioIds = @([regex]::Matches($scenarioTags, '@(F-\d+-\d+)') | ForEach-Object { $_.Groups[1].Value })
            if ($scenarioIds.Count -ne 1 -or -not $scenarioIds[0].StartsWith("$featureId-")) {
                $problems.Add("${name}: scenario '$title' needs exactly one id of the form @$featureId-nn; run scripts/Add-FeatureId.ps1")
            } elseif ($seenScenarioIds.ContainsKey($scenarioIds[0])) {
                $problems.Add("${name}: scenario id $($scenarioIds[0]) is used twice")
            } else {
                $seenScenarioIds[$scenarioIds[0]] = $true
            }
        }
        if (-not $hasThen) {
            $problems.Add("${name}: scenario '$title' has no Then step")
        }
        if (-not $hasSetup -and -not $backgroundHasSetup) {
            $problems.Add("${name}: scenario '$title' has no Given or When step, and no Background supplies one")
        }
    }

    if ($scenarioCount -eq 0) {
        $problems.Add("${name}: no Scenario found")
    }
}

return $problems
