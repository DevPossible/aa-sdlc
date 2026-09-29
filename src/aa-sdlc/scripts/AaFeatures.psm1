#Requires -Version 7.0
<#
.SYNOPSIS
    Converts between Gherkin feature files and knowledge base feature pages (decision record 0019).
.DESCRIPTION
    The knowledge base is the source of truth for requirements. Each feature is one page of
    structured tables that a business analyst can read and edit; the repository's feature files
    are generated from those pages and carry a provenance header whose checksum proves they were
    not edited by hand. The page format is specified in docs/formats.md, "Feature page".

    ConvertTo-FeaturePage    feature file text -> page markdown (seeding a knowledge base, or
                             proposing a repository change back to the page)
    ConvertFrom-FeaturePage  page markdown -> feature file text with its provenance header
    Test-FeatureProvenance   a feature file's header and checksum still match its content

    Supported Gherkin: tags, Feature with description, Background, Scenario, Scenario Outline
    with Examples. Doc strings, step data tables, and Rule are refused with a clear message.
#>

$ErrorActionPreference = 'Stop'

$script:StepKeywords = 'Given', 'When', 'Then', 'And', 'But', '*'
$script:Statuses = 'Draft', 'Approved', 'Retired'

function Split-Tag([string]$line) {
    @($line.Trim() -split '\s+' | Where-Object { $_ })
}

function Get-IdAndTag([string[]]$tags, [string]$pattern) {
    $id = @($tags | Where-Object { $_ -match $pattern } | Select-Object -Last 1)
    $rest = @($tags | Where-Object { $_ -notmatch $pattern })
    [pscustomobject]@{ Id = if ($id) { $id[0].TrimStart('@') } else { '' }; Tags = $rest }
}

function ConvertTo-Cell([string]$text) { $text.Replace('|', '\|') }

function Split-Row([string]$line) {
    # split a markdown table row on pipes not escaped with a backslash
    $body = $line.Trim()
    if ($body.StartsWith('|')) { $body = $body.Substring(1) }
    if ($body.EndsWith('|') -and -not $body.EndsWith('\|')) { $body = $body.Substring(0, $body.Length - 1) }
    @([regex]::Split($body, '(?<!\\)\|') | ForEach-Object { $_.Trim().Replace('\|', '|') })
}

function Read-FeatureText {
    # Parses feature file text into a feature object.
    param([Parameter(Mandatory)][string]$Text)
    $lines = $Text -replace "`r`n", "`n" -split "`n"
    $feature = [ordered]@{ Id = ''; Name = ''; Tags = @(); Description = [System.Collections.Generic.List[string]]::new(); Background = @(); Scenarios = [System.Collections.Generic.List[object]]::new() }
    $pendingTags = @()
    $mode = 'start'
    $current = $null
    $steps = $null
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $raw = $lines[$i]
        $line = $raw.Trim()
        if ($line -eq '' -and $mode -ne 'description') { continue }
        if ($line.StartsWith('#')) { continue }
        if ($line -match '^("""|```)') { throw "line $($i + 1): doc strings are not supported in a feature page" }
        if ($line -match '^Rule:') { throw "line $($i + 1): Rule is not supported in a feature page" }
        if ($line.StartsWith('@')) {
            if ($mode -eq 'description') { $mode = 'body' }
            $pendingTags += Split-Tag $line
            continue
        }
        if ($line -match '^Feature:\s*(.*)$') {
            $split = Get-IdAndTag $pendingTags '^@F-\d+$'
            $feature.Id = $split.Id; $feature.Tags = $split.Tags; $feature.Name = $Matches[1].Trim()
            $pendingTags = @(); $mode = 'description'
            continue
        }
        if ($line -eq 'Background:') {
            $mode = 'body'; $steps = [System.Collections.Generic.List[object]]::new(); $feature.Background = $steps
            continue
        }
        if ($line -match '^(Scenario Outline|Scenario Template|Scenario|Example):\s*(.*)$') {
            $mode = 'body'
            $kind = if ($Matches[1] -in 'Scenario Outline', 'Scenario Template') { 'Scenario Outline' } else { 'Scenario' }
            $split = Get-IdAndTag $pendingTags '^@F-\d+-\d+$'
            $steps = [System.Collections.Generic.List[object]]::new()
            $current = [ordered]@{ Id = $split.Id; Name = $Matches[2].Trim(); Kind = $kind; Tags = $split.Tags; Status = 'Approved'; Steps = $steps; Examples = $null }
            $feature.Scenarios.Add($current)
            $pendingTags = @()
            continue
        }
        if ($line -eq 'Examples:') {
            if (-not $current -or $current.Kind -ne 'Scenario Outline') { throw "line $($i + 1): Examples outside a Scenario Outline" }
            $current.Examples = [System.Collections.Generic.List[object]]::new()
            $mode = 'examples'
            continue
        }
        if ($line.StartsWith('|')) {
            if ($mode -ne 'examples') { throw "line $($i + 1): step data tables are not supported in a feature page" }
            # @() keeps a one-cell row an array; the pipeline would unwrap it to a string
            $current.Examples.Add(@(Split-Row $line))
            continue
        }
        if ($mode -eq 'description') {
            $feature.Description.Add(($raw -replace '^  ', '').TrimEnd())
            continue
        }
        $keyword = ($line -split '\s+', 2)[0]
        if ($keyword -in $script:StepKeywords -and $null -ne $steps) {
            $steps.Add([pscustomobject]@{ Keyword = $keyword; Text = ($line -split '\s+', 2)[1] })
            continue
        }
        throw "line $($i + 1): not understood: $line"
    }
    while ($feature.Description.Count -gt 0 -and $feature.Description[$feature.Description.Count - 1] -eq '') { $feature.Description.RemoveAt($feature.Description.Count - 1) }
    [pscustomobject]$feature
}

