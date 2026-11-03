#Requires -Version 7.4
<#
.SYNOPSIS
    Guards feature-page conversion and fail-closed synchronization (AP-18).
#>
[CmdletBinding()]
param([Parameter(Mandatory)][string]$ScriptsRoot, [string]$ResultPath, [string]$RunId)
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $ScriptsRoot 'AaFeatures.psm1') -Force
$script:checks = 0
$script:caseResults = [Collections.Generic.List[object]]::new()
if ($ResultPath -and -not $RunId) { throw 'ResultPath requires a fresh RunId' }
function Assert-Check([bool]$Condition, [string]$Name) {
    $script:caseResults.Add(@{ name = $Name; outcome = if ($Condition) { 'Passed' } else { 'Failed' } })
    if ($ResultPath) {
        $fullPath = [IO.Path]::GetFullPath($ResultPath)
        New-Item -ItemType Directory -Path (Split-Path $fullPath -Parent) -Force | Out-Null
        $report = @{ schemaVersion = 1; component = 'feature-page-conversion'; runId = $RunId; checks = @($script:caseResults.ToArray()) }
        $report | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath ($fullPath + '.tmp') -Encoding utf8
        Move-Item -LiteralPath ($fullPath + '.tmp') -Destination $fullPath -Force
    }
    if (-not $Condition) { throw "FAIL: $Name" }
    $script:checks++
    Write-Output "PASS: $Name"
}
function Assert-Rejected([scriptblock]$Action, [string]$Name) {
    $rejected = $false
    try { $null = & $Action } catch { $rejected = $true }
    Assert-Check $rejected $Name
}
function Read-TestPage([string]$Page) {
    & (Get-Module AaFeatures) { param($Text) Read-FeaturePage -Markdown $Text } $Page
}
function Convert-TestPage([string]$Page) {
    ConvertFrom-FeaturePage -Markdown $Page -Source 'https://example.invalid/AP-18' -Version '7'
}
function ConvertTo-TransportPage([string]$Page, [switch]$EmptyHeaders) {
    $result = [regex]::Replace($Page, '(?m)^## ([^\r\n]+)', { param($Match) $Match.Groups[1].Value + "`n--------------------" })
    if ($EmptyHeaders) {
        $result = [regex]::Replace($result, '(?m)^(\| (?:Feature|Scenario|Step) \| [^\r\n]+)\r?\n\| --- \| --- \|', { param($Match) "|  |  |`n| --- | --- |`n" + $Match.Groups[1].Value })
    }
    $result
}
$gherkin = @'
@AP-18 @F-900
Feature: Preserve requirements
  Keep prose and escaped pipes intact.

  Background:
    Given an isolated fixture

  @F-900-01 @stable
  Scenario: Approved example
    Given a value with a | pipe and ## text
    When conversion runs
    Then approved content survives

  @F-900-02
  Scenario: Draft example
    Given draft work
    When conversion runs
    Then it stays on the page

  @F-900-03
  Scenario: Retired example
    Given retired work
    When conversion runs
    Then it stays on the page
