#Requires -Version 7.0
<#
.SYNOPSIS
    Checks that the website is current with the framework (plan-website-pivot M3 and V1).
.DESCRIPTION
    When the website repository is present, runs Build-WebsiteMethodology.ps1 -Check and
    reports any stale file, then checks every page in site/ for: internal links that resolve
    (page and fragment), every /aa-<code>-<step> command it names existing in the workflow
    data, and every T-, O-, G-, and R- id it cites existing in the docs. Returns one string per
    problem; an empty result means current. When the website repository is absent the script
    writes a warning naming the path it looked for and returns nothing, so a clone without the
    site still passes the unit tier.
.PARAMETER SitePath
    The website repository's site folder. Defaults as in Build-WebsiteMethodology.ps1.
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]$SitePath
)

$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path -Path $PSScriptRoot -ChildPath '..')).Path
if (-not $SitePath) {
    $root = if ($env:AA_WEBSITE_PATH) { $env:AA_WEBSITE_PATH } else { Join-Path -Path $repo -ChildPath '..' -AdditionalChildPath '..', 'Websites', 'website-aasdlc-com' }
    $SitePath = Join-Path -Path $root -ChildPath 'site'
}
if (-not (Test-Path $SitePath)) {
    Write-Warning "Website currency check skipped: no site at $SitePath (set AA_WEBSITE_PATH to check it)."
    return @()
}
$SitePath = (Resolve-Path $SitePath).Path
$problems = [System.Collections.Generic.List[string]]::new()

foreach ($stale in @(& (Join-Path -Path $PSScriptRoot -ChildPath 'Build-WebsiteMethodology.ps1') -SitePath $SitePath -Check)) {
    $problems.Add("website: $stale is stale; run scripts/Build-WebsiteMethodology.ps1 and commit the site")
}

$docs = Join-Path -Path $repo -ChildPath 'docs'
$known = [System.Collections.Generic.HashSet[string]]::new()
foreach ($m in [regex]::Matches((Get-Content -Path (Join-Path $docs 'tenets.md') -Raw), '\*\*(T-\d+) ')) { [void]$known.Add($m.Groups[1].Value) }
foreach ($m in [regex]::Matches((Get-Content -Path (Join-Path $docs 'opinions.md') -Raw), '\*\*(O-\d+) ')) { [void]$known.Add($m.Groups[1].Value) }
foreach ($m in [regex]::Matches((Get-Content -Path (Join-Path $docs 'guidance.md') -Raw), '\| (G-\d+) \|')) { [void]$known.Add($m.Groups[1].Value) }
foreach ($m in [regex]::Matches((Get-Content -Path (Join-Path $docs 'requirements.md') -Raw), '\| (R-\d+) \|')) { [void]$known.Add($m.Groups[1].Value) }

$commands = [System.Collections.Generic.HashSet[string]]::new()
Get-ChildItem -Path (Join-Path -Path $repo -ChildPath 'src' -AdditionalChildPath 'aa-sdlc', 'workflow', 'steps') -Filter '*.yaml' | ForEach-Object {
    if ((Get-Content -Path $_.FullName -Raw) -match '(?m)^command:\s*(\S+)') { [void]$commands.Add($Matches[1]) }
}

$pages = Get-ChildItem -Path $SitePath -Filter '*.html' -File
$ids = @{}
foreach ($page in $pages) {
    $html = Get-Content -Path $page.FullName -Raw
    $set = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($m in [regex]::Matches($html, '\sid="([^"]+)"')) { [void]$set.Add($m.Groups[1].Value) }
    $ids[$page.Name] = $set
}

foreach ($page in $pages) {
    $html = Get-Content -Path $page.FullName -Raw
    # Text only: strip tags so class names and attributes are not read as citations
    $text = [regex]::Replace($html, '<[^>]+>', ' ')

    foreach ($m in [regex]::Matches($html, '\s(?:href|src)="([^"#:]*)(#[^"]*)?"')) {
        $target = $m.Groups[1].Value
        $fragment = $m.Groups[2].Value.TrimStart('#')
        $targetPage = if ($target) { $target } else { $page.Name }
        if ($target -and -not (Test-Path (Join-Path -Path $SitePath -ChildPath $target))) {
            $problems.Add("$($page.Name): link to missing file $target")
            continue
        }
        if ($fragment -and $ids.ContainsKey($targetPage) -and -not $ids[$targetPage].Contains($fragment)) {
            $problems.Add("$($page.Name): link to $targetPage#$fragment but no element has that id")
        }
    }

    foreach ($m in [regex]::Matches($text, '/aa-[a-z]+-[a-z0-9-]+')) {
        if (-not $commands.Contains($m.Value)) { $problems.Add("$($page.Name): names command $($m.Value), which no step defines") }
    }

    foreach ($m in [regex]::Matches($text, '\b([TOGR]-\d{2})\b')) {
        if (-not $known.Contains($m.Groups[1].Value)) { $problems.Add("$($page.Name): cites $($m.Groups[1].Value), which does not exist") }
    }
}

return @($problems | Sort-Object -Unique)