function Write-Table([System.Text.StringBuilder]$sb, [string[]]$header, [object[]]$rows) {
    [void]$sb.AppendLine('| ' + (($header | ForEach-Object { ConvertTo-Cell $_ }) -join ' | ') + ' |')
    [void]$sb.AppendLine('| ' + (($header | ForEach-Object { '---' }) -join ' | ') + ' |')
    foreach ($r in $rows) { [void]$sb.AppendLine('| ' + ((@($r) | ForEach-Object { ConvertTo-Cell "$_" }) -join ' | ') + ' |') }
}

function ConvertTo-FeaturePage {
    <#
    .SYNOPSIS
        Converts feature file text to a knowledge base feature page in markdown.
    .PARAMETER Text
        The feature file's text. A provenance header, if present, is ignored.
    .PARAMETER File
        The feature file's base name, recorded so the page regenerates the same file.
    .EXAMPLE
        ConvertTo-FeaturePage -Text (Get-Content features/cli/init.feature -Raw) -File init
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][string]$File
    )
    $f = Read-FeatureText -Text $Text
    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.AppendLine("# $($f.Id) $($f.Name)".Trim())
    [void]$sb.AppendLine()
    Write-Table $sb @('Feature', $f.Id) @(@('Name', $f.Name), @('Tags', ($f.Tags -join ' ')), @('File', $File))
    if ($f.Description.Count -gt 0) {
        [void]$sb.AppendLine()
        foreach ($d in $f.Description) { [void]$sb.AppendLine($d) }
    }
    if (@($f.Background).Count -gt 0) {
        [void]$sb.AppendLine()
        [void]$sb.AppendLine('## Background')
        [void]$sb.AppendLine()
        Write-Table $sb @('Step', 'Text') @($f.Background | ForEach-Object { , @($_.Keyword, $_.Text) })
    }
    foreach ($s in $f.Scenarios) {
        [void]$sb.AppendLine()
        [void]$sb.AppendLine("## $($s.Id) $($s.Name)".Trim())
        [void]$sb.AppendLine()
        Write-Table $sb @('Scenario', $s.Id) @(@('Name', $s.Name), @('Kind', $s.Kind), @('Tags', ($s.Tags -join ' ')), @('Status', $s.Status))
        [void]$sb.AppendLine()
        Write-Table $sb @('Step', 'Text') @($s.Steps | ForEach-Object { , @($_.Keyword, $_.Text) })
        if ($s.Examples) {
            [void]$sb.AppendLine()
            [void]$sb.AppendLine('### Examples')
            [void]$sb.AppendLine()
            Write-Table $sb $s.Examples[0] @($s.Examples | Select-Object -Skip 1 | ForEach-Object { , $_ })
        }
    }
    $sb.ToString() -replace "`r`n", "`n"
}

