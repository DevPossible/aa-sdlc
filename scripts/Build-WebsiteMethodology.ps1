#Requires -Version 7.0
#Requires -Modules powershell-yaml
<#
.SYNOPSIS
    Generates the website's methodology page and the generated blocks of its home page from
    the workflow data (decision records 0007 and 0008).
.DESCRIPTION
    Reads src/aa-sdlc/workflow/ and docs/guidance.md and writes <SitePath>/methodology.html in
    full, and replaces the regions of <SitePath>/index.html between the markers
    <!-- aa:status:begin --> / <!-- aa:status:end --> and
    <!-- aa:disciplines:begin --> / <!-- aa:disciplines:end -->. Everything else in index.html is
    hand-written and untouched. The output carries nothing volatile, so two runs are
    byte-identical. With -Check nothing is written; the script returns the list of files whose
    committed content differs from what it would write, and an empty list means current.
.PARAMETER SitePath
    The website repository's site folder. Defaults to the sibling checkout
    ../../Websites/website-aasdlc-com/site, or $env:AA_WEBSITE_PATH/site when that is set.
.PARAMETER Check
    Compare instead of write.
.EXAMPLE
    ./scripts/Build-WebsiteMethodology.ps1
    ./scripts/Build-WebsiteMethodology.ps1 -Check
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]$SitePath,

    [Parameter()]
    [switch]$Check
)

$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path -Path $PSScriptRoot -ChildPath '..')).Path
if (-not $SitePath) {
    $root = if ($env:AA_WEBSITE_PATH) { $env:AA_WEBSITE_PATH } else { Join-Path -Path $repo -ChildPath '..' -AdditionalChildPath '..', 'Websites', 'website-aasdlc-com' }
    $SitePath = Join-Path -Path $root -ChildPath 'site'
}
$workflow = Join-Path -Path $repo -ChildPath 'src' -AdditionalChildPath 'aa-sdlc', 'workflow'

function Read-YamlFolder {
    param([string]$Path)
    $result = @{}
    Get-ChildItem -Path $Path -Filter '*.yaml' -File | ForEach-Object {
        $result[$_.BaseName] = ConvertFrom-Yaml (Get-Content -Path $_.FullName -Raw)
    }
    return $result
}

function Esc([string]$s) {
    if ($null -eq $s) { return '' }
    return ($s -replace '&', '&amp;' -replace '<', '&lt;' -replace '>', '&gt;' -replace '"', '&quot;')
}

$disciplines = Read-YamlFolder (Join-Path -Path $workflow -ChildPath 'disciplines')
$steps = Read-YamlFolder (Join-Path -Path $workflow -ChildPath 'steps')
$processes = Read-YamlFolder (Join-Path -Path $workflow -ChildPath 'processes')
$sets = Read-YamlFolder (Join-Path -Path $workflow -ChildPath 'guidance-sets')
$guidanceText = @{}
foreach ($m in [regex]::Matches((Get-Content -Path (Join-Path -Path $repo -ChildPath 'docs' -AdditionalChildPath 'guidance.md') -Raw), '\| (G-\d+) \| (.+?) \| (.+?) \| (.+?) \|')) {
    $guidanceText[$m.Groups[1].Value] = $m.Groups[2].Value
}
$skillCount = (Get-ChildItem -Path (Join-Path -Path $repo -ChildPath 'src' -AdditionalChildPath 'aa-sdlc', 'skills') -Recurse -Filter 'SKILL.md' | Measure-Object).Count
$featureFiles = Get-ChildItem -Path (Join-Path -Path $repo -ChildPath 'features') -Recurse -Filter '*.feature'
$scenarioCount = ($featureFiles | Select-String -Pattern '^\s*Scenario' | Measure-Object).Count
$opinionCount = ([regex]::Matches((Get-Content -Path (Join-Path -Path $repo -ChildPath 'docs' -AdditionalChildPath 'opinions.md') -Raw), '^\*\*(O-\d+) ', 'Multiline')).Count
$tenetCount = ([regex]::Matches((Get-Content -Path (Join-Path -Path $repo -ChildPath 'docs' -AdditionalChildPath 'tenets.md') -Raw), '^\*\*(T-\d+) ', 'Multiline')).Count
$requirementCount = ([regex]::Matches((Get-Content -Path (Join-Path -Path $repo -ChildPath 'docs' -AdditionalChildPath 'requirements.md') -Raw), '\| (R-\d+) \|')).Count

