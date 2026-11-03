#Requires -Version 7.4
#Requires -Modules powershell-yaml
<#
.SYNOPSIS
    Generates or checks one Approved feature from an acquired Confluence API snapshot (AP-25).
.PARAMETER ScenarioId
    Optional exact Approved scenario IDs for a component projection. Changing an existing
    destination's selection requires a new destination, including switching to or from default.
.PARAMETER ConfigPath
    Project aa.config.yaml containing conventions.knowledge.space and conventions.knowledge.url.
    Defaults to aa.config.yaml in the working directory; no other scopes are merged.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$SnapshotPath,
    [Parameter(Mandatory)][string]$OutputPath,
    [string]$ConfigPath = (Join-Path (Get-Location) 'aa.config.yaml'),
    [switch]$Check,
    [AllowNull()][AllowEmptyCollection()][string[]]$ScenarioId
)
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'ConfluenceFeatureImport.psd1') -Force
Import-Module (Join-Path $PSScriptRoot 'AaFeatures.psd1') -Force
function Get-ProjectionSelection {
    # This documented body comment is public projection metadata, not private parser state.
    [OutputType([string])]
    param([string]$Text)
    $lines = $Text.Replace("`r`n", "`n") -split "`n"
    $line = $lines[2]
    $selectionComments = @($lines | Where-Object { $_.StartsWith('# Selected scenario IDs:', [StringComparison]::Ordinal) })
    $sourceComments = @($lines | Where-Object { $_.StartsWith('# Source Markdown checksum:', [StringComparison]::Ordinal) })
    if (-not $line.StartsWith('# Selected scenario IDs:', [StringComparison]::Ordinal)) {
        if ($selectionComments.Count -or $sourceComments.Count) { throw 'Unexpected projection metadata outside its fixed body position' }
        return ''
    }
    if ($selectionComments.Count -ne 1 -or $sourceComments.Count -ne 1 -or $lines.Count -lt 4 -or $lines[3] -cnotmatch '^# Source Markdown checksum: sha256:[0-9a-f]{64}$') { throw 'Selected projection requires one valid full Markdown checksum in its fixed body position' }
    if ($line -notmatch '^# Selected scenario IDs: (F-\d+-\d+(?: F-\d+-\d+)*)$') { throw 'Invalid existing scenario selection metadata' }
    [string[]]$ids = $Matches[1].Split(' ')
    $unique = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($id in $ids) { if (-not $unique.Add($id)) { throw 'Duplicate existing scenario selection metadata' } }
    [Array]::Sort($ids, [StringComparer]::Ordinal)
    return ($ids -join ' ')
}
$config = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath $ConfigPath -Raw)
if ($config -isnot [Collections.IDictionary] -or $config.version -ne 1 -or $config.scope -cne 'project' -or
    $config.conventions -isnot [Collections.IDictionary] -or $config.conventions.knowledge -isnot [Collections.IDictionary]) {
    throw 'ConfigPath must name a project aa.config.yaml with knowledge conventions'
}
$knowledge = $config.conventions.knowledge
if ($knowledge.space -isnot [string] -or [string]::IsNullOrWhiteSpace($knowledge.space) -or
    $knowledge.url -isnot [string] -or [string]::IsNullOrWhiteSpace($knowledge.url)) {
    throw 'Project configuration requires conventions.knowledge.space and conventions.knowledge.url'
}
$selection = @{}
if ($PSBoundParameters.ContainsKey('ScenarioId')) { $selection.ScenarioId = $ScenarioId }
$result = ConvertFrom-ConfluenceFeatureSnapshot -Json (Get-Content -LiteralPath $SnapshotPath -Raw) -KnowledgeSpace $knowledge.space -KnowledgeUrl $knowledge.url @selection
$path = [IO.Path]::GetFullPath($OutputPath)
if ([IO.Path]::GetExtension($path) -cne '.feature') { throw 'OutputPath must name a generated .feature file' }
$exists = Test-Path -LiteralPath $path
if ($exists -and -not (Test-Path -LiteralPath $path -PathType Leaf)) { throw 'OutputPath is not a file' }
$have = if ($exists) { Get-Content -LiteralPath $path -Raw } else { $null }
if ($exists) {
    if ([string]::IsNullOrWhiteSpace($have) -or (Test-FeatureProvenance -Text $have)) { throw 'Existing feature was not generated or has been edited; change the authoritative source instead' }
    $header = ($have.Replace("`r`n", "`n") -split "`n", 2)[0]
    $pattern = '^# Generated from the knowledge base page ' + [regex]::Escape($result.Source) + ' \(version ([1-9][0-9]*)\)\. Do not edit: change the page, then pull it\.$'
    $oldVersion = 0L
    if ($header -notmatch $pattern -or -not [long]::TryParse($Matches[1], [ref]$oldVersion)) { throw 'Existing feature source identity or version does not match this API source' }
    if ($oldVersion -gt $result.Version) { throw 'Snapshot would downgrade the recorded source version' }
    if ($result.FeatureText -and (Get-ProjectionSelection -Text $have) -cne (Get-ProjectionSelection -Text $result.FeatureText)) { throw 'Existing feature scenario selection differs; use a new destination for a different projection' }
    if ($oldVersion -eq $result.Version -and $result.FeatureText -and $have.Replace("`r`n", "`n") -cne $result.FeatureText) { throw 'Conflicting generated content for the same source version' }
}
if (-not $result.FeatureText) {
    if ($null -ne $have) { throw 'Snapshot has no Approved output; existing feature retained for explicit source reconciliation' }
    Write-Output 'No Approved scenarios; no feature written.'
    return
}
if ($Check) {
    if ($null -eq $have -or $have.Replace("`r`n", "`n") -cne $result.FeatureText) { throw 'Generated feature differs from its source snapshot' }
    Write-Output "Feature matches $($result.Source) version $($result.Version)."
    return
}
if ($null -ne $have -and $have.Replace("`r`n", "`n") -ceq $result.FeatureText) { return }
[IO.Directory]::CreateDirectory((Split-Path $path -Parent)) | Out-Null
$temporary = $path + '.' + [guid]::NewGuid().ToString('N') + '.tmp'
try {
    [IO.File]::WriteAllText($temporary, $result.FeatureText, [Text.UTF8Encoding]::new($false))
    [IO.File]::Move($temporary, $path, $true)
} finally {
    if (Test-Path -LiteralPath $temporary) { Remove-Item -LiteralPath $temporary -Force }
}
Write-Output "Generated from $($result.Source) version $($result.Version)."
