#Requires -Version 7.4
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'AaFeatures.psd1') -ErrorAction Stop

function ConvertTo-StorageXmlEntityText([string]$Text) {
    # AP-28: storage uses HTML named references, while the safe reader accepts XML.
    # Convert only one reference layer to numeric XML, never decode the markup.
    [regex]::Replace($Text, '&[A-Za-z][A-Za-z0-9]*;', [Text.RegularExpressions.MatchEvaluator] {
            param($reference)
            if ($reference.Value -cin @('&amp;', '&lt;', '&gt;', '&quot;', '&apos;')) { return $reference.Value }
            $decoded = [Net.WebUtility]::HtmlDecode($reference.Value)
            if ($decoded -ceq $reference.Value) { throw "Unsupported named storage entity: $($reference.Value)" }
            $numeric = [Text.StringBuilder]::new()
            for ($index = 0; $index -lt $decoded.Length; $index++) {
                $codePoint = [char]::ConvertToUtf32($decoded, $index)
                $null = $numeric.Append(('&#x{0:X};' -f $codePoint))
                if ([char]::IsHighSurrogate($decoded[$index])) { $index++ }
            }
            return $numeric.ToString()
        })
}

function ConvertFrom-StorageInline([System.Xml.XmlNode]$Node, [bool]$AllowParagraph = $false) {
    if ($Node.NodeType -in [Xml.XmlNodeType]::Text, [Xml.XmlNodeType]::Whitespace, [Xml.XmlNodeType]::SignificantWhitespace) { return $Node.Value }
    if ($Node.NodeType -ne [Xml.XmlNodeType]::Element -or $Node.NamespaceURI) { throw "Unsupported storage inline node: $($Node.Name)" }
    if ($Node.LocalName -notin 'p', 'span', 'strong', 'em', 'b', 'i', 'code', 'a') { throw "Unsupported storage inline element: $($Node.Name)" }
    if ($Node.LocalName -eq 'p' -and -not $AllowParagraph) { throw 'Nested paragraph cannot be represented as inline text' }
    $text = (@($Node.ChildNodes | ForEach-Object { ConvertFrom-StorageInline $_ }) -join '')
    if ($Node.LocalName -eq 'a') {
        $href = ([Xml.XmlElement]$Node).GetAttribute('href')
        $uri = $null
        if (-not $href -or $href -match '[\r\n\[\]()]' -or -not [Uri]::TryCreate($href, [UriKind]::RelativeOrAbsolute, [ref]$uri) -or
            ($uri.IsAbsoluteUri -and $uri.Scheme -notin 'http', 'https', 'mailto')) { throw 'Unsupported or missing link target' }
        return "[$text]($href)"
    }
    return $text
}

function ConvertFrom-StorageList([System.Xml.XmlElement]$List) {
    # AP-29: every item is consumed once; unsupported structure cannot disappear.
    if ($List.LocalName -cnotin 'ul', 'ol') { throw 'Unsupported storage list element casing' }
    if ($List.Attributes.Count -gt 0) { throw 'List attributes require an explicit supported representation' }
    $lines = [Collections.Generic.List[string]]::new()
    foreach ($item in $List.ChildNodes) {
        if ($item.NodeType -in [Xml.XmlNodeType]::Whitespace, [Xml.XmlNodeType]::SignificantWhitespace -or
            ($item.NodeType -eq [Xml.XmlNodeType]::Text -and [string]::IsNullOrWhiteSpace($item.Value))) { continue }
        if ($item.NodeType -ne [Xml.XmlNodeType]::Element -or $item.NamespaceURI -or $item.LocalName -cne 'li' -or $item.Attributes.Count -gt 0) { throw 'Unsupported list item structure or attributes' }
        $paragraphs = @($item.SelectNodes('./p'))
        if ($paragraphs.Count -gt 1) { throw 'Multiple list item paragraphs require an explicit supported representation' }
        if ($paragraphs.Count -eq 1) {
            foreach ($child in $item.ChildNodes) {
                if ($child -eq $paragraphs[0] -or $child.NodeType -in [Xml.XmlNodeType]::Whitespace, [Xml.XmlNodeType]::SignificantWhitespace -or
                    ($child.NodeType -eq [Xml.XmlNodeType]::Text -and [string]::IsNullOrWhiteSpace($child.Value))) { continue }
                throw 'List item paragraph cannot be concatenated with other content'
            }
            $text = ConvertFrom-StorageInline $paragraphs[0] $true
        } else { $text = (@($item.ChildNodes | ForEach-Object { ConvertFrom-StorageInline $_ }) -join '') }
        if ([string]::IsNullOrWhiteSpace($text) -or $text -match '[\r\n]') { throw 'List items must contain nonempty single-line text' }
        $prefix = if ($List.LocalName -ceq 'ol') { "$($lines.Count + 1). " } else { '- ' }
        $lines.Add($prefix + $text)
    }
    if ($lines.Count -eq 0) { throw 'Empty storage list cannot represent requirements' }
    return ($lines -join "`n")
}