'@
$canonical = ConvertTo-FeaturePage -Text $gherkin -File 'preserve'
$statuses = [Collections.Generic.Queue[string]]::new()
@('Approved', 'Draft', 'Retired') | ForEach-Object { $statuses.Enqueue($_) }
$mixed = [regex]::Replace($canonical, '\| Status \| Approved \|', { '| Status | ' + $statuses.Dequeue() + ' |' })
$expected = Convert-TestPage $mixed
Assert-Check ($expected.Contains('@F-900-01') -and -not $expected.Contains('@F-900-02') -and -not $expected.Contains('@F-900-03')) 'only Approved scenarios are generated'
Assert-Check ($expected.Contains('version 7') -and -not (Test-FeatureProvenance -Text $expected)) 'source version and checksum are preserved'
Assert-Check ([bool](Test-FeatureProvenance -Text $expected.Replace('approved content survives', 'tampered content'))) 'provenance rejects changed generated content'
Assert-Check ([bool](Test-FeatureProvenance -Text $gherkin)) 'provenance rejects a missing generated header'
Assert-Check ((Get-FeatureChecksum -Body "same`ncontent") -ceq (Get-FeatureChecksum -Body "same`r`ncontent")) 'checksum normalizes line endings only'
Assert-Check ((Read-TestPage $mixed).Scenarios.Count -eq 3) 'ATX scenario accounting'
foreach ($emptyHeaders in @($false, $true)) {
    $transport = ConvertTo-TransportPage $mixed -EmptyHeaders:$emptyHeaders
    $variant = if ($emptyHeaders) { 'empty headers' } else { 'standard headers' }
    Assert-Check ((Read-TestPage $transport).Scenarios.Count -eq 3) "MCP export scenario accounting: $variant"
    Assert-Check ((Convert-TestPage $transport) -ceq $expected) "MCP export preserves complete generated content: $variant"
}
$withoutIds = [regex]::Replace($mixed, '(?m)^## F-900-\d+ ', '## ')
Assert-Check ((Convert-TestPage $withoutIds) -ceq $expected) 'heading text is not used as the scenario ID'
Assert-Check ((Convert-TestPage ($mixed.Replace('| Status | Approved |', '| Status | Draft |'))) -eq '') 'valid all-Draft source generates no feature'
Assert-Check ((Convert-TestPage ($mixed.Replace('| Status | Approved |', '| Status | Retired |'))) -eq '') 'valid all-Retired source generates no feature'
$outline = ConvertTo-FeaturePage -File 'outline' -Text @'
@F-901
Feature: Examples
  @F-901-01
  Scenario Outline: Preserve cells
    Given value <value>
    Then conversion preserves it
    Examples:
      | value | expected |
      | a\|b | yes |
'@
$outlineOutput = Convert-TestPage $outline
Assert-Check ((Convert-TestPage (ConvertTo-TransportPage $outline -EmptyHeaders)) -ceq $outlineOutput) 'outline examples preserve escaped cells'
Assert-Rejected { Convert-TestPage $outline.Replace('### Examples', '### Not examples') } 'outline requires an Examples table'
Assert-Rejected { Convert-TestPage ($outline + "`n### Examples`n`n| value | expected |`n| --- | --- |`n| extra | yes |") } 'duplicate Examples blocks cannot silently lose cases'
Assert-Check ($expected.Contains('Given a value with a | pipe and ## text')) 'step text is not normalized as Markdown headings'
Assert-Rejected { Convert-TestPage $mixed.Replace('## F-900-01 Approved example', 'Approved example without heading') } 'unaccounted scenario table is rejected'
Assert-Rejected { Convert-TestPage $mixed.Replace('| Scenario | F-900-02 |', '| Scenario | F-900-01 |') } 'duplicate scenario IDs are rejected'
Assert-Rejected { Convert-TestPage $mixed.Replace('| Scenario | F-900-02 |', '| Scenario | F-999-02 |') } 'foreign scenario IDs are rejected'
Assert-Rejected { Convert-TestPage $mixed.Replace('| Status | Draft |', '| Status | Unknown |') } 'unknown status is rejected'
Assert-Rejected { Convert-TestPage $mixed.Replace('| --- | --- |', '| malformed | separator |') } 'malformed table separator is rejected'
Assert-Rejected { Convert-TestPage $mixed.Replace('| Given | draft work |', '| Given | draft work | extra |') } 'malformed row width is rejected'
Assert-Rejected { Convert-TestPage $mixed.Replace('| Given | draft work |', '| Invalid | draft work |') } 'invalid step keyword is rejected'
Assert-Rejected { Convert-TestPage $mixed.Replace('| Given | draft work |', '| Given |  |') } 'empty step text is rejected'
Assert-Rejected { Convert-TestPage $mixed.Replace('| Kind | Scenario |', '| Kind | Unsupported |') } 'unknown scenario kind is rejected'
Assert-Rejected { Convert-TestPage $mixed.Replace('| Status | Draft |', "| Status | Draft |`n| Status | Approved |") } 'duplicate metadata fields are rejected'
Assert-Rejected { Convert-TestPage $mixed.Replace('| Given | an isolated fixture |', '| Invalid | an isolated fixture |') } 'invalid Background step is rejected'
Assert-Rejected { Convert-TestPage 'Not a feature page' } 'missing feature metadata is rejected'
Assert-Rejected { Convert-TestPage ($mixed + "`n| Step | Text |`n| --- | --- |`n| Then | an added condition |") } 'extra unconsumed Step table cannot lose an acceptance condition'

