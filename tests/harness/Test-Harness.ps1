#Requires -Version 7.0
#Requires -Modules powershell-yaml
<#
.SYNOPSIS
    Checks aa against every agent harness installed in the harness image (test.ps1 -Tier harness).
.DESCRIPTION
    Runs inside the image built from tests/harness/Dockerfile, with the Linux aa binary mounted at
    -Aa and the repository at -Repo. For each supported harness in the target table, in a fresh
    home and repository, it checks four things without signing in or calling a model:

    1. Detection: aa setup finds the real install.
    2. Install: aa setup -targets <id> and aa init write the skills, commands, agents, and the
       instruction-file block where the table says, and aa uninstall removes them.
    3. Evidence: the harness's own installed code names the folders and the instruction file the
       table says it reads. A literal path is "exact"; its separate names only is "segments";
       neither is "missing", which means the table is unconfirmed for that folder.
    4. Together: aa setup with every harness installed at once.

    Writes a JSON report to -Report and prints a summary. Exits non-zero when detection or
    install fails for a harness that is installed; missing evidence is reported, not fatal.
.PARAMETER Aa
    The Linux aa binary.
.PARAMETER Repo
    The repository, for src/aa-sdlc/targets/targets.yaml.
.PARAMETER Report
    Where to write the JSON report.
#>
[CmdletBinding()]
param(
    [Parameter()] [string]$Aa = '/aa/aa',
    [Parameter()] [string]$Repo = '/repo',
    [Parameter()] [string]$Report = '/out/harness-report.json'
)

$ErrorActionPreference = 'Stop'

$table = (ConvertFrom-Yaml (Get-Content -Path (Join-Path $Repo 'src/aa-sdlc/targets/targets.yaml') -Raw)).targets
$installed = @(Get-Content -Path '/harnesses.txt' | Where-Object { $_ })
$npmRoot = (& npm root -g).Trim()

# Harnesses whose installed code is compressed inside a binary, so no text search can see it
$opaque = @('amp')

# Where each harness's own code lives in the image, for the evidence search
$codeRoots = @{
    'claude-code' = @("$npmRoot/@anthropic-ai")
    'codex'       = @("$npmRoot/@openai")
    'gemini-cli'  = @("$npmRoot/@google/gemini-cli")
    'opencode'    = @("$npmRoot/opencode-ai") + @(Get-ChildItem -Path $npmRoot -Directory -Filter 'opencode-*' | ForEach-Object FullName)
    'qwen-code'   = @("$npmRoot/@qwen-code")
    'copilot'     = @("$npmRoot/@github", '/root/.cache/copilot')
    'crush'       = @("$npmRoot/@charmland")
    'amp'         = @("$npmRoot/@sourcegraph")
    'kilo'        = @("$npmRoot/@kilocode")
    'cline'       = @("$npmRoot/cline")
    'auggie'      = @("$npmRoot/@augmentcode")
    'pi'          = @("$npmRoot/@mariozechner")
    'factory'     = @("$npmRoot/droid")
    'junie'       = @("$npmRoot/@jetbrains", '/root/.local/share/junie')
    'cursor'      = @('/root/.local/share/cursor-agent')
    'goose'       = @('/root/.local/bin/goose')
    'kiro'        = @('/root/.local/bin/kiro-cli', '/root/.local/bin/kiro-cli-chat', '/root/.local/share/kiro-cli')
    'hermes'      = @('/root/.local/pipx/venvs/hermes-agent')
}

function New-Home {
    $h = Join-Path ([IO.Path]::GetTempPath()) "home-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
    New-Item -ItemType Directory -Path $h -Force | Out-Null
    return $h
}

function Invoke-Aa {
    param([string]$HomeDir, [string]$Dir, [string[]]$Arguments)
    $env:HOME = $HomeDir
    Push-Location $Dir
    try {
        $out = & $Aa @Arguments 2>&1 | Out-String
        return [pscustomobject]@{ Exit = $LASTEXITCODE; Out = $out }
    } finally { Pop-Location }
}

