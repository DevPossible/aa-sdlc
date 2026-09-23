#Requires -Version 7.0
#Requires -Modules powershell-yaml
<#
.SYNOPSIS
    Generates the website's methodology page, its workflow diagram, and the generated blocks of
    its home page from the workflow data (decision records 0007 and 0008).
.DESCRIPTION
    Reads src/aa-sdlc/workflow/ and docs/guidance.md and writes <SitePath>/methodology.html and
    <SitePath>/images/workflow-ring.svg in full, and replaces the regions of <SitePath>/index.html
    between the markers <!-- aa:status:begin --> / <!-- aa:status:end --> and
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
$repoUrl = 'https://github.com/DevPossible/aa-sdlc'
$processOrder = 'conception', 'development', 'testing', 'deployment', 'verification', 'maintenance'
$nl = "`n"

# Colours and icons per discipline (by code) and per process. The site's stylesheet defines a
# class per discipline code (d-ba, d-dev, ...) and per process (p-conception, ...); the colours
# here are only for the SVG diagram, which cannot use the page's stylesheet when used as an image.
$processColour = @{
    conception = '#7d3c98'; development = '#2471a3'; testing = '#b9770e'
    deployment = '#148f77'; verification = '#1a5276'; maintenance = '#935116'
}
$icon = @{
    'product-management'      = '<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="5"/><circle cx="12" cy="12" r="1.5"/>'
    'business-analysis'       = '<path d="M6 3h9l4 4v14H6z"/><path d="M15 3v4h4"/><path d="M9 12h6M9 16h6"/>'
    'ux-design'               = '<rect x="3" y="4" width="18" height="16" rx="2"/><path d="M3 9h18M9 9v11"/>'
    'technical-analysis'      = '<path d="M12 3l8 4.5v9L12 21l-8-4.5v-9z"/><path d="M12 12l8-4.5M12 12v9M12 12L4 7.5"/>'
    'refinement'              = '<path d="M4 5h16l-6 7v6l-4 2v-8z"/>'
    'implementation-planning' = '<rect x="4" y="4" width="16" height="16" rx="2"/><path d="M8 9h8M8 13h8M8 17h5"/>'
    'development'             = '<path d="M9 7l-5 5 5 5M15 7l5 5-5 5"/>'
    'testing'                 = '<circle cx="12" cy="12" r="9"/><path d="M8 12l3 3 5-6"/>'
    'security'                = '<path d="M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z"/><path d="M9 12l2 2 4-4"/>'
    'operations'              = '<rect x="3" y="4" width="18" height="6" rx="1"/><rect x="3" y="14" width="18" height="6" rx="1"/><path d="M7 7h.01M7 17h.01"/>'
    'release-management'      = '<path d="M12 3c3 3 4 7 4 10l2 3h-4l-2 3-2-3H6l2-3c0-3 1-7 4-10z"/><circle cx="12" cy="10" r="1.5"/>'
    'documentation'           = '<path d="M4 5a2 2 0 012-2h6v18H6a2 2 0 00-2 2z"/><path d="M20 5a2 2 0 00-2-2h-6v18h6a2 2 0 012 2z"/>'
    'support'                 = '<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="4"/><path d="M5.6 5.6l3.5 3.5M14.9 14.9l3.5 3.5M18.4 5.6l-3.5 3.5M9.1 14.9l-3.5 3.5"/>'
    'project-management'      = '<rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 10h18M8 3v4M16 3v4"/>'
    'framework'               = '<path d="M12 2l8.7 5v10L12 22l-8.7-5V7z"/><circle cx="12" cy="12" r="3"/>'
}
function Get-Icon([string]$disciplineId) {
    $paths = $icon[$disciplineId]
    # A new discipline must bring an icon; failing here makes the unit tier say so instead of shipping a blank
    if (-not $paths) { throw "No icon for discipline '$disciplineId': add an entry to the icon table in scripts/Build-WebsiteMethodology.ps1 and regenerate the site" }
    return "<svg class=`"discipline-icon`" viewBox=`"0 0 24 24`" aria-hidden=`"true`" focusable=`"false`" fill=`"none`" stroke=`"currentColor`" stroke-width=`"2`" stroke-linecap=`"round`" stroke-linejoin=`"round`">$paths</svg>"
}