function ConvertFrom-StorageCell([System.Xml.XmlElement]$Cell) {
    if ($Cell.GetAttribute('rowspan') -notin '', '1' -or $Cell.GetAttribute('colspan') -notin '', '1') { throw 'Merged cells cannot be represented by a feature table' }
    $paragraphs = @($Cell.SelectNodes('./p'))
    if ($paragraphs.Count -gt 1) { throw 'Multiple cell paragraphs require an explicit supported representation' }
    if ($paragraphs.Count -eq 1) {
        foreach ($child in $Cell.ChildNodes) {
            if ($child -eq $paragraphs[0] -or ($child.NodeType -in [Xml.XmlNodeType]::Whitespace, [Xml.XmlNodeType]::SignificantWhitespace)) { continue }
            if ($child.NodeType -eq [Xml.XmlNodeType]::Text -and [string]::IsNullOrWhiteSpace($child.Value)) { continue }
            throw 'Cell paragraph cannot be concatenated with other inline content'
        }
        $text = ConvertFrom-StorageInline $paragraphs[0] $true
    } else { $text = (@($Cell.ChildNodes | ForEach-Object { ConvertFrom-StorageInline $_ }) -join '') }
    if ($text -match '[\r\n]') { throw 'Multiline cell text cannot be represented by a single feature row' }
    return $text.Replace('|', '\|')
}

function ConvertFrom-StorageTable([System.Xml.XmlElement]$Table) {
    foreach ($child in $Table.ChildNodes) {
        if ($child.NodeType -in [Xml.XmlNodeType]::Whitespace, [Xml.XmlNodeType]::SignificantWhitespace) { continue }
        if ($child.LocalName -notin 'thead', 'tbody', 'tr' -or $child.NamespaceURI) { throw 'Unsupported table structure' }
        if ($child.LocalName -in 'thead', 'tbody') {
            foreach ($sectionChild in $child.ChildNodes) {
                if ($sectionChild.NodeType -in [Xml.XmlNodeType]::Whitespace, [Xml.XmlNodeType]::SignificantWhitespace) { continue }
                if ($sectionChild.NodeType -ne [Xml.XmlNodeType]::Element -or $sectionChild.LocalName -ne 'tr' -or $sectionChild.NamespaceURI) { throw 'Unsupported table section content' }
            }
        }
    }
    $rows = @($Table.SelectNodes('./thead/tr | ./tbody/tr | ./tr'))
    if ($rows.Count -eq 0) { throw 'Empty storage table' }
    $lines = [Collections.Generic.List[string]]::new()
    $width = 0
    foreach ($row in $rows) {
        foreach ($child in $row.ChildNodes) {
            if ($child.NodeType -in [Xml.XmlNodeType]::Whitespace, [Xml.XmlNodeType]::SignificantWhitespace) { continue }
            if ($child.LocalName -notin 'th', 'td' -or $child.NamespaceURI) { throw 'Unsupported table row element' }
        }
        $cells = @($row.SelectNodes('./th | ./td') | ForEach-Object { ConvertFrom-StorageCell $_ })
        if ($cells.Count -eq 0 -or ($width -gt 0 -and $cells.Count -ne $width)) { throw 'Inconsistent storage table width' }
        $lines.Add('| ' + ($cells -join ' | ') + ' |')
        if ($width -eq 0) {
            $width = $cells.Count
            $lines.Add('| ' + ((@($cells | ForEach-Object { '---' })) -join ' | ') + ' |')
        }
    }
    return ($lines -join "`n")
}

