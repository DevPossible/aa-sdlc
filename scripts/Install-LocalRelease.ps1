#Requires -Version 7.0
<#
.SYNOPSIS
    Packs a release candidate and installs its aa binary for the current user, without npm.
.DESCRIPTION
    Runs pack.ps1 with the version given, which builds, runs every test tier, and writes the npm
    tarballs to .dist/npm. It then takes this platform's tarball, the exact artifact a release
    would publish, extracts bin/aa from it into a per-user folder, and puts that folder on the
    user's PATH. Nothing is fetched from or published to a registry.

    Run it again with a later version to replace the candidate. Run it with -Uninstall before
    installing the real package from npm, so the two do not shadow each other on the PATH.
.PARAMETER Version
    The version to stamp, such as 0.1.0-rc.2. Defaults to 0.1.0-rc.1.
.PARAMETER SkipTests
    Pack without running the tests.
.PARAMETER InstallDir
    Where the binary goes. Defaults to %LOCALAPPDATA%\Programs\aa-sdlc\bin on Windows and
    ~/.local/share/aa-sdlc/bin elsewhere.
.PARAMETER Uninstall
    Remove the installed binary and take its folder off the user's PATH.
.EXAMPLE
    ./scripts/Install-LocalRelease.ps1 -Version 0.1.0-rc.1
.EXAMPLE
    ./scripts/Install-LocalRelease.ps1 -Uninstall
#>
[CmdletBinding()]
param(
    [Parameter()]
    [ValidatePattern('^\d+\.\d+\.\d+(-[0-9A-Za-z.-]+)?$')]
    [string]$Version = '0.1.0-rc.1',

    [Parameter()]
    [switch]$SkipTests,

    [Parameter()]
    [string]$InstallDir,

    [Parameter()]
    [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'

$repo = (Resolve-Path (Join-Path -Path $PSScriptRoot -ChildPath '..')).Path
if (-not $InstallDir) {
    $InstallDir = if ($IsWindows) {
        Join-Path -Path $env:LOCALAPPDATA -ChildPath 'Programs' -AdditionalChildPath 'aa-sdlc', 'bin'
    } else {
        Join-Path -Path $HOME -ChildPath '.local' -AdditionalChildPath 'share', 'aa-sdlc', 'bin'
    }
}
$exeName = if ($IsWindows) { 'aa.exe' } else { 'aa' }
$pathSeparator = [IO.Path]::PathSeparator

function Get-UserPathEntry {
    $current = if ($IsWindows) { [Environment]::GetEnvironmentVariable('Path', 'User') } else { $env:PATH }
    return @($current -split [regex]::Escape($pathSeparator) | Where-Object { $_ })
}

function Set-UserPathEntry {
    param([string[]]$Entries)
    if ($IsWindows) {
        [Environment]::SetEnvironmentVariable('Path', ($Entries -join $pathSeparator), 'User')
    }
}

if ($Uninstall) {
    if (Test-Path -Path $InstallDir) {
        Remove-Item -Path $InstallDir -Recurse -Force
        Write-Host "Removed $InstallDir" -ForegroundColor Green
    }
    $entries = Get-UserPathEntry
    if ($entries -contains $InstallDir) {
        Set-UserPathEntry -Entries @($entries | Where-Object { $_ -ne $InstallDir })
        Write-Host "Took $InstallDir off the user PATH; open a new terminal for it to apply" -ForegroundColor Green
    }
    return
}

# Build, test, and pack exactly as a release would.
$packArgs = @{ Version = $Version }
if ($SkipTests) { $packArgs.SkipTests = $true }
& (Join-Path -Path $repo -ChildPath 'pack.ps1') @packArgs

# This platform's package, in npm's naming.
$os = if ($IsWindows) { 'win32' } elseif ($IsMacOS) { 'darwin' } else { 'linux' }
$arch = switch ([Runtime.InteropServices.RuntimeInformation]::OSArchitecture) {
    'X64' { 'x64' }
    'Arm64' { 'arm64' }
    default { throw "no aa build for architecture $_" }
}
$tarball = Join-Path -Path $repo -ChildPath '.dist' -AdditionalChildPath 'npm', "aa-sdlc-cli-$os-$arch-$Version.tgz"
if (-not (Test-Path -Path $tarball)) {
    throw "pack.ps1 did not produce $tarball"
}

# Extract bin/aa from the packed artifact, so what is installed is what would be published.
$staging = Join-Path -Path ([IO.Path]::GetTempPath()) -ChildPath "aa-sdlc-rc-$([guid]::NewGuid())"
New-Item -ItemType Directory -Path $staging -Force | Out-Null
try {
    & tar -xzf $tarball -C $staging
    if ($LASTEXITCODE -ne 0) { throw "could not extract $tarball" }
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    $target = Join-Path -Path $InstallDir -ChildPath $exeName
    try {
        Copy-Item -Path (Join-Path -Path $staging -ChildPath 'package' -AdditionalChildPath 'bin', $exeName) -Destination $target -Force
    } catch {
        throw "could not replace $target; close any terminal still running aa and try again ($_)"
    }
    if (-not $IsWindows) { & chmod +x $target }
} finally {
    Remove-Item -Path $staging -Recurse -Force -ErrorAction SilentlyContinue
}

# Confirm the installed binary is the candidate just packed.
$reported = & $target version
if ($reported -notmatch [regex]::Escape("aa $Version ")) {
    throw "installed binary reports '$reported', not version $Version"
}
Write-Host "Installed $reported" -ForegroundColor Green
Write-Host "  at $target"

if ((Get-UserPathEntry) -notcontains $InstallDir) {
    if ($IsWindows) {
        Set-UserPathEntry -Entries (@(Get-UserPathEntry) + $InstallDir)
        Write-Host "Added $InstallDir to the user PATH; open a new terminal to use aa" -ForegroundColor Yellow
    } else {
        Write-Host "Add $InstallDir to PATH in your shell profile to use aa" -ForegroundColor Yellow
    }
}
