# 0005: CLI scenarios run with godog against the built binary; agent scenarios stay contracts

**Date:** 2026-09-22 | **Status:** accepted | **Ticket:** none

## Context

The framework's requirements are feature files (O-01, T-12) and until now none of them
executed, so R-17 was unmet for the framework itself and O-07's integration and e2e tiers were
empty folders. Decision 0004 ruled out Node, so a JavaScript runner is not an option. Some
scenarios describe the CLI, which can be driven black-box; some describe what an agent does
when it runs a skill, which no test harness can drive today; some describe health probes.
Plan task E1.

## Options

- **A. godog, a Go feature-file runner, in a test module under `tests/integration/`, driving
  the built `aa` binary.** Same language as the CLI, Gherkin executed as written, black-box.
  Chosen.
- **B. Pester step definitions in PowerShell.** Pester dropped Gherkin support in version 5;
  a home-grown runner would be a project of its own (O-20).
- **C. No executor; the feature files stay a readable contract.** Leaves R-17 unmet and the
  tiers empty with no path to change.

## Decision

Option A, with every feature tagged by what can execute it:

| Tag | Meaning | Executed by |
|-----|---------|-------------|
| `@cli` | drives the `aa` binary | godog in `tests/integration/`, integration tier |
| `@health` | a requirement probe performed by `/aa-fw-health` | the health baseline in the development environment document, checked for completeness by the e2e tier |
| `@agent` | what an agent does when it runs a skill; a contract | not executed; reviewed |

Steps for verbs that are not implemented yet (`aa update`, `aa plugin`) are left undefined and
reported as such; the suite is not strict, so undefined steps are counted, not failed. The e2e
tier installs the packed npm tarballs into a temporary prefix and runs `aa setup` and `aa init`
on a fresh repository, the way a user would. The feature structure validator requires exactly
one of the three tags on every feature.

## Consequences

- R-17 is met for the `@cli` subset; the development environment document says which subset.
- `test.ps1 -Tier integration` builds the binary if needed and runs godog; `-Tier e2e` needs
  the packed tarballs and runs Pester.
- The CLI grows two test hooks: an `AA_HOME` environment variable that relocates the user home
  for detection and the user config, and an `-interactive` flag on `aa init` that allows
  prompting when stdin is a pipe. Neither changes behaviour for a user who does not set them.
- `@agent` scenarios become executable only when an agent harness exists; that is not planned.
