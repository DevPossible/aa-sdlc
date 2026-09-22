# 0001: This repository adopts the AA-SDLC framework for itself

**Date:** 2026-09-22 | **Status:** accepted | **Ticket:** none

## Context

The aa-sdlc repository defines the framework: tenets, opinions, guidance, requirements, and the
workflow data. Decision 21 in the design says the framework dogfoods T-12; decision 28 says it
adopts O-05, O-06, and O-07. Opinions O-08 to O-25 were added on 2026-09-21 and the repository
did not yet meet several of them (R-07, R-32, R-35, R-39). The first thing `/aa-fw-health` will
be run against is this repository.

## Options

- **A. Adopt the framework in full, now.** Everything a consumer repository must have, this one
  has, with not-applicable items recorded as such. Chosen.
- **B. Exempt the framework repository.** Faster, but every gap health finds here would be
  argued away, and the framework would be asking consumers to do what it does not.
- **C. Adopt piecemeal as each skill is written.** Spreads the work but leaves health reporting
  unexplained failures for months.

## Decision

Option A. This repository is a consumer of the framework as well as its source. Its project
config, decision records, lint switch, and development environment configuration are written
now (plan tasks B1 to B4), and anything the framework requires that does not apply here is
recorded in the development environment configuration with the reason, so health reports it as
not applicable rather than unmet.

## Consequences

- `docs/decisions/` starts here and is the decision record location for this repository
  (R-32). The design's decision log remains the design's own history and is not migrated.
- `aa.config.yaml` at the root names the ticket project, knowledge base, commit format, and
  decisions folder (R-07, R-22, R-28).
- `build.ps1 -Lint` runs the formatter check and analyser for PowerShell (R-35).
- `docs/development-environment.md` records the tooling per language and the requirements that
  do not apply (R-12, R-30, R-39).
- The health baseline (plan task C4) must show no unmet requirement this plan does not address.