# AP-38: two independently owned Approved scenarios must not expand each other's projection.
$selectionPage = $mixed.Replace('| Status | Draft |', '| Status | Approved |').Replace('| Tags | @stable |', '| Tags | @stable @component-a |').Replace('| Tags |  |', '| Tags | @component-b |').Replace('| Name | Draft example |', '| Name | Component B example |')
$selected = ConvertFrom-FeaturePage -Markdown $selectionPage -Source 'fixture:AP-38' -Version '9' -ScenarioId @('F-900-01')
Assert-Check ($selected.Contains('@F-900-01') -and $selected.Contains('@component-a') -and -not $selected.Contains('@F-900-02') -and -not $selected.Contains('@component-b')) 'selection isolates an Approved component scenario'
Assert-Check ($selected.Contains('Background:') -and $selected.Contains('Given an isolated fixture') -and $selected.Contains('@stable @component-a') -and $selected.Contains('a value with a | pipe and ## text')) 'selection preserves Background tags and exact step text'
$both = ConvertFrom-FeaturePage -Markdown $selectionPage -Source 'fixture:AP-38' -Version '9' -ScenarioId @('F-900-02', 'F-900-01')
Assert-Check ($both.IndexOf('@F-900-01') -lt $both.IndexOf('@F-900-02')) 'selection emits source order instead of caller order'
Assert-Check ($both -ceq (ConvertFrom-FeaturePage -Markdown $selectionPage -Source 'fixture:AP-38' -Version '9' -ScenarioId @('F-900-01', 'F-900-02'))) 'selection ordering is deterministic'
Assert-Check (($both -split "`n")[2] -ceq '# Selected scenario IDs: F-900-01 F-900-02') 'selection metadata records exact source ordered IDs in the body'
Assert-Check (($selected -split "`n")[0] -ceq '# Generated from the knowledge base page fixture:AP-38 (version 9). Do not edit: change the page, then pull it.') 'selection leaves the provenance source header unchanged'
Assert-Check (-not (Test-FeatureProvenance -Text $selected)) 'selected output has valid provenance'
Assert-Check ([bool](Test-FeatureProvenance -Text $selected.Replace('# Selected scenario IDs: F-900-01', '# Selected scenario IDs: F-900-02'))) 'selection metadata is covered by the checksum'
$changedUnselectedPage = $selectionPage.Replace('| Given | draft work |', '| Given | changed unselected work |')
$changedUnselected = ConvertFrom-FeaturePage -Markdown $changedUnselectedPage -Source 'fixture:AP-38' -Version '9' -ScenarioId @('F-900-01')
Assert-Check (($selected -split "`n")[3] -ceq "# Source Markdown checksum: $(Get-FeatureChecksum -Body $selectionPage)" -and ($changedUnselected -split "`n")[3] -ceq "# Source Markdown checksum: $(Get-FeatureChecksum -Body $changedUnselectedPage)" -and ($selected -split "`n")[3] -cne ($changedUnselected -split "`n")[3] -and ($selected -split "`n", 5)[4] -ceq ($changedUnselected -split "`n", 5)[4]) 'selection checksum binds full Markdown including unselected rows'
Assert-Check ((ConvertFrom-FeaturePage -Markdown ($selectionPage.Replace("`r`n", "`n").Replace("`n", "`r`n")) -Source 'fixture:AP-38' -Version '9' -ScenarioId @('F-900-01')) -ceq $selected) 'selected source checksum normalizes Markdown line endings'
Assert-Check ([bool](Test-FeatureProvenance -Text $selected.Replace("# Source Markdown checksum: $(Get-FeatureChecksum -Body $selectionPage)", "# Source Markdown checksum: $(Get-FeatureChecksum -Body $changedUnselectedPage)"))) 'full Markdown source checksum is covered by generated provenance'
$selectedOutline = ConvertFrom-FeaturePage -Markdown $outline -Source 'fixture:AP-38' -ScenarioId @('F-901-01')
Assert-Check ($selectedOutline.Contains('Scenario Outline: Preserve cells') -and $selectedOutline.Contains('Examples:') -and $selectedOutline.Contains('a\|b')) 'selection preserves outlines examples and escaped cells'
Assert-Check (-not $expected.Contains('# Selected scenario IDs:') -and [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($expected))) -ceq '3AABCF56AF9B3D925E63B7188C823A1F66F5E2D02ADED720D4021805EBE0F888') 'omitted selection retains the default output without projection metadata'
Assert-Rejected { ConvertFrom-FeaturePage -Markdown $selectionPage -Source 'fixture:AP-38' -ScenarioId $null } 'selection rejects explicit null'
Assert-Rejected { ConvertFrom-FeaturePage -Markdown $selectionPage -Source 'fixture:AP-38' -ScenarioId @() } 'selection rejects an empty collection'
Assert-Rejected { ConvertFrom-FeaturePage -Markdown $selectionPage -Source 'fixture:AP-38' -ScenarioId @('') } 'selection rejects an empty ID'
Assert-Rejected { ConvertFrom-FeaturePage -Markdown $selectionPage -Source 'fixture:AP-38' -ScenarioId @(' ') } 'selection rejects a whitespace ID'
Assert-Rejected { ConvertFrom-FeaturePage -Markdown $selectionPage -Source 'fixture:AP-38' -ScenarioId @(' F-900-01') } 'selection rejects padded IDs'
Assert-Rejected { ConvertFrom-FeaturePage -Markdown $selectionPage -Source 'fixture:AP-38' -ScenarioId @('F-900-01', 'F-900-01') } 'selection rejects duplicate IDs'
Assert-Rejected { ConvertFrom-FeaturePage -Markdown $selectionPage -Source 'fixture:AP-38' -ScenarioId @('f-900-01') } 'selection rejects ID case mismatch'
Assert-Rejected { ConvertFrom-FeaturePage -Markdown $selectionPage -Source 'fixture:AP-38' -ScenarioId @('F-999-01') } 'selection rejects unknown IDs'
Assert-Rejected { ConvertFrom-FeaturePage -Markdown $mixed -Source 'fixture:AP-38' -ScenarioId @('F-900-02') } 'selection cannot approve a Draft scenario'
Assert-Rejected { ConvertFrom-FeaturePage -Markdown $selectionPage -Source 'fixture:AP-38' -ScenarioId @('F-900-03') } 'selection cannot revive a Retired scenario'
Assert-Rejected { ConvertFrom-FeaturePage -Markdown $mixed -Source 'fixture:AP-38' -ScenarioId @('F-900-01', 'F-900-02') } 'selection rejects a partly Approved set'
Assert-Rejected { ConvertFrom-FeaturePage -Markdown $selectionPage.Replace('| Given | draft work |', '| Invalid | draft work |') -Source 'fixture:AP-38' -ScenarioId @('F-900-01') } 'selection validates malformed unselected scenarios'
Assert-Rejected { ConvertFrom-FeaturePage -Markdown ($selectionPage + "`n| Step | Text |`n| --- | --- |`n| Then | lost condition |") -Source 'fixture:AP-38' -ScenarioId @('F-900-01') } 'selection rejects unconsumed source tables'