$banner = "<!-- Generated from src/aa-sdlc/workflow/ by scripts/Build-WebsiteMethodology.ps1 in the aa-sdlc repository. Do not edit by hand; edit the workflow data and regenerate. -->"
$processOrder = 'conception', 'development', 'testing', 'deployment', 'verification', 'maintenance'

# ---------- methodology.html ----------
$sb = [System.Text.StringBuilder]::new()
$nl = "`n"
function L([string]$s) { [void]$script:sb.Append($s + $nl) }

L '<!DOCTYPE html>'
L '<html lang="en">'
L '<head>'
L '    <meta charset="UTF-8">'
L '    <meta name="viewport" content="width=device-width, initial-scale=1.0">'
L '    <title>Methodology - AA-SDLC</title>'
L '    <meta name="description" content="The AA-SDLC methodology as workflow data: six processes, fifteen disciplines, and every step with its command, artifacts, and guidance.">'
L '    <link rel="stylesheet" href="styles.css">'
L '</head>'
L '<body class="page-methodology">'
L "    $banner"
L '    <div class="alpha-banner">ALPHA: AA-SDLC is under active development and not yet ready for adoption</div>'
L '    <nav class="fixed-nav">'
L '        <div class="nav-container">'
L '            <div class="nav-brand"><a href="index.html"><h2>AA-SDLC</h2></a><span class="nav-subtitle">Agent Assisted Software Development Life Cycle</span></div>'
L '            <ul class="nav-menu">'
L '                <li><a href="index.html">Home</a></li>'
L '                <li><a href="methodology.html" class="active">Methodology</a></li>'
L '                <li><a href="business-case.html">Business Case</a></li>'
L '            </ul>'
L '        </div>'
L '    </nav>'
L '    <header class="hero hero-compact">'
L '        <div class="hero-content">'
L '            <h1>The Methodology</h1>'
L "            <p class=`"hero-subtitle`">$($processes.Count) processes, $($disciplines.Count) disciplines, $($steps.Count) steps. Generated from the workflow data that the skills are built from, so this page and the framework cannot disagree.</p>"
L '        </div>'
L '    </header>'
L '    <main class="container">'
L '        <section class="content-section" id="how-to-read">'
L '            <h2>How to read this page</h2>'
L '            <p>A <strong>discipline</strong> is a kind of work, not a person or a headcount: one developer runs every discipline on a personal project, and a team divides them however it likes. A <strong>step</strong> is one unit of work, delivered as a skill and invoked as a command inside your agent. A <strong>process</strong> is an ordered set of steps toward a goal; the order is a description, never an enforcement, and every step can run at any time. Each step names what it reads, what it produces and when that counts as done, and the guidance the agent follows.</p>'
L '            <p>The earlier version of this page described six phases and twenty-three steps with named actors and tools. Actors are gone because the discipline is the actor and the framework never assumes who performs it (T-13); tools are gone because the framework describes the process and lets the agent infer the tool from the project (T-01). That earlier document is kept in the website repository as the historical record of the pre-SDK methodology.</p>'
L '        </section>'
L '        <section class="content-section" id="processes">'
L '            <h2>The six processes</h2>'
foreach ($processId in $processOrder) {
    $p = $processes[$processId]; if (-not $p) { continue }
    L "            <article class=`"process-block`" id=`"process-$processId`">"
    L "                <h3>$(Esc $p.name)</h3>"
    L "                <p>$(Esc $p.summary.Trim())</p>"
    L '                <ol class="process-steps">'
    foreach ($sid in @($p.steps)) {
        $s = $steps[$sid]; $d = $disciplines[$s.discipline]
        L "                    <li><a href=`"#step-$sid`">$(Esc $s.name)</a> <span class=`"command-chip`">$(Esc $s.command)</span> <span class=`"muted`">$(Esc $d.name)</span></li>"
    }
    L '                </ol>'
    if ($p.exit) { L "                <p class=`"exit-condition`"><strong>Exit:</strong> $(Esc $p.exit.Trim())</p>" }
    L '            </article>'
}
L '        </section>'
L '        <section class="content-section" id="disciplines">'
L '            <h2>The steps, by discipline</h2>'
foreach ($d in ($disciplines.Values | Sort-Object order)) {
    L "            <div class=`"discipline-section`" id=`"discipline-$($d.id)`">"
    L "                <h3>$(Esc $d.name) <span class=`"command-chip`">$(Esc $d.code)</span></h3>"
    L "                <p>$(Esc $d.purpose.Trim())</p>"
    L '                <p><strong>Owns:</strong></p>'
    L '                <ul>'
    foreach ($o in @($d.owns)) { L "                    <li>$(Esc $o)</li>" }
    L '                </ul>'
    foreach ($sid in @($d.steps)) {
        $s = $steps[$sid]
        L "                <article class=`"step-card`" id=`"step-$sid`">"
        L "                    <h4>$(Esc $s.name) <span class=`"command-chip`">$(Esc $s.command)</span></h4>"
        L "                    <p>$(Esc $s.summary.Trim())</p>"
        $anchorText = switch ($s.anchor) { 'required' { 'Anchors on a ticket.' } 'optional' { 'A ticket is optional.' } default { 'No ticket anchor.' } }
        L "                    <p class=`"muted`">$anchorText Skill: <code>src/aa-sdlc/skills/$($s.discipline)/$sid/SKILL.md</code></p>"
        if ($s.inputs) {
            L '                    <h5>Reads</h5>'
            L '                    <ul>'
            foreach ($i in @($s.inputs)) { L "                        <li>$(Esc $i)</li>" }
            L '                    </ul>'
        }
        L '                    <h5>Produces</h5>'
        foreach ($a in @($s.artifacts)) {
            L "                    <p><strong>$(Esc $a.name)</strong> in $(Esc $a.location). Done when:</p>"
            L '                    <ul>'
            foreach ($c in @($a.acceptance)) { L "                        <li>$(Esc $c)</li>" }
            L '                    </ul>'
        }
        L '                    <details class="guidance">'
        L '                        <summary>Guidance the agent follows</summary>'
        $seen = [System.Collections.Generic.List[string]]::new()
        foreach ($setId in @($s.guidance_sets | Where-Object { $_ })) {
            $set = $sets[$setId]
            L "                        <p class=`"muted`">From the <code>$setId</code> set: $(Esc $set.purpose.Trim())</p>"
            L '                        <ul>'
            foreach ($g in @($set.guidance)) { if ($seen.Contains($g)) { continue }; $seen.Add($g); L "                            <li><strong>$g</strong> $(Esc $guidanceText[$g])</li>" }
            L '                        </ul>'
        }
        if ($s.guidance -or $s.guidance_inline) {
            L '                        <p class="muted">For this step:</p>'
            L '                        <ul>'
            foreach ($g in @($s.guidance | Where-Object { $_ })) { if (-not $seen.Contains($g)) { $seen.Add($g); L "                            <li><strong>$g</strong> $(Esc $guidanceText[$g])</li>" } }
            foreach ($g in @($s.guidance_inline | Where-Object { $_ })) { L "                            <li>$(Esc $g)</li>" }
            L '                        </ul>'
        }
        $refs = @()
        if ($s.tenets) { $refs += 'Tenets ' + (@($s.tenets) -join ', ') }
        if ($s.opinions) { $refs += 'Opinions ' + (@($s.opinions) -join ', ') }
        if ($refs) { L "                        <p class=`"muted`">$(Esc ($refs -join ' | '))</p>" }
        L '                    </details>'
        L '                </article>'
    }
    L '            </div>'
}
L '        </section>'
L '    </main>'
L '    <footer class="footer">'
L '        <div class="footer-content">'
L '            <p>AA-SDLC is a DevPossible process. This page is generated from the framework&#39;s workflow data.</p>'
L '            <p>&copy; 2024-2026 DevPossible LLC</p>'
L '        </div>'
L '    </footer>'
L '    <script src="script.js"></script>'
L '</body>'
L '</html>'
$methodology = $sb.ToString()

