#Requires -Version 7.0
#Requires -Modules powershell-yaml
<#
.SYNOPSIS
    Generates one subagent per delivery discipline from the workflow data (decision record 0015).
.DESCRIPTION
    Writes src/aa-sdlc/agents/aa-<code>.md for every discipline except Framework: its purpose,
    what it owns and does not own, the guidance sets its steps read, the steps plugin skills may
    attach to, and how it reports back. Nothing in an agent is typed by hand, so an agent cannot
    drift from the skills' guidance. With -Check it writes nothing and returns one line per agent
    that differs from what the data generates, which the unit tier treats as a failure.
.PARAMETER Check
    Report stale or missing agents instead of writing them.
.EXAMPLE
    ./scripts/Sync-Agents.ps1
    ./scripts/Sync-Agents.ps1 -Check
#>
[CmdletBinding()]
param(
    [Parameter()]
    [switch]$Check
)

$ErrorActionPreference = 'Stop'

$repo = (Resolve-Path (Join-Path -Path $PSScriptRoot -ChildPath '..')).Path
$workflow = Join-Path -Path $repo -ChildPath 'src' -AdditionalChildPath 'aa-sdlc', 'workflow'
$agentsDir = Join-Path -Path $repo -ChildPath 'src' -AdditionalChildPath 'aa-sdlc', 'agents'
$guidancePath = 'src/aa-sdlc/skills/aa-guidance/sets'

function Read-YamlFolder([string]$Path) {
    $result = @{}
    Get-ChildItem -Path $Path -Filter '*.yaml' | ForEach-Object { $result[$_.BaseName] = ConvertFrom-Yaml (Get-Content -Path $_.FullName -Raw) }
    return $result
}

function Get-Oneline([string]$Text) { return (($Text -split '\s+') | Where-Object { $_ }) -join ' ' }

function Get-Wrapped([string]$Text) {
    # Wrap prose at 100 columns so the generated file reads like the rest of the repository
    $lines = [System.Collections.Generic.List[string]]::new()
    $line = ''
    foreach ($word in (Get-Oneline $Text) -split ' ') {
        if ($line.Length -gt 0 -and ($line.Length + 1 + $word.Length) -gt 100) { $lines.Add($line); $line = $word }
        elseif ($line.Length -gt 0) { $line += " $word" }
        else { $line = $word }
    }
    if ($line) { $lines.Add($line) }
    return $lines -join "`n"
}

$disciplines = Read-YamlFolder (Join-Path -Path $workflow -ChildPath 'disciplines')
$steps = Read-YamlFolder (Join-Path -Path $workflow -ChildPath 'steps')

$expected = @{}
foreach ($d in ($disciplines.Values | Where-Object { $_.id -ne 'framework' } | Sort-Object order)) {
    $name = "aa-$($d.code)"
    $purpose = Get-Oneline $d.purpose
    $firstSentence = ($purpose -split '(?<=\.)\s')[0]
    $description = "The $($d.name) discipline of AA-SDLC, in its own context. $firstSentence Use it when an AA-SDLC step hands it part of its work."
    $stepIds = @($d.steps)
    $sets = @($stepIds | ForEach-Object { @($steps[$_].guidance_sets) } | Where-Object { $_ } | Sort-Object -Unique)

    $body = [System.Text.StringBuilder]::new()
    [void]$body.Append("---`nname: $name`ndescription: `"$($description.Replace('\', '\\').Replace('"', '\"'))`"`n---`n")
    [void]$body.Append("<!-- Generated from src/aa-sdlc/workflow/ by scripts/Sync-Agents.ps1 (decision record 0015). Do not edit by hand. -->`n`n")
    [void]$body.Append("# ${name}: $($d.name)`n`n")
    [void]$body.Append((Get-Wrapped "You are the $($d.name) discipline of the AA-SDLC software life cycle, working in your own context. An AA-SDLC step has handed you part of its work: do that part fully and report back. You have not seen the conversation that led here, which is the point; read what you are given, the ticket, its scenarios, and the repository, and rely on nothing else.") + "`n`n")
    [void]$body.Append("## Purpose`n`n" + (Get-Wrapped $purpose) + "`n`n")
    [void]$body.Append("## What you own`n`n")
    foreach ($o in @($d.owns)) { [void]$body.Append("- $(Get-Oneline $o)`n") }
    [void]$body.Append("`n## What you do not own`n`n")
    foreach ($o in @($d.does_not_own)) { [void]$body.Append("- $(Get-Oneline $o)`n") }
    [void]$body.Append("`n## Guidance`n`nRead these guidance sets before starting; each is one file, installed beside the skills:`n`n")
    foreach ($s in $sets) { [void]$body.Append("- ``$guidancePath/$s.md```n") }
    [void]$body.Append("`n## Plugin skills`n`n")
    [void]$body.Append((Get-Wrapped "Where a plugin skill is installed whose frontmatter attaches it to one of this discipline's steps ($(($stepIds | ForEach-Object { $_ }) -join ', ')), use it for the part of the work it covers. Plugins bring no agents of their own.") + "`n`n")
    [void]$body.Append("## Report`n`n")
    [void]$body.Append((Get-Wrapped "Return what you did, what you found with its evidence (file and line, the command and its output), and anything you could not check and why. Change nothing the step did not ask you to change, and commit nothing.") + "`n")
    $expected["$name.md"] = $body.ToString()
}

$problems = [System.Collections.Generic.List[string]]::new()
$existing = if (Test-Path -Path $agentsDir) { Get-ChildItem -Path $agentsDir -Filter '*.md' } else { @() }
foreach ($file in $existing) {
    if (-not $expected.ContainsKey($file.Name)) { $problems.Add("agents/$($file.Name) is not generated from any discipline; remove it") }
}
foreach ($file in $expected.Keys) {
    $path = Join-Path -Path $agentsDir -ChildPath $file
    $current = if (Test-Path -Path $path) { (Get-Content -Path $path -Raw) -replace "`r`n", "`n" } else { $null }
    if ($current -ne $expected[$file]) {
        if ($Check) { $problems.Add("agents/$file differs from what the workflow data generates; run scripts/Sync-Agents.ps1") }
        else {
            New-Item -ItemType Directory -Path $agentsDir -Force | Out-Null
            [System.IO.File]::WriteAllText($path, $expected[$file])
            Write-Host "Wrote agents/$file"
        }
    }
}
if ($Check) { return $problems }
foreach ($p in $problems) { Write-Warning $p }