function Read-Table([string[]]$lines, [int]$start) {
    # Returns the table beginning at or after $start (skipping blank lines) and the index after it.
    $i = $start
    while ($i -lt $lines.Count -and $lines[$i].Trim() -eq '') { $i++ }
    if ($i -ge $lines.Count -or -not $lines[$i].Trim().StartsWith('|')) { return $null }
    # @() keeps a one-cell row an array; the pipeline would unwrap it to a string
    $header = @(Split-Row $lines[$i])
    $i += 2 # header and separator
    $rows = [System.Collections.Generic.List[object]]::new()
    while ($i -lt $lines.Count -and $lines[$i].Trim().StartsWith('|')) { $rows.Add(@(Split-Row $lines[$i])); $i++ }
    [pscustomobject]@{ Header = $header; Rows = $rows; Next = $i }
}

function Get-Field($table, [string]$name) {
    $row = @($table.Rows | Where-Object { $_[0] -eq $name } | Select-Object -First 1)
    if ($row) { $row[0][1] } else { '' }
}

function Read-FeaturePage {
    # Parses page markdown into the same feature object Read-FeatureText produces.
    param([Parameter(Mandatory)][string]$Markdown)
    $lines = $Markdown -replace "`r`n", "`n" -split "`n"
    $i = 0
    # @() so [0] is the first cell of a one-cell row, not its first character
    while ($i -lt $lines.Count -and -not ($lines[$i].Trim().StartsWith('|') -and @(Split-Row $lines[$i])[0] -eq 'Feature')) { $i++ }
    if ($i -ge $lines.Count) { throw 'not a feature page: no table whose first header is "Feature"' }
    $t = Read-Table $lines $i
    $feature = [ordered]@{ Id = $t.Header[1]; Name = (Get-Field $t 'Name'); Tags = @(Split-Tag (Get-Field $t 'Tags')); File = (Get-Field $t 'File'); Description = [System.Collections.Generic.List[string]]::new(); Background = @(); Scenarios = [System.Collections.Generic.List[object]]::new() }
    $i = $t.Next
    while ($i -lt $lines.Count -and -not $lines[$i].StartsWith('## ')) { $feature.Description.Add($lines[$i].TrimEnd()); $i++ }
    while ($feature.Description.Count -gt 0 -and $feature.Description[0] -eq '') { $feature.Description.RemoveAt(0) }
    while ($feature.Description.Count -gt 0 -and $feature.Description[$feature.Description.Count - 1] -eq '') { $feature.Description.RemoveAt($feature.Description.Count - 1) }
    while ($i -lt $lines.Count) {
        $line = $lines[$i]
        if (-not $line.StartsWith('## ')) { $i++; continue }
        $t = Read-Table $lines ($i + 1)
        if (-not $t) { throw "section '$line' has no table" }
        if ($t.Header[0] -eq 'Step') {
            $feature.Background = @($t.Rows | ForEach-Object { [pscustomobject]@{ Keyword = $_[0]; Text = $_[1] } })
            $i = $t.Next
            continue
        }
        if ($t.Header[0] -ne 'Scenario') { throw "section '$line' does not start with a Scenario or Step table" }
        $status = Get-Field $t 'Status'
        if ($status -notin $script:Statuses) { throw "scenario $($t.Header[1]): status '$status' is not one of $($script:Statuses -join ', ')" }
        $scenario = [ordered]@{ Id = $t.Header[1]; Name = (Get-Field $t 'Name'); Kind = (Get-Field $t 'Kind'); Tags = @(Split-Tag (Get-Field $t 'Tags')); Status = $status; Steps = @(); Examples = $null }
        if (-not $scenario.Kind) { $scenario.Kind = 'Scenario' }
        $steps = Read-Table $lines $t.Next
        if (-not $steps -or $steps.Header[0] -ne 'Step') { throw "scenario $($scenario.Id) has no Step table" }
        $scenario.Steps = @($steps.Rows | ForEach-Object { [pscustomobject]@{ Keyword = $_[0]; Text = $_[1] } })
        $i = $steps.Next
        while ($i -lt $lines.Count -and $lines[$i].Trim() -eq '') { $i++ }
        if ($i -lt $lines.Count -and $lines[$i].Trim() -eq '### Examples') {
            $ex = Read-Table $lines ($i + 1)
            $scenario.Examples = [System.Collections.Generic.List[object]]::new()
            $scenario.Examples.Add($ex.Header)
            foreach ($r in $ex.Rows) { $scenario.Examples.Add($r) }
            $i = $ex.Next
        }
        $feature.Scenarios.Add([pscustomobject]$scenario)
    }
    [pscustomobject]$feature
}