# ---------- index.html generated blocks ----------
$cliVerbs = 'setup, init, update, plugin'
$status = @(
    $banner
    '<div class="status-block">'
    '    <h3>What exists today</h3>'
    '    <ul class="status-list">'
    "        <li><span class=`"status-count`">$($disciplines.Count)</span> disciplines and <span class=`"status-count`">$($processes.Count)</span> processes defined as workflow data</li>"
    "        <li><span class=`"status-count`">$($steps.Count)</span> steps, each with a skill and a command: <span class=`"status-count`">$skillCount</span> of $($steps.Count) skills present</li>"
    "        <li><span class=`"status-count`">$tenetCount</span> tenets, <span class=`"status-count`">$opinionCount</span> opinions, <span class=`"status-count`">$requirementCount</span> requirements, each with a stable id</li>"
    "        <li><span class=`"status-count`">$($featureFiles.Count)</span> feature files holding <span class=`"status-count`">$scenarioCount</span> scenarios: the framework&#39;s own requirements, in Gherkin</li>"
    "        <li>The <code>aa</code> command line: verbs <code>$cliVerbs</code>, a native binary packed for six platforms, not yet published</li>"
    '        <li>One agent target supported so far: Claude Code. The skills are plain files and read the same on any agent that supports the skills format.</li>'
    '    </ul>'
    '    <p class="muted">Counts are regenerated from the repository; if this block is stale, the framework&#39;s own tests fail.</p>'
    '</div>'
) -join $nl

