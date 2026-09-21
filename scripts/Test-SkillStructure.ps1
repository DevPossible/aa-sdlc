#Requires -Version 7.0
<#
.SYNOPSIS
    Validates the structure of the SDK content package.
.DESCRIPTION
    Checks every skill folder under src/aasdlc/skills has a SKILL.md whose frontmatter
    'name' matches the folder and whose 'description' is present. Returns the list of
    problems found; an empty list means the package is valid.
.PARAMETER SourceRoot
    Path to the SDK content package. Defaults to src/aasdlc relative to the repo root.
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]$SourceRoot = (Join-Path $PSScriptRoot '..' 'src' 'aasdlc')
)

$ErrorActionPreference = 'Stop'
$problems = [System.Collections.Generic.List[string]]::new()

$skillsDir = Join-Path $SourceRoot 'skills'
if (-not (Test-Path $skillsDir)) {
    $problems.Add("Missing skills directory: $skillsDir")
    return $problems
}

$skillFolders = Get-ChildItem -Path $skillsDir -Directory
if ($skillFolders.Count -eq 0) {
    Write-Warning 'No skills defined yet.'
}

foreach ($folder in $skillFolders) {
    $skillFile = Join-Path $folder.FullName 'SKILL.md'
    if (-not (Test-Path $skillFile)) {
        $problems.Add("$($folder.Name): missing SKILL.md")
        continue
    }

    $content = Get-Content $skillFile -Raw
    if ($content -notmatch '(?s)^---\r?\n(.*?)\r?\n---') {
        $problems.Add("$($folder.Name): SKILL.md has no frontmatter")
        continue
    }
    $frontmatter = $Matches[1]

    if ($frontmatter -match '(?m)^name:\s*(.+?)\s*$') {
        if ($Matches[1] -ne $folder.Name) {
            $problems.Add("$($folder.Name): frontmatter name '$($Matches[1])' does not match folder")
        }
    }
    else {
        $problems.Add("$($folder.Name): frontmatter missing 'name'")
    }

    if ($frontmatter -notmatch '(?m)^description:\s*\S') {
        $problems.Add("$($folder.Name): frontmatter missing 'description'")
    }
}

return $problems