function Test-Evidence {
    param([string[]]$Roots, [string]$Text)
    $roots = @($Roots | Where-Object { Test-Path $_ })
    if ($roots.Count -eq 0) { return 'not searched' }
    $hit = & grep -rasFl -m1 -- $Text @roots 2>$null | Select-Object -First 1
    if ($hit) { return 'exact' }
    # Java harnesses keep their code in .jar archives, which a text search cannot see into
    foreach ($jar in @($roots | ForEach-Object { Get-ChildItem -Path $_ -Recurse -Filter '*.jar' -ErrorAction SilentlyContinue })) {
        # through bash, so grep -q ends unzip at the first match instead of PowerShell buffering the stream
        & bash -c 'unzip -p "$1" 2>/dev/null | grep -aqF -- "$2"' _ $jar.FullName $Text
        if ($LASTEXITCODE -eq 0) { return 'exact' }
    }
    $segments = @($Text -split '/' | Where-Object { $_ })
    foreach ($s in $segments) {
        $hit = & grep -rasFl -m1 -- "`"$s`"" @roots 2>$null | Select-Object -First 1
        if (-not $hit) { $hit = & grep -rasFl -m1 -- "'$s'" @roots 2>$null | Select-Object -First 1 }
        if (-not $hit) { return 'missing' }
    }
    return 'segments'
}

function Get-Planned([string[]]$Dirs) {
    # the folder aa plans for one harness alone: the shared folder where it reads it, else its first
    if ($Dirs -contains '.agents/skills') { return '.agents/skills' }
    return $Dirs[0]
}

$results = [System.Collections.Generic.List[object]]::new()
$failures = 0

# 4. Together first: every installed harness detected in one run
$allHome = New-Home
$together = Invoke-Aa -HomeDir $allHome -Dir $allHome -Arguments @('setup')

foreach ($t in $table) {
    if ($t.status -ne 'supported') { continue }
    $r = [ordered]@{ id = $t.id; name = $t.name; installed = ($installed -contains $t.id); detected = $null; user = $null; project = $null; uninstall = $null; evidence = [ordered]@{}; problems = @() }
    if (-not $r.installed) {
        $r.problems += 'no headless install in the image'
        $results.Add([pscustomobject]$r); continue
    }
    $problems = [System.Collections.Generic.List[string]]::new()

    # 1. Detection
    $r.detected = $together.Out -match "(?m)^  $([regex]::Escape($t.name)): "
    if (-not $r.detected) { $problems.Add('aa setup did not detect it') }

    # 2. Install at user scope
    $home1 = New-Home
    $setup = Invoke-Aa -HomeDir $home1 -Dir $home1 -Arguments @('setup', '-targets', $t.id)
    $skillDir = Get-Planned @($t.skills.user)
    $checks = @("$skillDir/aa-fw-health/SKILL.md", "$skillDir/aa-guidance/sets/every-step.md")
    if ($t.commands) {
        $ext = if ($t.commands.format -eq 'gemini-toml') { 'toml' } else { 'md' }
        $checks += "$($t.commands.user)/aa-fw-health.$ext"
    }
    if ($t.agents) { $checks += "$(@($t.agents.user)[0])/aa-dev$($t.agents.suffix)" }
    $missing = @($checks | Where-Object { -not (Test-Path (Join-Path $home1 $_)) })
    $r.user = ($setup.Exit -eq 0 -and $missing.Count -eq 0)
    foreach ($m in $missing) { $problems.Add("user scope: missing ~/$m") }

    # 2. Install at project scope, with the instruction-file block
    $repoDir = Join-Path $home1 'project'
    New-Item -ItemType Directory -Path $repoDir -Force | Out-Null
    & git -C $repoDir init -q 2>$null
    $init = Invoke-Aa -HomeDir $home1 -Dir $repoDir -Arguments @('init', '-yes', '-ticket-project', 'ABC')
    $pSkill = Get-Planned @($t.skills.project)
    $pChecks = @("$pSkill/aa-fw-health/SKILL.md")
    if ($t.commands) { $pChecks += "$($t.commands.project)/aa-fw-health.$ext" }
    if ($t.agents) { $pChecks += "$(@($t.agents.project)[0])/aa-dev$($t.agents.suffix)" }
    $pMissing = @($pChecks | Where-Object { -not (Test-Path (Join-Path $repoDir $_)) })
    foreach ($m in $pMissing) { $problems.Add("project scope: missing $m") }
    if ($t.instructions) {
        $file = Join-Path $repoDir $t.instructions
        if (-not ((Test-Path $file) -and ((Get-Content $file -Raw) -match 'aa-sdlc:begin'))) { $problems.Add("project scope: no AA-SDLC block in $($t.instructions)") }
    }
    $r.project = ($init.Exit -eq 0 -and $pMissing.Count -eq 0)

    # 2. Uninstall removes it again
    $un = Invoke-Aa -HomeDir $home1 -Dir $home1 -Arguments @('uninstall', '-targets', $t.id)
    $r.uninstall = ($un.Exit -eq 0 -and -not (Test-Path (Join-Path $home1 "$skillDir/aa-fw-health")))
    if (-not $r.uninstall) { $problems.Add('uninstall left the skills behind') }

    # 3. Evidence from the harness's own code
    $roots = $codeRoots[$t.id]
    if ($opaque -contains $t.id) { $roots = @() ; $r.evidence['code'] = 'not searchable: compressed inside its binary' }
    $folders = @($t.skills.user) + @($t.skills.project) | Select-Object -Unique
    foreach ($f in $folders) { $r.evidence["skills: $f"] = Test-Evidence -Roots $roots -Text $f }
    if ($t.commands) { $r.evidence["commands: $($t.commands.project)"] = Test-Evidence -Roots $roots -Text $t.commands.project }
    if ($t.agents) { $r.evidence["agents: $(@($t.agents.project)[0])"] = Test-Evidence -Roots $roots -Text @($t.agents.project)[0] }
    if ($t.instructions) { $r.evidence["instructions: $($t.instructions)"] = Test-Evidence -Roots $roots -Text $t.instructions }

    $r.problems = @($problems)
    if ($problems.Count -gt 0) { $failures++ }
    $results.Add([pscustomobject]$r)
}

New-Item -ItemType Directory -Path (Split-Path $Report) -Force | Out-Null
[pscustomobject]@{ together = $together.Out; harnesses = $results } | ConvertTo-Json -Depth 5 | Set-Content -Path $Report

foreach ($r in $results) {
    $status = if (-not $r.installed) { 'not installable here' } elseif ($r.problems.Count -eq 0) { 'install passed' } else { 'install FAILED' }
    $exact = @($r.evidence.Values | Where-Object { $_ -eq 'exact' }).Count
    $total = $r.evidence.Count
    Write-Host ('{0,-16} {1,-22} evidence {2}/{3} exact' -f $r.id, $status, $exact, $total)
    foreach ($p in $r.problems) { Write-Host "    - $p" }
    foreach ($k in $r.evidence.Keys) { if ($r.evidence[$k] -ne 'exact') { Write-Host ("    {0}: {1}" -f $k, $r.evidence[$k]) } }
}
exit $failures
