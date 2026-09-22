#Requires -Version 7.0
<#
.SYNOPSIS
    Versions, builds, tests, cross-compiles the aa CLI, and produces the npm packages in .dist/.
.DESCRIPTION
    The root pack script required by opinion O-06. Runs build (which embeds the content package
    into the CLI) and the tests, then compiles the CLI once per platform target and assembles
    one npm package per platform (@aa-sdlc/cli-<os>-<arch>, holding only its binary) plus the
    aa-sdlc package that lists them as optional dependencies and carries the launcher. Every
    package is packed to a tarball in .dist/npm/. The artifact is built once here and published
    as is; nothing is rebuilt for a later environment (O-24, decision record 0004).
.PARAMETER Version
    The semantic version to stamp. Defaults to the last tag's patch plus one, or 0.1.0.
.PARAMETER SkipTests
    Skip ./test.ps1.
.PARAMETER Targets
    Platform targets as <goos>/<goarch>. Defaults to the six the package ships.
.EXAMPLE
    ./pack.ps1
    ./pack.ps1 -Version 0.2.0 -SkipTests
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]$Version,

    [Parameter()]
    [switch]$SkipTests,

    [Parameter()]
    [string[]]$Targets = @('windows/amd64', 'windows/arm64', 'darwin/amd64', 'darwin/arm64', 'linux/amd64', 'linux/arm64')
)

$ErrorActionPreference = 'Stop'
$DistDir = Join-Path -Path $PSScriptRoot -ChildPath '.dist'
$CliDir = Join-Path -Path $PSScriptRoot -ChildPath 'src' -AdditionalChildPath 'aa-sdlc-cli'
$NpmSource = Join-Path -Path $CliDir -ChildPath 'npm' -AdditionalChildPath 'aa-sdlc'

# node's names for what Go calls the platform
$NodeOS = @{ windows = 'win32'; darwin = 'darwin'; linux = 'linux' }
$NodeArch = @{ amd64 = 'x64'; arm64 = 'arm64' }

function Get-NextVersion {
    $lastTag = git describe --tags --abbrev=0 2>$null
    if ($lastTag) {
        $current = [Version]($lastTag -replace '^v', '')
        return "$($current.Major).$($current.Minor).$($current.Build + 1)"
    }
    return '0.1.0'
}

function New-PlatformPackage {
    param([string]$GoOS, [string]$GoArch, [string]$Commit)

    $nodeName = "$($NodeOS[$GoOS])-$($NodeArch[$GoArch])"
    $pkgName = "@aa-sdlc/cli-$nodeName"
    $pkgDir = Join-Path -Path $DistDir -ChildPath 'npm' -AdditionalChildPath 'staging', "cli-$nodeName"
    $binDir = Join-Path -Path $pkgDir -ChildPath 'bin'
    New-Item -ItemType Directory -Path $binDir -Force | Out-Null
    $exe = if ($GoOS -eq 'windows') { 'aa.exe' } else { 'aa' }

    $ldflags = "-s -w -X aasdlc.com/aa/internal/version.Version=$Version -X aasdlc.com/aa/internal/version.Commit=$Commit -X aasdlc.com/aa/internal/version.BuildDate=$(Get-Date -Format 'o')"
    Push-Location $CliDir
    try {
        $env:CGO_ENABLED = '0'; $env:GOOS = $GoOS; $env:GOARCH = $GoArch
        & go build -trimpath -ldflags $ldflags -o (Join-Path -Path $binDir -ChildPath $exe) ./cmd/aa
        if ($LASTEXITCODE -ne 0) { throw "go build failed for $GoOS/$GoArch" }
    } finally {
        Remove-Item Env:GOOS, Env:GOARCH -ErrorAction SilentlyContinue
        Pop-Location
    }

    $manifest = [ordered]@{
        name        = $pkgName
        version     = $Version
        description = "The aa CLI binary for $nodeName. Installed by the aa-sdlc package as an optional dependency; installable on its own."
        license     = 'SEE LICENSE IN https://aasdlc.com'
        homepage    = 'https://aasdlc.com'
        os          = @($NodeOS[$GoOS])
        cpu         = @($NodeArch[$GoArch])
        bin         = @{ aa = "bin/$exe" }
        files       = @("bin/$exe")
    }
    $manifest | ConvertTo-Json -Depth 5 | Set-Content -Path (Join-Path -Path $pkgDir -ChildPath 'package.json') -Encoding utf8
    return $pkgDir
}

Push-Location $PSScriptRoot
try {
    if (-not $Version) {
        $Version = Get-NextVersion
        Write-Host "Auto-detected version: $Version" -ForegroundColor Yellow
    }

    if (Test-Path $DistDir) { Remove-Item -Path $DistDir -Recurse -Force }
    New-Item -ItemType Directory -Path (Join-Path -Path $DistDir -ChildPath 'npm') -Force | Out-Null

    & ./build.ps1 -Version $Version
    if (-not $SkipTests) { & ./test.ps1 }

    $commit = (git rev-parse HEAD 2>$null)
    $stagingDirs = @()
    foreach ($t in $Targets) {
        $goos, $goarch = $t -split '/'
        Write-Host "Building $goos/$goarch..." -ForegroundColor Cyan
        $stagingDirs += New-PlatformPackage -GoOS $goos -GoArch $goarch -Commit $commit
    }

    # The aa-sdlc package: launcher + manifest with the version stamped into every optional dependency
    $mainDir = Join-Path -Path $DistDir -ChildPath 'npm' -AdditionalChildPath 'staging', 'aa-sdlc'
    New-Item -ItemType Directory -Path (Join-Path -Path $mainDir -ChildPath 'bin') -Force | Out-Null
    & node --check (Join-Path -Path $NpmSource -ChildPath 'bin' -AdditionalChildPath 'aa.js')
    if ($LASTEXITCODE -ne 0) { throw 'the npm launcher bin/aa.js does not parse' }
    Copy-Item -Path (Join-Path -Path $NpmSource -ChildPath 'bin' -AdditionalChildPath 'aa.js') -Destination (Join-Path -Path $mainDir -ChildPath 'bin')
    Copy-Item -Path (Join-Path -Path $NpmSource -ChildPath 'README.md') -Destination $mainDir
    $manifest = Get-Content -Path (Join-Path -Path $NpmSource -ChildPath 'package.json') -Raw | ConvertFrom-Json
    $manifest.version = $Version
    foreach ($dep in @($manifest.optionalDependencies.PSObject.Properties.Name)) { $manifest.optionalDependencies.$dep = $Version }
    $manifest | ConvertTo-Json -Depth 5 | Set-Content -Path (Join-Path -Path $mainDir -ChildPath 'package.json') -Encoding utf8
    $stagingDirs += $mainDir

    $npmOut = Join-Path -Path $DistDir -ChildPath 'npm'
    foreach ($dir in $stagingDirs) {
        & npm pack --silent --pack-destination $npmOut $dir | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "npm pack failed for $dir" }
    }
    Remove-Item -Path (Join-Path -Path $npmOut -ChildPath 'staging') -Recurse -Force

    @{ Version = $Version; BuildDate = (Get-Date -Format 'o'); GitCommit = $commit; Targets = $Targets } |
        ConvertTo-Json | Set-Content -Path (Join-Path -Path $DistDir -ChildPath 'version.json')

    Write-Host 'Packaging complete:' -ForegroundColor Green
    Get-ChildItem -Path $npmOut -Filter '*.tgz' | ForEach-Object { Write-Host "  $($_.Name) ($([math]::Round($_.Length / 1MB, 1)) MB)" }
} finally { Pop-Location }