$temporaryRoot = Join-Path ([IO.Path]::GetTempPath()) ('ap18-' + [guid]::NewGuid().ToString('N'))
try {
    $knowledge = Join-Path $temporaryRoot 'knowledge'
    $requirements = Join-Path $knowledge 'Requirements/tooling'
    $features = Join-Path $temporaryRoot 'features'
    $pagePath = Join-Path $requirements 'preserve.md'
    New-Item -ItemType Directory -Path $requirements -Force | Out-Null
    Set-Content -LiteralPath $pagePath -Value (ConvertTo-TransportPage $mixed -EmptyHeaders)
    $sync = Join-Path $ScriptsRoot 'Sync-FeatureFiles.ps1'
    $null = & $sync -KnowledgeRoot $knowledge -FeaturesRoot $features
    $featurePath = Join-Path $features 'tooling/preserve.feature'
    Assert-Check (Test-Path -LiteralPath $featurePath) 'sync writes the Approved export'
    $before = Get-Content -LiteralPath $featurePath -Raw
    Assert-Check (@(& $sync -KnowledgeRoot $knowledge -FeaturesRoot $features -Check).Count -eq 0) 'sync check agrees with generated export'
    $null = & $sync -KnowledgeRoot $knowledge -FeaturesRoot $features
    Assert-Check ((Get-Content -LiteralPath $featurePath -Raw) -ceq $before) 'repeated sync is idempotent'
    Set-Content -LiteralPath $pagePath -Value ([regex]::Replace($mixed, '(?m)^\|', ' |'))
    $null = & $sync -KnowledgeRoot $knowledge -FeaturesRoot $features
    Assert-Check ((Get-Content -LiteralPath $featurePath -Raw) -ceq $before) 'indented source tables cannot delete a generated feature'
    Set-Content -LiteralPath $pagePath -Value $mixed.Replace('## F-900-01 Approved example', 'Approved example without heading')
    Assert-Rejected { & $sync -KnowledgeRoot $knowledge -FeaturesRoot $features } 'invalid source aborts sync before deletion'
    Assert-Check ((Get-Content -LiteralPath $featurePath -Raw) -ceq $before) 'invalid source preserves existing generated bytes'
    Set-Content -LiteralPath $pagePath -Value $mixed
    Set-Content -LiteralPath (Join-Path $requirements 'other.md') -Value $mixed.Replace('| File | preserve |', '| File | other |').Replace('| Status | Draft |', '| Status | Unknown |')
    Assert-Rejected { & $sync -KnowledgeRoot $knowledge -FeaturesRoot $features } 'one invalid page aborts the whole write batch'
    Assert-Check ((Get-Content -LiteralPath $featurePath -Raw) -ceq $before) 'failed batch preserves earlier valid files'
    $otherPath = Join-Path $requirements 'other.md'
    Set-Content -LiteralPath $otherPath -Value $mixed.Replace('| Feature | F-900 |', '| Broken | F-900 |')
    Assert-Rejected { & $sync -KnowledgeRoot $knowledge -FeaturesRoot $features } 'scenario tables without feature metadata abort sync'
    Set-Content -LiteralPath $otherPath -Value $mixed
    Assert-Rejected { & $sync -KnowledgeRoot $knowledge -FeaturesRoot $features } 'duplicate generated targets abort sync'
    Set-Content -LiteralPath $otherPath -Value $mixed.Replace('| File | preserve |', '| File | ../escape |')
    Assert-Rejected { & $sync -KnowledgeRoot $knowledge -FeaturesRoot $features } 'feature filename cannot escape its topic'
    Set-Content -LiteralPath $pagePath -Value $mixed.Replace('approved content survives', 'newer approved condition')
    foreach ($invalidName in @('z?', 'CON', 'NUL.txt', 'trailing.')) {
        Set-Content -LiteralPath $otherPath -Value $mixed.Replace('| File | preserve |', "| File | $invalidName |")
        Assert-Rejected { & $sync -KnowledgeRoot $knowledge -FeaturesRoot $features } "invalid portable filename aborts before writes: $invalidName"
    }
    Assert-Check ((Get-Content -LiteralPath $featurePath -Raw) -ceq $before) 'invalid portable filename cannot partially update an earlier target'
    Assert-Rejected { & $sync -KnowledgeRoot (Join-Path $temporaryRoot 'missing') -FeaturesRoot $features } 'missing requirements root cannot erase generated features'
} finally {
    $resolvedRoot = [IO.Path]::GetFullPath($temporaryRoot)
    $temporaryParent = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
    if (-not $resolvedRoot.StartsWith($temporaryParent, [StringComparison]::OrdinalIgnoreCase) -or (Split-Path $resolvedRoot -Leaf) -notmatch '^ap18-[0-9a-f]{32}$') { throw 'Unsafe temporary cleanup target' }
    if (Test-Path -LiteralPath $resolvedRoot) { Remove-Item -LiteralPath $resolvedRoot -Recurse -Force }
}
Write-Output "Feature-page conversion: $script:checks checks passed."
