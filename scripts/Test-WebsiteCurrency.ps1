#Requires -Version 7.0
<#
.SYNOPSIS
    Checks that the website's committed pages are current with the framework (plan-website-pivot
    M3 and V1; decision records 0007 and 0010).
.DESCRIPTION
    When the website repository is present, exports the site folder from its committed HEAD
    (never its working tree, so an editor's unsaved or uncommitted state cannot change this
    repository's test result), runs Build-WebsiteMethodology.ps1 -Check against that export,
    then checks every page for: internal links and image sources that resolve (page and
    fragment), every /aa-<code>-<step> command it names existing in the workflow data, and
    every T-, O-, G-, and R- id it cites existing in the docs. Returns one string per problem;
    an empty result means current. When the website repository is absent the script writes a
    warning naming the path it looked for and returns nothing, so a clone without the site
    still passes the unit tier.
.PARAMETER WebsitePath
    The website repository's root. Defaults to the sibling checkout
    ../../Websites/website-aasdlc-com, or $env:AA_WEBSITE_PATH when that is set.
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]$WebsitePath
)

$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path -Path $PSScriptRoot -ChildPath '..')).Path
if (-not $WebsitePath) {
    $WebsitePath = if ($env:AA_WEBSITE_PATH) { $env:AA_WEBSITE_PATH } else { Join-Path -Path $repo -ChildPath '..' -AdditionalChildPath '..', 'Websites', 'website-aasdlc-com' }
}
if (-not (Test-Path (Join-Path -Path $WebsitePath -ChildPath '.git'))) {
    Write-Warning "Website currency check skipped: no website repository at $WebsitePath (set AA_WEBSITE_PATH to check one)."
    return @()
}
$WebsitePath = (Resolve-Path $WebsitePath).Path

# Export site/ from the committed HEAD into a temporary folder; the working tree is never read
$export = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "aa-website-currency-$([System.Guid]::NewGuid().ToString('N'))"
New-Item -ItemType Directory -Path $export | Out-Null
try {
    $zip = Join-Path -Path $export -ChildPath 'site.zip'
    # autocrlf off: export the blobs as committed, not as a Windows checkout would rewrite them
    & git -C $WebsitePath -c core.autocrlf=false archive --format=zip -o $zip HEAD site
    if ($LASTEXITCODE -ne 0) { throw "git archive of $WebsitePath HEAD failed" }
    Expand-Archive -Path $zip -DestinationPath $export
    $head = (& git -C $WebsitePath rev-parse --short HEAD).Trim()
    $SitePath = Join-Path -Path $export -ChildPath 'site'
    $problems = [System.Collections.Generic.List[string]]::new()

    foreach ($stale in @(& (Join-Path -Path $PSScriptRoot -ChildPath 'Build-WebsiteMethodology.ps1') -SitePath $SitePath -Check)) {
        $problems.Add("website at $head`: $stale is stale; run scripts/Build-WebsiteMethodology.ps1 and commit the site")
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
} finally {
    Remove-Item -Path $export -Recurse -Force -ErrorAction SilentlyContinue
}