function ConvertFrom-ConfluenceFeatureSnapshot {
    <#
    .SYNOPSIS
        Projects a configured knowledge-space REST storage snapshot into validated Markdown and Approved feature text.
    .DESCRIPTION
        Acquisition and approval happen at the authoritative source before this offline import.
        Unsupported markup is refused instead of silently omitting requirement content.
    .PARAMETER KnowledgeSpace
        The exact conventions.knowledge.space value from the project configuration.
    .PARAMETER KnowledgeUrl
        The conventions.knowledge.url space URL used to construct page provenance.
    .PARAMETER ScenarioId
        Optional exact Approved IDs passed to the public feature-page converter after the full
        storage projection is validated. Omitting selection retains the whole Approved page.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][string]$Json,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$KnowledgeSpace,
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$KnowledgeUrl,
        [Parameter()][AllowNull()][AllowEmptyCollection()][string[]]$ScenarioId
    )
    $knowledgeUri = $null
    if ([string]::IsNullOrWhiteSpace($KnowledgeSpace) -or $KnowledgeUrl -match '\s' -or
        -not [Uri]::TryCreate($KnowledgeUrl, [UriKind]::Absolute, [ref]$knowledgeUri) -or
        $knowledgeUri.Scheme -notin 'http', 'https' -or $knowledgeUri.UserInfo -or $knowledgeUri.Query -or $knowledgeUri.Fragment -or
        -not $knowledgeUri.AbsolutePath.TrimEnd('/').EndsWith('/spaces/' + [Uri]::EscapeDataString($KnowledgeSpace), [StringComparison]::Ordinal)) {
        throw 'KnowledgeUrl must be an HTTP(S) space URL matching KnowledgeSpace, without credentials, query or fragment'
    }
    $page = ConvertFrom-Json -InputObject $Json -Depth 80 -AsHashtable -NoEnumerate -ErrorAction Stop
    if ($page -isnot [Collections.IDictionary] -or $page.space -isnot [Collections.IDictionary] -or
        $page.version -isnot [Collections.IDictionary] -or $page.body -isnot [Collections.IDictionary] -or
        $page.body.storage -isnot [Collections.IDictionary]) { throw 'Snapshot and nested metadata must be JSON objects' }
    if ($page.space.key -isnot [string] -or $page.space.key -cne $KnowledgeSpace -or $page.type -isnot [string] -or $page.type -cne 'page') { throw 'Snapshot must identify a page in the configured knowledge space' }
    if ($page.id -isnot [string] -or $page.id -notmatch '^[0-9]+$' -or $page.title -isnot [string] -or -not $page.title.Trim()) { throw 'Invalid page identity or title' }
    $version = $page.version.number
    if (($version -isnot [int] -and $version -isnot [long]) -or $version -lt 1) { throw 'Source version must be a positive JSON integer' }
    $storage = $page.body.storage
    if ($storage.representation -isnot [string] -or $storage.representation -cne 'storage' -or $storage.value -isnot [string] -or -not $storage.value) { throw 'Snapshot has no supported storage body' }
    $settings = [Xml.XmlReaderSettings]::new()
    $settings.DtdProcessing = [Xml.DtdProcessing]::Prohibit
    $settings.XmlResolver = $null
    $settings.MaxCharactersInDocument = 10MB
    $wrapped = '<root xmlns:ac="http://atlassian.com/content" xmlns:ri="http://atlassian.com/resource/identifier">' + (ConvertTo-StorageXmlEntityText $storage.value) + '</root>'
    $reader = [Xml.XmlReader]::Create([IO.StringReader]::new($wrapped), $settings)
    $document = [Xml.XmlDocument]::new()
    $document.XmlResolver = $null
    try { $document.Load($reader) } finally { $reader.Dispose() }
    $markdown = [Collections.Generic.List[string]]::new()
    $sectionSeen = $false
    foreach ($node in $document.DocumentElement.ChildNodes) {
        if ($node.NodeType -in [Xml.XmlNodeType]::Whitespace, [Xml.XmlNodeType]::SignificantWhitespace) { continue }
        if ($node.NodeType -ne [Xml.XmlNodeType]::Element -or $node.NamespaceURI) { throw "Unsupported storage node: $($node.Name)" }
        switch -Regex ($node.LocalName) {
            '^table$' { $markdown.Add((ConvertFrom-StorageTable $node)); break }
            '^[uo]l$' {
                if ($sectionSeen) { throw 'Lists inside scenario sections require an explicit supported representation' }
                $markdown.Add((ConvertFrom-StorageList $node))
                break
            }
            '^h[1-6]$' {
                $level = [int]::Parse($node.LocalName.Substring(1))
                $text = (@($node.ChildNodes | ForEach-Object { ConvertFrom-StorageInline $_ }) -join '')
                if ($text -match '[\r\n]') { throw 'Multiline heading cannot be represented' }
                if ($sectionSeen -and ($level -lt 2 -or ($level -gt 2 -and ($level -ne 3 -or $text -cne 'Examples')))) { throw 'Unsupported heading inside scenario sections' }
                if ($level -eq 2) { $sectionSeen = $true }
                $markdown.Add(('#' * $level) + ' ' + $text)
                break
            }
            '^p$' {
                $paragraph = ConvertFrom-StorageInline $node $true
                if ($sectionSeen -and -not [string]::IsNullOrWhiteSpace($paragraph)) { throw 'Narrative inside scenario sections must be expressed as supported Step tables or moved to the feature preamble' }
                $markdown.Add($paragraph)
                break
            }
            default { throw "Unsupported storage block: $($node.Name)" }
        }
        $markdown.Add('')
    }
    $source = "$($KnowledgeUrl.TrimEnd('/'))/pages/$($page.id)"
    $text = $markdown -join "`n"
    $selection = @{}
    if ($PSBoundParameters.ContainsKey('ScenarioId')) { $selection.ScenarioId = $ScenarioId }
    $feature = ConvertFrom-FeaturePage -Markdown $text -Source $source -Version $version @selection
    [pscustomobject]@{ PageId = $page.id; Version = $version; Source = $source; Markdown = $text; FeatureText = $feature }
}

Export-ModuleMember -Function ConvertFrom-ConfluenceFeatureSnapshot