function Get-FeatureChecksum {
    <#
    .SYNOPSIS
        The sha256 of a feature file's content below its provenance header, with line endings normalised.
    #>
    [CmdletBinding()]
    param([Parameter(Mandatory)][AllowEmptyString()][string]$Body)
    $bytes = [System.Text.Encoding]::UTF8.GetBytes(($Body -replace "`r`n", "`n"))
    'sha256:' + [Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData($bytes)).ToLowerInvariant()
}

function ConvertFrom-FeaturePage {
    <#
    .SYNOPSIS
        Converts a knowledge base feature page to feature file text, with a provenance header.
    .DESCRIPTION
        Only Approved scenarios are written; Draft and Retired ones stay on the page. The header
        names the page and its version and carries a checksum of the body, so a hand edit to the
        feature file is caught without reaching the knowledge base (Test-FeatureProvenance).
        Returns an empty string when the page has no Approved scenario.
    .PARAMETER Markdown
        The page's content in markdown.
    .PARAMETER Source
        Where the page lives: its path in the documents folder, or its knowledge base address.
    .PARAMETER Version
        The page's version in the knowledge base, when it has one.
    .EXAMPLE
        ConvertFrom-FeaturePage -Markdown (Get-Content page.md -Raw) -Source 'Requirements/cli/init'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Markdown,
        [Parameter(Mandatory)][string]$Source,
        [Parameter()][string]$Version
    )
    $f = Read-FeaturePage -Markdown $Markdown
    $approved = @($f.Scenarios | Where-Object Status -eq 'Approved')
    if ($approved.Count -eq 0) { return '' }
    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.AppendLine((@($f.Tags) + @("@$($f.Id)") | Where-Object { $_ -and $_ -ne '@' }) -join ' ')
    [void]$sb.AppendLine("Feature: $($f.Name)")
    foreach ($d in $f.Description) { [void]$sb.AppendLine($(if ($d) { "  $d" } else { '' })) }
    if (@($f.Background).Count -gt 0) {
        [void]$sb.AppendLine()
        [void]$sb.AppendLine('  Background:')
        foreach ($st in $f.Background) { [void]$sb.AppendLine("    $($st.Keyword) $($st.Text)") }
    }
    foreach ($s in $approved) {
        [void]$sb.AppendLine()
        [void]$sb.AppendLine('  ' + ((@($s.Tags) + @("@$($s.Id)") | Where-Object { $_ -and $_ -ne '@' }) -join ' '))
        [void]$sb.AppendLine("  $($s.Kind): $($s.Name)")
        foreach ($st in $s.Steps) { [void]$sb.AppendLine("    $($st.Keyword) $($st.Text)") }
        if ($s.Examples) {
            $widths = for ($c = 0; $c -lt $s.Examples[0].Count; $c++) { ($s.Examples | ForEach-Object { $_[$c].Length } | Measure-Object -Maximum).Maximum }
            [void]$sb.AppendLine()
            [void]$sb.AppendLine('    Examples:')
            foreach ($r in $s.Examples) {
                $cells = for ($c = 0; $c -lt $r.Count; $c++) { $r[$c].Replace('|', '\|').PadRight($widths[$c]) }
                [void]$sb.AppendLine('      | ' + ($cells -join ' | ') + ' |')
            }
        }
    }
    $body = $sb.ToString() -replace "`r`n", "`n"
    $versionText = if ($Version) { " (version $Version)" } else { '' }
    "# Generated from the knowledge base page $Source$versionText. Do not edit: change the page, then pull it.`n# Checksum: $(Get-FeatureChecksum -Body $body)`n" + $body
}

function Test-FeatureProvenance {
    <#
    .SYNOPSIS
        Returns the problem with a feature file's provenance, or nothing when it was generated from
        a page and not edited since.
    #>
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Text)
    $lines = $Text -replace "`r`n", "`n" -split "`n", 3
    if ($lines.Count -lt 3 -or $lines[0] -notmatch '^# Generated from the knowledge base page ' -or $lines[1] -notmatch '^# Checksum: (sha256:[0-9a-f]{64})$') {
        return 'has no provenance header: it was not generated from a knowledge base page'
    }
    $expected = $Matches[1]
    if ((Get-FeatureChecksum -Body $lines[2]) -ne $expected) {
        return 'was edited after it was generated: change the knowledge base page and pull it instead'
    }
}

Export-ModuleMember -Function ConvertTo-FeaturePage, ConvertFrom-FeaturePage, Test-FeatureProvenance, Get-FeatureChecksum