# ---------- images/workflow-ring.svg: the six processes as a cycle ----------
function New-Ring([bool]$WithLinks) {
    $ring = [System.Text.StringBuilder]::new()
    $size = 460; $centre = $size / 2; $radius = 165; $node = 52
    # The standalone file is one image; the inline copy holds links, so it must not be role="img" or assistive technology cannot reach them
    $role = if ($WithLinks) { '' } else { ' role="img"' }
    [void]$ring.Append("<svg xmlns=`"http://www.w3.org/2000/svg`" viewBox=`"0 0 $size $size`"$role aria-labelledby=`"ring-title`" class=`"workflow-ring`">$nl")
    [void]$ring.Append("  <title id=`"ring-title`">The six AA-SDLC processes as a cycle: $(($processOrder | ForEach-Object { $processes[$_].name }) -join ', ')</title>$nl")
    [void]$ring.Append("  <defs><marker id=`"ring-arrow`" viewBox=`"0 0 10 10`" refX=`"8`" refY=`"5`" markerWidth=`"7`" markerHeight=`"7`" orient=`"auto-start-reverse`"><path d=`"M0 0L10 5 0 10z`" fill=`"#8a9bb0`"/></marker></defs>$nl")
    [void]$ring.Append("  <circle cx=`"$centre`" cy=`"$centre`" r=`"$radius`" fill=`"none`" stroke=`"#dfe6ee`" stroke-width=`"14`"/>$nl")
    $n = $processOrder.Count
    for ($i = 0; $i -lt $n; $i++) {
        # An arc from just after this node to just before the next, clockwise
        $a1 = (-90 + $i * 360 / $n + 22) * [Math]::PI / 180
        $a2 = (-90 + ($i + 1) * 360 / $n - 22) * [Math]::PI / 180
        $x1 = [Math]::Round($centre + $radius * [Math]::Cos($a1), 1); $y1 = [Math]::Round($centre + $radius * [Math]::Sin($a1), 1)
        $x2 = [Math]::Round($centre + $radius * [Math]::Cos($a2), 1); $y2 = [Math]::Round($centre + $radius * [Math]::Sin($a2), 1)
        [void]$ring.Append("  <path d=`"M$x1 $y1 A$radius $radius 0 0 1 $x2 $y2`" fill=`"none`" stroke=`"#8a9bb0`" stroke-width=`"3`" marker-end=`"url(#ring-arrow)`"/>$nl")
    }
    for ($i = 0; $i -lt $n; $i++) {
        $processId = $processOrder[$i]; $p = $processes[$processId]
        $a = (-90 + $i * 360 / $n) * [Math]::PI / 180
        $x = [Math]::Round($centre + $radius * [Math]::Cos($a), 1); $y = [Math]::Round($centre + $radius * [Math]::Sin($a), 1)
        $count = @($p.steps).Count
        # The node is small, so a long name such as "Conception and idea refinement" shows its first part
        $short = ($p.name -split ' and ')[0]
        $label = "<circle cx=`"$x`" cy=`"$y`" r=`"$node`" fill=`"$($processColour[$processId])`"/><text x=`"$x`" y=`"$($y - 4)`" text-anchor=`"middle`" font-family=`"Inter, Segoe UI, Arial, sans-serif`" font-size=`"14`" font-weight=`"700`" fill=`"#ffffff`">$(Esc $short)</text><text x=`"$x`" y=`"$($y + 15)`" text-anchor=`"middle`" font-family=`"Inter, Segoe UI, Arial, sans-serif`" font-size=`"12`" fill=`"#ffffff`" opacity=`"0.9`">$count steps</text>"
        if ($WithLinks) { [void]$ring.Append("  <a href=`"#process-$processId`" aria-label=`"$(Esc $p.name), $count steps`">$label</a>$nl") } else { [void]$ring.Append("  $label$nl") }
    }
    [void]$ring.Append("  <text x=`"$centre`" y=`"$($centre - 8)`" text-anchor=`"middle`" font-family=`"Inter, Segoe UI, Arial, sans-serif`" font-size=`"26`" font-weight=`"700`" fill=`"#1a2332`">AA-SDLC</text>$nl")
    [void]$ring.Append("  <text x=`"$centre`" y=`"$($centre + 18)`" text-anchor=`"middle`" font-family=`"Inter, Segoe UI, Arial, sans-serif`" font-size=`"14`" fill=`"#666666`">$($steps.Count) steps, $($disciplines.Count) disciplines</text>$nl")
    [void]$ring.Append('</svg>')
    return $ring.ToString()
}
$ringFile = "<!-- Generated from src/aa-sdlc/workflow/ by scripts/Build-WebsiteMethodology.ps1 in the aa-sdlc repository. Do not edit by hand. -->$nl" + (New-Ring $false) + $nl
$ringInline = New-Ring $true

# ---------- methodology.html ----------
$sb = [System.Text.StringBuilder]::new()
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
L '    <nav class="fixed-nav">'
L '        <div class="nav-container">'
L '            <div class="nav-brand"><a href="index.html"><h2>AA-SDLC</h2></a><span class="nav-subtitle">Agent Assisted Software Development Life Cycle, by <a href="https://devpossible.com">DevPossible</a></span></div>'
L '            <ul class="nav-menu">'
L '                <li><a href="index.html">Home</a></li>'
L '                <li><a href="methodology.html" class="active">Methodology</a></li>'
L '                <li><a href="business-case.html">Business Case</a></li>'
L '                <li><a href="https://github.com/DevPossible/aa-sdlc" rel="noopener">GitHub</a></li>'
L '            </ul>'
L '        </div>'
L '    </nav>'
L '    <header class="hero hero-split">'
L '        <div class="hero-content">'
L '            <div class="hero-text">'
L '                <p class="eyebrow">The methodology</p>'
L '                <h1>Six processes. Fifteen disciplines. One ticket at a time.</h1>'
L "                <p class=`"hero-subtitle`">$($steps.Count) steps, each a skill your agent runs. Generated from the workflow data that the skills are built from, so this page and the framework cannot disagree.</p>"
L '                <p><a href="#processes" class="btn-primary">The processes</a> <a href="#disciplines" class="btn-secondary">The steps</a></p>'
L '            </div>'
L '            <div class="hero-visual">'
foreach ($line in ($ringInline -split $nl)) { L "                $line" }
L '            </div>'
L '        </div>'
L '    </header>'
L '    <main class="container">'
L '        <section class="content-section" id="how-to-read">'
L '            <p class="eyebrow">Vocabulary</p>'
L '            <h2>How to read this page</h2>'
L '            <div class="grid-3">'
L '                <div class="card"><h3>Discipline</h3><p>A kind of work, not a person or a headcount. One developer runs every discipline on a personal project; a team divides them however it likes.</p></div>'
L '                <div class="card"><h3>Step</h3><p>One unit of work, delivered as a skill and invoked as a command inside your agent. Each names what it reads, what it produces, when that counts as done, and the guidance it follows.</p></div>'
L '                <div class="card"><h3>Process</h3><p>An ordered set of steps toward a goal. The order is a description, never an enforcement: every step can run at any time.</p></div>'
L '            </div>'
L '            <p class="muted">The earlier version of this page described six phases and twenty-three steps with named actors and tools. Actors are gone because the discipline is the actor and the framework never assumes who performs it (T-13); tools are gone because the framework describes the process and lets the agent infer the tool from the project (T-01). That earlier document is kept in the website repository as the historical record of the pre-SDK methodology.</p>'
L '        </section>'
L '        <section class="content-section" id="processes">'
L '            <p class="eyebrow">The cycle</p>'
L '            <h2>The six processes</h2>'
foreach ($processId in $processOrder) {
    $p = $processes[$processId]; if (-not $p) { continue }
    L "            <article class=`"process-block p-$processId`" id=`"process-$processId`">"
    L "                <img class=`"process-art`" src=`"images/process-$processId.webp`" alt=`"`" width=`"768`" height=`"768`" loading=`"lazy`">"
    L '                <div class="process-body">'
    L "                    <h3>$(Esc $p.name)</h3>"
    L "                    <p>$(Esc $p.summary.Trim())</p>"
    L '                    <ol class="step-flow">'
    foreach ($sid in @($p.steps)) {
        $s = $steps[$sid]; $d = $disciplines[$s.discipline]
        L "                        <li class=`"d-$($d.code)`"><a href=`"#step-$sid`"><span class=`"flow-name`">$(Esc $s.name)</span><span class=`"flow-discipline`">$(Esc $d.name)</span></a></li>"
    }
    L '                    </ol>'
    if ($p.exit) { L "                    <p class=`"exit-condition`"><strong>Exit:</strong> $(Esc $p.exit.Trim())</p>" }
    L '                </div>'
    L '            </article>'
}
L '        </section>'
L '        <section class="content-section" id="disciplines">'
L '            <p class="eyebrow">The reference</p>'
L '            <h2>The steps, by discipline</h2>'
L '            <ul class="discipline-index">'
foreach ($d in ($disciplines.Values | Sort-Object order)) {
    L "                <li class=`"d-$($d.code)`"><a href=`"#discipline-$($d.id)`">$(Get-Icon $d.id)$(Esc $d.name)</a></li>"
}
L '            </ul>'
foreach ($d in ($disciplines.Values | Sort-Object order)) {
    L "            <div class=`"discipline-section d-$($d.code)`" id=`"discipline-$($d.id)`">"
    L "                <h3>$(Get-Icon $d.id)$(Esc $d.name) <span class=`"command-chip`">$(Esc $d.code)</span></h3>"
    L "                <p>$(Esc $d.purpose.Trim())</p>"
    L '                <p><strong>Owns:</strong></p>'
    L '                <ul>'
    foreach ($o in @($d.owns)) { L "                    <li>$(Esc $o)</li>" }
    L '                </ul>'
    foreach ($sid in @($d.steps)) {
        $s = $steps[$sid]
        L "                <article class=`"step-card d-$($d.code)`" id=`"step-$sid`">"
        L "                    <h4>$(Esc $s.name) <span class=`"command-chip`">$(Esc $s.command)</span></h4>"
        L "                    <p>$(Esc $s.summary.Trim())</p>"
        $anchorText = switch ($s.anchor) { 'required' { 'Anchors on a ticket.' } 'optional' { 'A ticket is optional.' } default { 'No ticket anchor.' } }
        L "                    <p class=`"muted`">$anchorText Skill: <a href=`"$repoUrl/blob/main/src/aa-sdlc/skills/$($s.discipline)/$sid/SKILL.md`"><code>src/aa-sdlc/skills/$($s.discipline)/$sid/SKILL.md</code></a></p>"
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
L "            <p><a href=`"$repoUrl`">The framework repository on GitHub</a></p>"
L '            <p>AA-SDLC is a <a href="https://devpossible.com">DevPossible</a> process. This page is generated from the framework&#39;s workflow data.</p>'
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
[void]$grid.Append('<div class="ring-and-map">' + $nl)
[void]$grid.Append('    <div class="ring-holder">' + $nl)
[void]$grid.Append('        <img src="images/workflow-ring.svg" alt="The six AA-SDLC processes as a cycle" width="460" height="460">' + $nl)
[void]$grid.Append('    </div>' + $nl)
[void]$grid.Append('    <ol class="process-map">' + $nl)
foreach ($processId in $processOrder) {
    $p = $processes[$processId]; if (-not $p) { continue }
    $stepNames = @(@($p.steps) | ForEach-Object { Esc $steps[$_].name }) -join ', '
    [void]$grid.Append("        <li class=`"process-card p-$processId`">" + $nl)
    [void]$grid.Append("            <a href=`"methodology.html#process-$processId`"><img src=`"images/process-$processId.webp`" alt=`"`" width=`"768`" height=`"768`" loading=`"lazy`"></a>" + $nl)
    [void]$grid.Append("            <div><h4><a href=`"methodology.html#process-$processId`">$(Esc $p.name)</a></h4><p>$(Esc $p.summary.Trim())</p><p class=`"muted`">$stepNames.</p></div>" + $nl)
    [void]$grid.Append('        </li>' + $nl)
}
[void]$grid.Append('    </ol>' + $nl)
[void]$grid.Append('</div>' + $nl)
[void]$grid.Append('<div class="discipline-grid">' + $nl)
foreach ($d in ($disciplines.Values | Sort-Object order)) {
    [void]$grid.Append("    <article class=`"discipline-card d-$($d.code)`">" + $nl)
    [void]$grid.Append("        <h4>$(Get-Icon $d.id)<a href=`"methodology.html#discipline-$($d.id)`">$(Esc $d.name)</a> <span class=`"command-chip`">$(Esc $d.code)</span></h4>" + $nl)
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
$ringPath = Join-Path -Path $SitePath -ChildPath 'images' -AdditionalChildPath 'workflow-ring.svg'
if (-not (Test-Path $SitePath)) { throw "Site path not found: $SitePath" }

$currentMethodology = if (Test-Path $methodologyPath) { Get-Content -Path $methodologyPath -Raw } else { '' }
if ($currentMethodology -ne $methodology) { $stale.Add('methodology.html') }
$currentRing = if (Test-Path $ringPath) { Get-Content -Path $ringPath -Raw } else { '' }
if ($currentRing -ne $ringFile) { $stale.Add('images/workflow-ring.svg') }

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

New-Item -ItemType Directory -Force -Path (Split-Path -Path $ringPath) | Out-Null
Set-Content -Path $methodologyPath -Value $methodology -NoNewline -Encoding utf8
Set-Content -Path $ringPath -Value $ringFile -NoNewline -Encoding utf8
if ($newIndex) { Set-Content -Path $indexPath -Value $newIndex -NoNewline -Encoding utf8 }
Write-Host "Wrote $methodologyPath, $ringPath, and the generated blocks of $indexPath" -ForegroundColor Green
