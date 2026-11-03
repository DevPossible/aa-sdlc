#Requires -Version 7.4
<#
.SYNOPSIS
    Proves API snapshot import without network access or live credentials (AP-25).
#>
[CmdletBinding()]
param([Parameter(Mandatory)][string]$ScriptsRoot, [string]$ResultPath, [string]$RunId)
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $ScriptsRoot 'AaFeatures.psd1') -Force
Import-Module (Join-Path $ScriptsRoot 'ConfluenceFeatureImport.psd1') -Force
$knowledgeArguments = @{ KnowledgeSpace = 'AP'; KnowledgeUrl = 'https://devpossible.atlassian.net/wiki/spaces/AP' }
$script:results = [Collections.Generic.List[object]]::new()
if ($ResultPath -and -not $RunId) { throw 'ResultPath requires RunId' }
function Assert-Check([bool]$Condition, [string]$Name) {
    $script:results.Add(@{ name = $Name; outcome = if ($Condition) { 'Passed' } else { 'Failed' } })
    if ($ResultPath) {
        $fullPath = [IO.Path]::GetFullPath($ResultPath)
        New-Item -ItemType Directory -Path (Split-Path $fullPath -Parent) -Force | Out-Null
        @{ schemaVersion = 1; component = 'confluence-feature-import'; runId = $RunId; checks = @($script:results.ToArray()) } | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath ($fullPath + '.tmp')
        Move-Item -LiteralPath ($fullPath + '.tmp') -Destination $fullPath -Force
    }
    if (-not $Condition) { throw "FAIL: $Name" }
    Write-Output "PASS: $Name"
}
function Assert-Rejected([scriptblock]$Action, [string]$Name) {
    $failed = $false
    try { $null = & $Action } catch { $failed = $true }
    Assert-Check $failed $Name
}
$storage = @'
<h1>F-910 API fixture</h1>
<table><thead><tr><th>Feature</th><th>F-910</th></tr></thead><tbody><tr><td>Name</td><td>API fixture</td></tr><tr><td>Tags</td><td>@AP-25</td></tr><tr><td>File</td><td>api-fixture</td></tr></tbody></table>
<p>Reviewed snapshot.</p>
<h2>F-910-01 Approved behavior</h2>
<table><tr><th>Scenario</th><th>F-910-01</th></tr><tr><td>Name</td><td>Approved behavior</td></tr><tr><td>Kind</td><td>Scenario</td></tr><tr><td>Tags</td><td>@AP-25</td></tr><tr><td>Status</td><td>Approved</td></tr></table>
<table><tr><th>Step</th><th>Text</th></tr><tr><td>Given</td><td><p>a &lt;value&gt; with a | pipe</p></td></tr><tr><td>When</td><td>import runs</td></tr><tr><td>Then</td><td>the exact text survives</td></tr></table>
<h2>F-910-02 Draft behavior</h2>
<table><tr><th>Scenario</th><th>F-910-02</th></tr><tr><td>Name</td><td>Draft behavior</td></tr><tr><td>Kind</td><td>Scenario</td></tr><tr><td>Tags</td><td>@AP-25</td></tr><tr><td>Status</td><td>Draft</td></tr></table>
<table><tr><th>Step</th><th>Text</th></tr><tr><td>Given</td><td>draft work</td></tr><tr><td>When</td><td>import runs</td></tr><tr><td>Then</td><td>it stays unapproved</td></tr></table>
'@
function ConvertTo-TestSnapshot([string]$Body = $storage) {
    @{ id = '123456'; type = 'page'; title = 'F-910 API fixture'; space = @{ key = 'AP' }; version = @{ number = 7 }; body = @{ storage = @{ representation = 'storage'; value = $Body } } } | ConvertTo-Json -Depth 10
}
$snapshot = ConvertTo-TestSnapshot
$result = ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json $snapshot
$unordered = '<ul><li>Keep <strong>immutable</strong> packages.</li><li><p>See <a href="https://example.invalid/contract">contract</a>.</p></li></ul>'
$withList = ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('<p>Reviewed snapshot.</p>', $unordered))
Assert-Check ($withList.Markdown.Contains("- Keep immutable packages.`n- See [contract](https://example.invalid/contract).") -and $withList.FeatureText.Contains('  - Keep immutable packages.') -and $withList.FeatureText.Contains('  - See [contract](https://example.invalid/contract).')) 'preamble unordered list preserves text order links and description'
$ordered = '<ol><li>Publish package.</li><li>Evaluate exact bytes.</li></ol>'
$orderedResult = ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('<p>Reviewed snapshot.</p>', $ordered))
Assert-Check ($orderedResult.Markdown.Contains("1. Publish package.`n2. Evaluate exact bytes.") -and $orderedResult.FeatureText.Contains('  2. Evaluate exact bytes.')) 'preamble ordered list preserves numbering and description'
foreach ($list in @('<ul><li>outer<ul><li>nested</li></ul></li></ul>', '<ul><p>lost</p><li>item</li></ul>', '<ul>lost<li>item</li></ul>', '<ul><li><p>first</p><p>second</p></li></ul>', '<ul><li><p>first</p>second</li></ul>', '<ol start="4"><li>numbered</li></ol>', '<ol reversed="reversed"><li>numbered</li></ol>', '<ol><li value="4">numbered</li></ol>', '<ul><li/></ul>', '<ul/>', "<ul><li>first`nsecond</li></ul>")) {
    Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('<p>Reviewed snapshot.</p>', $list)) } ('unsupported preamble list is rejected: ' + $list.Replace("`n", '\n'))
}
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot ($storage + $unordered)) } 'scenario list cannot silently lose requirements'
foreach ($tag in @('OL', 'Ol', 'UL')) {
    $list = '<' + $tag + '><li>first</li></' + $tag + '>'
    Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('<p>Reviewed snapshot.</p>', $list)) } "unsupported list element casing is rejected: $tag"
}
Assert-Check ($result.FeatureText.Contains('@F-910-01') -and -not $result.FeatureText.Contains('@F-910-02')) 'only live snapshot Approved scenarios generate'
Assert-Check ($result.FeatureText.Contains('a <value> with a | pipe')) 'entities and table pipe text survive'
Assert-Check ($result.FeatureText.Contains('https://devpossible.atlassian.net/wiki/spaces/AP/pages/123456 (version 7)')) 'provenance binds exact page and version'
Assert-Check (-not (Test-FeatureProvenance -Text $result.FeatureText)) 'generated checksum is valid'
Assert-Check ((ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json $snapshot).FeatureText -ceq $result.FeatureText) 'snapshot import is deterministic'
$entityStorage = $storage.Replace('the exact text survives', 'A&mdash;B &ndash; &ldquo;quoted&rdquo; &nbsp; &copy;')
$entityText = (ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $entityStorage)).FeatureText
Assert-Check ($entityText.Contains("A$([char]0x2014)B $([char]0x2013) $([char]0x201c)quoted$([char]0x201d) $([char]0xa0) $([char]0xa9)")) 'HTML named entities preserve punctuation and nonbreaking spaces'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('the exact text survives', '&MDASH;')) } 'HTML entity names remain case sensitive'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('the exact text survives', '&notARealEntity;')) } 'unknown named entity is rejected'
$escaped = (ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('the exact text survives', '&amp;mdash; &amp;amp;mdash;'))).FeatureText
Assert-Check ($escaped.Contains('&mdash; &amp;mdash;')) 'escaped named references remain literal'
$xmlEscaped = (ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('the exact text survives', '&lt;strong&gt; &quot;q&quot; &apos;a&apos; &amp;'))).FeatureText
Assert-Check ($xmlEscaped.Contains('<strong> "q" ''a'' &')) 'predefined XML entities do not become markup'
$numeric = (ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('the exact text survives', 'A&#x2014;B &ndash; &#169;'))).FeatureText
Assert-Check ($numeric.Contains("A$([char]0x2014)B $([char]0x2013) $([char]0xa9)")) 'numeric and named references preserve same text'
Assert-Check ((ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('Approved', 'Draft'))).FeatureText -eq '') 'all Draft produces no generated feature'
Assert-Check ((ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('Approved', 'Retired'))).FeatureText -eq '') 'all Retired produces no generated feature'
Assert-Check ((ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('<p>Reviewed snapshot.</p>', '<p>See <a href="https://example.invalid/reference">reference</a>.</p>'))).Markdown.Contains('[reference](https://example.invalid/reference)')) 'prose link target is retained'
$outlineStorage = $storage.Substring(0, $storage.IndexOf('<h2>F-910-02')).Replace('<td>Scenario</td>', '<td>Scenario Outline</td>') + '<h3>Examples</h3><table><tr><th>value</th></tr><tr><td>a|b</td></tr></table>'
$outline = ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $outlineStorage)
Assert-Check ($outline.FeatureText.Contains('Scenario Outline:') -and $outline.FeatureText.Contains('Examples:') -and $outline.FeatureText.Contains('a\|b')) 'outline examples and escaped cells survive storage projection'
$entityOutline = ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $outlineStorage.Replace('a|b', 'a&mdash;b'))
Assert-Check ($entityOutline.FeatureText.Contains("a$([char]0x2014)b")) 'named entities survive outline examples'
$backgroundStorage = $storage.Replace('<h2>F-910-01', '<h2>Background</h2><table><tr><th>Step</th><th>Text</th></tr><tr><td>Given</td><td>shared state</td></tr></table><h2>F-910-01')
Assert-Check ((ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $backgroundStorage)).FeatureText.Contains("Background:`n    Given shared state")) 'Background steps survive storage projection'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json $snapshot.Replace('"AP"', '"OTHER"') } 'other project space is rejected'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json $snapshot.Replace('"123456"', '"../123456"') } 'invalid source page identity is rejected'
foreach ($version in @('true', '"7"', '7.0', '0', '-1')) {
    Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json ([regex]::Replace($snapshot, '"number":\s*7', '"number": ' + $version)) } "invalid source version is rejected: $version"
}
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json '{not json' } 'malformed snapshot JSON is rejected'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json ('[' + $snapshot + ']') } 'top-level snapshot array is rejected'
foreach ($field in @('AP', 'page', 'storage')) {
    $malformed = $snapshot | ConvertFrom-Json -AsHashtable
    switch ($field) {
        'AP' { $malformed.space.key = @('AP') }
        'page' { $malformed.type = @('page') }
        'storage' { $malformed.body.storage.representation = @('storage') }
    }
    Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json ($malformed | ConvertTo-Json -Depth 10) } "array-valued scalar metadata is rejected: $field"
}
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json $snapshot.Replace('"storage"', '"view"') } 'wrong body representation is rejected'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot '<p>not requirements</p>') } 'no feature metadata is rejected'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot ($storage + '<ac:structured-macro ac:name="include"/>')) } 'dynamic macro cannot disappear during import'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('</tbody>', '<ac:structured-macro ac:name="include"/></tbody>')) } 'dynamic macro inside a table section cannot disappear'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot ($storage + '<img src="source.png"/>')) } 'image evidence cannot disappear during import'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('<td>draft work</td>', '<td><p>first condition</p><p>second condition</p></td>')) } 'multiple cell paragraphs cannot merge conditions'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('<td>draft work</td>', '<td><span><p>first</p><p>second</p></span></td>')) } 'nested paragraphs cannot merge conditions'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('<td>draft work</td>', '<td><p>first</p><span>second</span></td>')) } 'paragraph siblings cannot merge conditions'
foreach ($href in @('javascript:alert(1)', 'data:text/plain,test', 'https://example.invalid/a(b)')) {
    Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('Reviewed snapshot.', ('See <a href="' + $href + '">evidence</a>.'))) } "unsupported Markdown link target is rejected: $href"
}
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('<th>Feature</th>', '<th colspan="2">Feature</th>')) } 'merged table cells are rejected'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot $storage.Replace('<td>draft work</td>', '<td>first<br/>second</td>')) } 'multiline steps require explicit supported representation'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot '<!DOCTYPE x [<!ENTITY e SYSTEM "file:///private">]><p>&e;</p>') } 'DTD and external entities are rejected'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot ($storage + '<broken>')) } 'malformed storage XML is rejected'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot ($storage + '<h3>Examples</h3><table><tr><th>value</th></tr><tr><td>lost</td></tr></table>')) } 'unconsumed tables are rejected after projection'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot ($storage + '<p>Only the Owner may approve emergency actions.</p>')) } 'scenario narrative cannot silently lose a requirement'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot ($storage + '<h3>Security condition</h3>')) } 'unsupported scenario heading cannot silently lose a requirement'
Assert-Check ((ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot ($storage + '<p/>'))).FeatureText -ceq $result.FeatureText) 'empty editor paragraphs do not change generated conditions'
$selectionStorage = $storage.Replace('<td>Status</td><td>Draft</td>', '<td>Status</td><td>Approved</td>').Replace('<td>Tags</td><td>@AP-25</td>', '<td>Tags</td><td>@AP-25 @component</td>')
$selectionSnapshot = ConvertTo-TestSnapshot $selectionStorage
$selection = ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json $selectionSnapshot -ScenarioId @('F-910-01')
Assert-Check ($selection.FeatureText.Contains('@F-910-01') -and -not $selection.FeatureText.Contains('@F-910-02') -and $selection.FeatureText.Contains('@component')) 'importer selects exact Approved component scenarios'
Assert-Check ($selection.Markdown -ceq (ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json $selectionSnapshot).Markdown) 'selection preserves the full validated Markdown projection'
Assert-Check ($selection.FeatureText -ceq (ConvertFrom-FeaturePage -Markdown $selection.Markdown -Source $selection.Source -Version $selection.Version -ScenarioId @('F-910-01'))) 'importer delegates selection through the public converter'
Assert-Check (-not (Test-FeatureProvenance -Text $selection.FeatureText) -and $selection.FeatureText.Contains('# Selected scenario IDs: F-910-01')) 'importer binds selection into checksummed output'
Assert-Check (($selection.FeatureText -split "`n")[3] -ceq "# Source Markdown checksum: $(Get-FeatureChecksum -Body $selection.Markdown)") 'importer source checksum binds the full Markdown projection'
Assert-Check ((ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json $snapshot).FeatureText -ceq $result.FeatureText -and [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($result.FeatureText))) -ceq 'C251F184D93969899C8063DCBC06E2E484B17FE88E1161370C3833287397DC1A') 'omitted importer selection preserves legacy default bytes'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json $selectionSnapshot -ScenarioId $null } 'importer rejects explicit null selection'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json $selectionSnapshot -ScenarioId @() } 'importer rejects empty selection'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json $selectionSnapshot -ScenarioId @('F-910-01', 'F-910-01') } 'importer rejects duplicate selection'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json $selectionSnapshot -ScenarioId @('f-910-01') } 'importer rejects case mismatched selection'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json $snapshot -ScenarioId @('F-910-02') } 'importer cannot select Draft scenarios'
Assert-Rejected { ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json (ConvertTo-TestSnapshot ($selectionStorage + '<p>lost requirement</p>')) -ScenarioId @('F-910-01') } 'selection cannot hide unsupported unselected storage content'
$temporaryRoot = Join-Path ([IO.Path]::GetTempPath()) ('ap25-' + [guid]::NewGuid().ToString('N'))
$configPath = Join-Path $temporaryRoot 'aa.config.yaml'
try {
    [IO.Directory]::CreateDirectory($temporaryRoot) | Out-Null
    [IO.File]::WriteAllText($configPath, "version: 1`nscope: project`nconventions:`n  knowledge:`n    space: AP`n    url: https://devpossible.atlassian.net/wiki/spaces/AP`n")
    $snapshotPath = Join-Path $temporaryRoot 'source[one].json'
    $outputPath = Join-Path $temporaryRoot 'case[one].feature'
    $entry = Join-Path $ScriptsRoot 'Import-ConfluenceFeatureSnapshot.ps1'
    $selectedPath = Join-Path $temporaryRoot 'selected.feature'
    Set-Content -LiteralPath $snapshotPath -Value $selectionSnapshot
    $null = & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $selectedPath -ScenarioId @('F-910-01')
    Assert-Check ((Get-Content -LiteralPath $selectedPath -Raw) -ceq $selection.FeatureText) 'CLI writes exact selected output'
    $null = & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $selectedPath -ScenarioId @('F-910-01') -Check
    Assert-Check ((Get-Content -LiteralPath $selectedPath -Raw) -ceq $selection.FeatureText) 'CLI check accepts the identical selected projection'
    $changedUnselectedSnapshot = ConvertTo-TestSnapshot $selectionStorage.Replace('<td>draft work</td>', '<td>changed unselected work</td>')
    Set-Content -LiteralPath $snapshotPath -Value $changedUnselectedSnapshot
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $selectedPath -ScenarioId @('F-910-01') } 'CLI rejects same version changes to unselected source rows'
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $selectedPath -ScenarioId @('F-910-01') -Check } 'CLI check rejects same version changes to unselected source rows'
    Assert-Check ((Get-Content -LiteralPath $selectedPath -Raw) -ceq $selection.FeatureText) 'same version unselected source conflict preserves destination bytes'
    Set-Content -LiteralPath $snapshotPath -Value ([regex]::Replace($changedUnselectedSnapshot, '"number":\s*7', '"number": 8'))
    $sourceBindingPath = Join-Path $temporaryRoot 'source-binding.feature'
    [IO.File]::WriteAllText($sourceBindingPath, $selection.FeatureText)
    $null = & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $sourceBindingPath -ScenarioId @('F-910-01')
    $updatedBinding = [IO.File]::ReadAllText($sourceBindingPath)
    $changedUnselectedProjection = ConvertFrom-ConfluenceFeatureSnapshot @knowledgeArguments -Json $changedUnselectedSnapshot -ScenarioId @('F-910-01')
    Assert-Check (($updatedBinding -split "`n")[3] -ceq "# Source Markdown checksum: $(Get-FeatureChecksum -Body $changedUnselectedProjection.Markdown)" -and ($updatedBinding -split "`n")[3] -cne ($selection.FeatureText -split "`n")[3] -and ($updatedBinding -split "`n", 5)[4] -ceq ($selection.FeatureText -split "`n", 5)[4]) 'newer unselected source changes update the full Markdown binding'
    Set-Content -LiteralPath $snapshotPath -Value $selectionSnapshot
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $selectedPath -ScenarioId @('F-910-02') } 'CLI rejects same version selection changes'
    Set-Content -LiteralPath $snapshotPath -Value ([regex]::Replace($selectionSnapshot, '"number":\s*7', '"number": 8'))
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $selectedPath -ScenarioId @('F-910-02') } 'CLI rejects newer version selection changes'
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $selectedPath } 'CLI rejects silently removing selection'
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $selectedPath -ScenarioId @('F-910-02') -Check } 'CLI check rejects a different selection'
    Assert-Check ((Get-Content -LiteralPath $selectedPath -Raw) -ceq $selection.FeatureText) 'selection conflicts retain existing destination bytes'
    $null = & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $selectedPath -ScenarioId @('F-910-01')
    Assert-Check ((Get-Content -LiteralPath $selectedPath -Raw).Contains('(version 8)')) 'CLI advances source version for an unchanged selection'
    $selectedBefore = [IO.File]::ReadAllBytes($selectedPath)
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $selectedPath -ScenarioId @() } 'CLI rejects explicitly empty selection'
    Assert-Check ([Convert]::ToBase64String([IO.File]::ReadAllBytes($selectedPath)) -ceq [Convert]::ToBase64String($selectedBefore)) 'invalid selection retains destination bytes'
    Set-Content -LiteralPath $snapshotPath -Value ([regex]::Replace((ConvertTo-TestSnapshot $selectionStorage.Replace('the exact text survives', 'conflicting selected condition')), '"number":\s*7', '"number": 8'))
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $selectedPath -ScenarioId @('F-910-01') } 'CLI rejects conflicting selected content at the same version'
    Assert-Check ([Convert]::ToBase64String([IO.File]::ReadAllBytes($selectedPath)) -ceq [Convert]::ToBase64String($selectedBefore)) 'same version selected conflict preserves destination bytes'
    Set-Content -LiteralPath $snapshotPath -Value $selectionSnapshot
    $bothPath = Join-Path $temporaryRoot 'both.feature'
    $null = & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $bothPath -ScenarioId @('F-910-01', 'F-910-02')
    $null = & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $bothPath -ScenarioId @('F-910-02', 'F-910-01') -Check
    Assert-Check ((Get-Content -LiteralPath $bothPath -Raw).Contains('# Selected scenario IDs: F-910-01 F-910-02')) 'CLI treats reordered caller IDs as the same selection'
    $firstStart = $selectionStorage.IndexOf('<h2>F-910-01')
    $secondStart = $selectionStorage.IndexOf('<h2>F-910-02')
    $reorderedStorage = $selectionStorage.Substring(0, $firstStart) + $selectionStorage.Substring($secondStart) + $selectionStorage.Substring($firstStart, $secondStart - $firstStart)
    Set-Content -LiteralPath $snapshotPath -Value ([regex]::Replace((ConvertTo-TestSnapshot $reorderedStorage), '"number":\s*7', '"number": 8'))
    $null = & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $bothPath -ScenarioId @('F-910-01', 'F-910-02')
    Assert-Check ((Get-Content -LiteralPath $bothPath -Raw).Contains('# Selected scenario IDs: F-910-02 F-910-01')) 'CLI preserves newer source order for unchanged selection membership'
    $invalidNewPath = Join-Path $temporaryRoot 'invalid-new.feature'
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $invalidNewPath -ScenarioId @('F-910-99') } 'CLI rejects an unknown selection before creating a destination'
    Assert-Check (-not (Test-Path -LiteralPath $invalidNewPath)) 'invalid new projection leaves no destination'
    $caseSnapshot = ConvertTo-TestSnapshot $selectionStorage.Replace('F-910-01', 'f-910-01')
    Set-Content -LiteralPath $snapshotPath -Value $caseSnapshot
    $casePath = Join-Path $temporaryRoot 'exact-source-case.feature'
    $null = & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $casePath -ScenarioId @('f-910-01')
    $null = & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $casePath -ScenarioId @('f-910-01') -Check
    Assert-Check ((Get-Content -LiteralPath $casePath -Raw).Contains('# Selected scenario IDs: f-910-01')) 'CLI preserves exact source ID casing already accepted by the parser'
    Set-Content -LiteralPath $snapshotPath -Value ([regex]::Replace($selectionSnapshot, '"number":\s*7', '"number": 8'))
    $invalidMetadataPath = Join-Path $temporaryRoot 'invalid-metadata.feature'
    $invalidBody = ($selection.FeatureText -split "`n", 3)[2].Replace('# Selected scenario IDs: F-910-01', '# Selected scenario IDs: F-910-01 F-910-01')
    $invalidMetadata = ($selection.FeatureText -split "`n", 2)[0] + "`n# Checksum: $(Get-FeatureChecksum -Body $invalidBody)`n" + $invalidBody
    [IO.File]::WriteAllText($invalidMetadataPath, $invalidMetadata)
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $invalidMetadataPath -ScenarioId @('F-910-01') } 'CLI rejects duplicate existing projection metadata despite a valid checksum'
    $malformedMetadata = $invalidMetadata.Replace('# Selected scenario IDs: F-910-01 F-910-01', '# Selected scenario IDs: ')
    $malformedBody = ($malformedMetadata -split "`n", 3)[2]
    $malformedMetadata = ($malformedMetadata -split "`n", 2)[0] + "`n# Checksum: $(Get-FeatureChecksum -Body $malformedBody)`n" + $malformedBody
    [IO.File]::WriteAllText($invalidMetadataPath, $malformedMetadata)
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $invalidMetadataPath -ScenarioId @('F-910-01') } 'CLI rejects malformed existing projection metadata despite a valid checksum'
    Assert-Check ([IO.File]::ReadAllText($invalidMetadataPath) -ceq $malformedMetadata) 'rejected projection metadata retains the destination bytes'
    $sourceComment = "# Source Markdown checksum: $(Get-FeatureChecksum -Body $selection.Markdown)"
    $missingSourceBody = ($selection.FeatureText -split "`n", 3)[2].Replace($sourceComment + "`n", '')
    $missingSource = ($selection.FeatureText -split "`n", 2)[0] + "`n# Checksum: $(Get-FeatureChecksum -Body $missingSourceBody)`n" + $missingSourceBody
    [IO.File]::WriteAllText($invalidMetadataPath, $missingSource)
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $invalidMetadataPath -ScenarioId @('F-910-01') } 'CLI rejects selected metadata missing the full Markdown checksum'
    $malformedSourceBody = ($selection.FeatureText -split "`n", 3)[2].Replace($sourceComment, '# Source Markdown checksum: sha256:invalid')
    $malformedSource = ($selection.FeatureText -split "`n", 2)[0] + "`n# Checksum: $(Get-FeatureChecksum -Body $malformedSourceBody)`n" + $malformedSourceBody
    [IO.File]::WriteAllText($invalidMetadataPath, $malformedSource)
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $invalidMetadataPath -ScenarioId @('F-910-01') } 'CLI rejects malformed full Markdown checksum metadata'
    $duplicateSourceBody = ($selection.FeatureText -split "`n", 3)[2].Replace($sourceComment, $sourceComment + "`n" + $sourceComment)
    $duplicateSource = ($selection.FeatureText -split "`n", 2)[0] + "`n# Checksum: $(Get-FeatureChecksum -Body $duplicateSourceBody)`n" + $duplicateSourceBody
    [IO.File]::WriteAllText($invalidMetadataPath, $duplicateSource)
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $invalidMetadataPath -ScenarioId @('F-910-01') } 'CLI rejects duplicate full Markdown checksum comments'
    $duplicateSelectionBody = ($selection.FeatureText -split "`n", 3)[2].Replace('# Selected scenario IDs: F-910-01', "# Selected scenario IDs: F-910-01`n# Selected scenario IDs: F-910-01")
    $duplicateSelection = ($selection.FeatureText -split "`n", 2)[0] + "`n# Checksum: $(Get-FeatureChecksum -Body $duplicateSelectionBody)`n" + $duplicateSelectionBody
    [IO.File]::WriteAllText($invalidMetadataPath, $duplicateSelection)
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $invalidMetadataPath -ScenarioId @('F-910-01') } 'CLI rejects duplicate selected scenario comment lines'
    Assert-Check ([IO.File]::ReadAllText($invalidMetadataPath) -ceq $duplicateSelection) 'structured projection metadata rejection preserves destination bytes'
    Set-Content -LiteralPath $snapshotPath -Value $snapshot
    $null = & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $outputPath
    Assert-Check ((Get-Content -LiteralPath $outputPath -Raw) -ceq $result.FeatureText) 'CLI uses literal paths and writes exact generated bytes'
    Set-Content -LiteralPath $snapshotPath -Value ([regex]::Replace($selectionSnapshot, '"number":\s*7', '"number": 8'))
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $outputPath -ScenarioId @('F-910-01') } 'CLI rejects silently adding selection to default output'
    Assert-Check ((Get-Content -LiteralPath $outputPath -Raw) -ceq $result.FeatureText) 'adding selection preserves the default destination'
    Set-Content -LiteralPath $snapshotPath -Value $snapshot
    Set-Content -LiteralPath $snapshotPath -Value (ConvertTo-TestSnapshot ($storage + $unordered))
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $outputPath } 'CLI rejects scenario lists before writing'
    Assert-Check ((Get-Content -LiteralPath $outputPath -Raw) -ceq $result.FeatureText) 'rejected scenario list leaves destination unchanged'
    Set-Content -LiteralPath $snapshotPath -Value $snapshot
    $null = & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $outputPath -Check
    Assert-Check (-not (Test-FeatureProvenance -Text (Get-Content -LiteralPath $outputPath -Raw))) 'CLI check preserves valid provenance'
    Set-Content -LiteralPath $snapshotPath -Value ([regex]::Replace($snapshot, '"number":\s*7', '"number": 8'))
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $outputPath -Check } 'CLI check rejects a stale generated version'
    $null = & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $outputPath
    Assert-Check ((Get-Content -LiteralPath $outputPath -Raw).Contains('(version 8)')) 'CLI updates generated output from reviewed newer snapshot'
    Set-Content -LiteralPath $snapshotPath -Value $snapshot
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $outputPath } 'CLI rejects source version downgrade'
    Set-Content -LiteralPath $outputPath -Value $result.FeatureText.Replace('/123456 ', '/654321 ') -NoNewline
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $outputPath } 'CLI rejects replacing another page source'
    Set-Content -LiteralPath $outputPath -Value '' -NoNewline
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $outputPath } 'CLI preserves an existing zero-byte nongenerated file'
    Assert-Check ((Get-Item -LiteralPath $outputPath).Length -eq 0) 'rejected zero-byte destination remains unchanged'
    Set-Content -LiteralPath $outputPath -Value $result.FeatureText -NoNewline
    Set-Content -LiteralPath $snapshotPath -Value (ConvertTo-TestSnapshot $storage.Replace('exact text survives', 'conflicting text'))
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $outputPath } 'CLI rejects conflicting content at the same source version'
    Set-Content -LiteralPath $snapshotPath -Value $snapshot
    $tampered = (Get-Content -LiteralPath $outputPath -Raw).Replace('exact text survives', 'hand edited')
    Set-Content -LiteralPath $outputPath -Value $tampered -NoNewline
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $outputPath } 'CLI refuses to overwrite a hand-edited generated feature'
    Assert-Check ((Get-Content -LiteralPath $outputPath -Raw) -ceq $tampered) 'CLI preserves rejected hand-edited bytes'
    Set-Content -LiteralPath $outputPath -Value $result.FeatureText -NoNewline
    Set-Content -LiteralPath $snapshotPath -Value ([regex]::Replace((ConvertTo-TestSnapshot $storage.Replace('Approved', 'Draft')), '"number":\s*7', '"number": 9'))
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $outputPath } 'CLI does not silently delete output when approvals disappear'
    Assert-Check ((Get-Content -LiteralPath $outputPath -Raw) -ceq $result.FeatureText) 'approval-free import leaves existing output intact'
    Assert-Rejected { & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath (Join-Path $temporaryRoot 'wrong.txt') } 'CLI requires an explicit feature destination'
    $emptyOutput = Join-Path $temporaryRoot 'empty.feature'
    $null = & $entry -ConfigPath $configPath -SnapshotPath $snapshotPath -OutputPath $emptyOutput
    Assert-Check (-not (Test-Path -LiteralPath $emptyOutput)) 'CLI never creates an empty acceptance file'
} finally {
    $resolvedRoot = [IO.Path]::GetFullPath($temporaryRoot)
    $temporaryParent = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
    if (-not $resolvedRoot.StartsWith($temporaryParent, [StringComparison]::OrdinalIgnoreCase) -or (Split-Path $resolvedRoot -Leaf) -notmatch '^ap25-[0-9a-f]{32}$') { throw 'Unsafe temporary cleanup target' }
    if (Test-Path -LiteralPath $resolvedRoot) { Remove-Item -LiteralPath $resolvedRoot -Recurse -Force }
}
Write-Output "Confluence import: $($script:results.Count) checks passed."