$grid = [System.Text.StringBuilder]::new()
[void]$grid.Append($banner + $nl)
[void]$grid.Append('<ol class="process-map">' + $nl)
foreach ($processId in $processOrder) {
    $p = $processes[$processId]; if (-not $p) { continue }
    $stepNames = @(@($p.steps) | ForEach-Object { Esc $steps[$_].name }) -join ', '
    [void]$grid.Append("    <li><a href=`"methodology.html#process-$processId`">$(Esc $p.name)</a>: $(Esc $p.summary.Trim()) <span class=`"muted`">$stepNames.</span></li>" + $nl)
}
[void]$grid.Append('</ol>' + $nl)
[void]$grid.Append('<div class="discipline-grid">' + $nl)
foreach ($d in ($disciplines.Values | Sort-Object order)) {
    [void]$grid.Append("    <article class=`"discipline-card`">" + $nl)
    [void]$grid.Append("        <h4><a href=`"methodology.html#discipline-$($d.id)`">$(Esc $d.name)</a> <span class=`"command-chip`">$(Esc $d.code)</span></h4>" + $nl)
    [void]$grid.Append("        <p>$(Esc $d.purpose.Trim())</p>" + $nl)
    [void]$grid.Append('        <ul class="command-list">' + $nl)
    foreach ($sid in @($d.steps)) { [void]$grid.Append("            <li><a href=`"methodology.html#step-$sid`"><span class=`"command-chip`">$(Esc $steps[$sid].command)</span></a> $(Esc $steps[$sid].name)</li>" + $nl) }
    [void]$grid.Append('        </ul>' + $nl)
    [void]$grid.Append('    </article>' + $nl)
}
[void]$grid.Append('</div>')
$disciplinesHtml = $grid.ToString()

function Set-Region([string]$html, [string]$name, [string]$body) {
    $pattern = "(?s)(<!-- aa:${name}:begin -->).*?(<!-- aa:${name}:end -->)"
    if ($html -notmatch $pattern) { throw "index.html has no <!-- aa:${name}:begin --> / end markers" }
    return [regex]::Replace($html, $pattern, { param($m) $m.Groups[1].Value + $nl + $body + $nl + $m.Groups[2].Value })
}

$stale = [System.Collections.Generic.List[string]]::new()
$methodologyPath = Join-Path -Path $SitePath -ChildPath 'methodology.html'
$indexPath = Join-Path -Path $SitePath -ChildPath 'index.html'
if (-not (Test-Path $SitePath)) { throw "Site path not found: $SitePath" }

$currentMethodology = if (Test-Path $methodologyPath) { Get-Content -Path $methodologyPath -Raw } else { '' }
if ($currentMethodology -ne $methodology) { $stale.Add('methodology.html') }

$newIndex = $null
if (Test-Path $indexPath) {
    $currentIndex = Get-Content -Path $indexPath -Raw
    $newIndex = Set-Region -html $currentIndex -name 'status' -body $status
    $newIndex = Set-Region -html $newIndex -name 'disciplines' -body $disciplinesHtml
    if ($newIndex -ne $currentIndex) { $stale.Add('index.html') }
} else {
    $stale.Add('index.html (missing)')
}

if ($Check) {
    return $stale
}

Set-Content -Path $methodologyPath -Value $methodology -NoNewline -Encoding utf8
if ($newIndex) { Set-Content -Path $indexPath -Value $newIndex -NoNewline -Encoding utf8 }
Write-Host "Wrote $methodologyPath and the generated blocks of $indexPath" -ForegroundColor Green
