# 0020: Every release, prereleases included, is published as latest on npm

**Date:** 2026-09-29 | **Status:** accepted | **Ticket:** none

## Context

Decision record 0016 published a prerelease under its own dist-tag (`alpha`), so a plain
`npm install aa-sdlc` never picked one by accident. Every release so far is a prerelease, so
`latest` stayed on the first one, published by hand, and anyone installing without `@alpha` got
the oldest version. Trusted publishing lets the release workflow publish without a token, but it
cannot move a dist-tag afterwards; that needs an interactive npm sign-in.

## Options

- **A. Publish every release with `--tag latest`.** Chosen.
- **B. Keep `alpha` and move `latest` by hand after each release.** A manual step on every
  release, which is exactly what the tokenless pipeline was built to remove.
- **C. Stop marking releases as prereleases.** The version would claim a stability the
  framework does not yet have.

## Decision

A. While the framework is in alpha there is no stable line to protect, so the newest release is
the one to install. The GitHub Release is still marked a prerelease.

## Consequences

- `npm install -g aa-sdlc` installs the newest release; the README and the website say so.
- This supersedes the dist-tag part of 0016 only. When a stable line exists, prereleases will
  need their own tag again, and moving it will need either a token or a manual step.
- The `alpha` dist-tag stops moving at 0.1.0-alpha.3; removing it needs an npm sign-in
  (`npm dist-tag rm aa-sdlc alpha`).
