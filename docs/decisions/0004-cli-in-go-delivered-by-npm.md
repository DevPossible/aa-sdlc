# 0004: The aa CLI is a Go binary, embedded with the content package, delivered through npm

**Date:** 2026-09-22 | **Status:** accepted | **Ticket:** none

## Context

Decision 16 chose npm as the delivery channel so the CLI and the content it installs version
together. The design's open question left the CLI language as "plain Node or TypeScript". The
owner ruled out Node and TypeScript for anything in this project and named Go, Rust, or .NET as
acceptable, then chose Go. Plan task D1.

## Options

- **A. Go.** One static binary per platform, cross-compilation from one machine with
  `GOOS`/`GOARCH`, fast startup, small toolchain, `embed` for the content package. Chosen.
- **B. Rust.** Same binary story, stronger guarantees, slower to write and steeper for
  occasional contributors.
- **C. .NET native AOT.** Reuses house C# skill, but cross-compiling for other operating
  systems needs per-OS builds and a heavier toolchain.

## Decision

Option A. The CLI lives in `src/aa-sdlc-cli/` as its own Go module (O-05). At build time the
content package (`src/aa-sdlc/` plus the requirement feature files) is copied into the module
and compiled in with `embed`, so one binary carries the skills, workflow, and requirements it
installs and nothing can drift between them (decision 16's intent). `pack.ps1` cross-compiles
for windows, darwin, and linux on amd64 and arm64.

Delivery stays npm. `aa-sdlc` lists one optional dependency per platform
(`@aa-sdlc/cli-<os>-<arch>`), each holding only its binary, so npm installs the one that matches
the machine and there is no postinstall download. npm's `bin` entry must name one file that
works on every platform, and a native binary cannot be that file for all six targets, so the
main package carries one launcher, `bin/aa.js`, of about twenty lines with no dependencies,
whose only job is to exec the platform binary. It is the only JavaScript in the repository and
it exists for that mechanical reason alone; Node is present wherever npm is, so it adds no
dependency. If that single file is unacceptable, the alternatives are to make winget, scoop,
brew, or `go install` the primary channel and npm secondary; that would supersede this record.

## Consequences

- `initialize.ps1` installs the Go toolchain when missing; the Node install is gone.
- `build.ps1` builds the binary for the current platform after validating the content;
  `pack.ps1` builds all six and the npm packages.
- The design's repository layout (section 9) changes: `src/aa-sdlc/` is the content package
  only; `src/aa-sdlc-cli/` is the CLI.
- Unit tests for the CLI are Go tests in the module, run by `test.ps1 -Tier unit` (O-07).
- The open question "CLI language" in the design is closed by this record.
