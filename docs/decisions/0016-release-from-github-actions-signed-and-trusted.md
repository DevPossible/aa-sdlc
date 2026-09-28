# 0016: Releases publish from GitHub Actions, signed by Azure and trusted by npm without tokens

**Date:** 2026-09-27 | **Status:** accepted | **Ticket:** none

## Context

The `aa` CLI is ready for an alpha on npm as `aa-sdlc`. The organisation's other packages publish
from GitHub Actions on the public mirror (a push to `main` in the mirror runs the publish), with an
npm token as a repository secret; that token has since been revoked, as npm revoked long-lived
tokens. The Windows binaries should carry an Authenticode signature from the organisation's Azure
Trusted Signing account, as DesktopPossible's do. The account's npm sign-in uses a passkey, which no
pipeline can present. The CI runners on the origin do not pick up jobs.

## Options

- **A. GitHub Actions on the mirror, triggered by `version.json` on `main`; tests on Linux, macOS,
  and Windows; one Windows job packs, signs through an Azure app federated to that job by OIDC, and
  publishes with npm trusted publishing and provenance; the first release is published by hand.**
  Chosen.
- **B. The same, with an npm token as a secret.** Tokens now expire and are revoked; one had
  already stopped working unnoticed.
- **C. Publish from a workstation, as DesktopPossible signs.** Works today and repeats the manual
  step every release, with no provenance.

## Decision

Option A.

- Platform packages are `@devpossible/aa-sdlc-cli-<os>-<arch>` in the organisation's npm scope;
  the main package is `aa-sdlc`. A prerelease version publishes under its own dist-tag (`alpha`),
  so `npm install -g aa-sdlc` never picks one by accident.
- `pack.ps1 -Sign` signs each Windows binary before it is packed and verifies the signature. The
  Azure app `github-aa-sdlc-release` has a federated credential for the `release` environment of
  `DevPossible/aa-sdlc` only, which only protected branches may use, and holds only the Artifact
  Signing Certificate Profile Signer role on the `CodeSigning` profile. No secret exists.
- npm trusts the workflow `release.yml` in `DevPossible/aa-sdlc` for each package. Trusted
  publishing needs the package to exist, so the first version of each is published by hand with
  the organisation's sign-in; the workflow publishes nothing while `aa-sdlc` is absent from npm.
- `workflow_dispatch` runs a dry run by default: every test, the Azure sign-in, and the signing,
  without publishing.

## Consequences

- The workflow file is public and names nothing internal.
- Each release is a `version.json` change on the origin's `main`, mirrored to GitHub.
- macOS binaries are not signed: that needs an Apple Developer ID, not Azure.
- The organisation's other npm packages need the same move to trusted publishing; their token is
  dead.
