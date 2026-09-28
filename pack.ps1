#Requires -Version 7.0
<#
.SYNOPSIS
    Versions, builds, tests, cross-compiles the aa CLI, and produces the npm packages in .dist/.
.DESCRIPTION
    The root pack script required by opinion O-06. Runs build (which embeds the content package
    into the CLI) and the tests, then compiles the CLI once per platform target and assembles
    one npm package per platform (@devpossible/aa-sdlc-cli-<os>-<arch>, holding only its binary) plus the
    aa-sdlc package that lists them as optional dependencies and carries the launcher. Every
    package is packed to a tarball in .dist/npm/. The artifact is built once here and published
    as is; nothing is rebuilt for a later environment (O-24, decision record 0004).
.PARAMETER Version
    The semantic version to stamp. Defaults to the version in version.json, which the release
    workflow publishes (decision record 0016).
.PARAMETER Sign
    Authenticode-sign the Windows binaries with Azure Trusted Signing (account DevPossible,
    certificate profile CodeSigning) before they are packed, and verify each signature. Windows
    only, because Authenticode uses Win32 APIs. Needs an Azure sign-in holding the Artifact
    Signing Certificate Profile Signer role on the account.
.PARAMETER SignWith
    The Azure credential the sign tool uses: azure-cli (default), workload-identity, or
    managed-identity.
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
    [switch]$Sign,

    [Parameter()]
    [ValidateSet('azure-cli', 'workload-identity', 'managed-identity', 'azure-powershell')]
    [string]$SignWith = 'azure-cli',

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

# Azure Trusted Signing. None of these are secrets: access is RBAC on the Azure account, not a key
# in the repository. The endpoint's host carries the region the account was created in (eus).
$SigningEndpoint = 'https://eus.codesigning.azure.net/'
$SigningAccount = 'DevPossible'
$SigningCertificateProfile = 'CodeSigning'

function Get-NextVersion {
    $file = Join-Path -Path $PSScriptRoot -ChildPath 'version.json'
    if (Test-Path -Path $file) {
        return (Get-Content -Path $file -Raw | ConvertFrom-Json).version
    }
    return '0.1.0'
}

function Invoke-Signing {
    <#
        Authenticode-signs one file with Azure Trusted Signing through the pinned sign tool
        (.config/dotnet-tools.json), timestamped so the signature outlives the short-lived
        certificate, then verifies it rather than trusting the exit code.
    #>
    param([Parameter(Mandatory)][string]$Path)
    & dotnet sign code artifact-signing $Path `
        --artifact-signing-endpoint $SigningEndpoint `
        --artifact-signing-account $SigningAccount `
        --artifact-signing-certificate-profile $SigningCertificateProfile `
        --azure-credential-type $SignWith `
        --description 'aa, the AA-SDLC command line' `
        --description-url 'https://aasdlc.com' `
        --verbosity Warning
    if ($LASTEXITCODE -ne 0) { throw "signing failed for $Path (exit $LASTEXITCODE)" }
    $signature = Get-AuthenticodeSignature -FilePath $Path
    if ($signature.Status -ne 'Valid') { throw "signature on $Path is $($signature.Status): $($signature.StatusMessage)" }
    Write-Host "  signed $(Split-Path -Path $Path -Leaf): $($signature.SignerCertificate.Subject)" -ForegroundColor Green
}

function New-PlatformPackage {
    param([string]$GoOS, [string]$GoArch, [string]$Commit)

    $nodeName = "$($NodeOS[$GoOS])-$($NodeArch[$GoArch])"
    $pkgName = "@devpossible/aa-sdlc-cli-$nodeName"
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
        if ($Sign -and $GoOS -eq 'windows') { Invoke-Signing -Path (Join-Path -Path $binDir -ChildPath $exe) }
    } finally {
        Remove-Item Env:GOOS, Env:GOARCH -ErrorAction SilentlyContinue
        Pop-Location
    }

    Copy-Item -Path (Join-Path -Path $PSScriptRoot -ChildPath 'LICENSE.md') -Destination $pkgDir
    $manifest = [ordered]@{
        name        = $pkgName
        version     = $Version
        description = "The aa CLI binary for $nodeName. Installed by the aa-sdlc package as an optional dependency; installable on its own."
        license     = 'FSL-1.1-ALv2'
        homepage    = 'https://aasdlc.com'
        repository  = @{ type = 'git'; url = 'git+https://github.com/DevPossible/aa-sdlc.git' }
        publishConfig = @{ access = 'public' }
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

    if ($Sign) {
        if (-not $IsWindows) { throw 'pack.ps1 -Sign needs Windows: Authenticode uses Win32 APIs.' }
        & dotnet tool restore
        if ($LASTEXITCODE -ne 0) { throw 'dotnet tool restore failed (sign)' }
    }
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
    Copy-Item -Path (Join-Path -Path $PSScriptRoot -ChildPath 'LICENSE.md') -Destination $mainDir
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
