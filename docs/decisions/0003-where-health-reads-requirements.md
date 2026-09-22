# 0003: Health reads requirement definitions from feature files shipped in the package

**Date:** 2026-09-22 | **Status:** accepted | **Ticket:** none

## Context

`/aa-fw-health` probes every requirement the installed skills declare (design 3.6). The
authoritative definition of each requirement is its scenarios in `features/requirements/`
(decisions 20 and 31, O-01), and `docs/requirements.md` is only an index. Neither lived in the
content package under `src/aa-sdlc/`, so an installed health skill had nothing to resolve ids
against. Plan task C1.

## Options

- **A. Copy `features/requirements/` and the registry into the package at build time.** One
  source, no generation step, health reads Gherkin. Chosen.
- **B. Generate a `requirements.yaml` index from the registry table at build time.** Adds a
  parser for a markdown table and a second format to keep in step.
- **C. Have the skill read the registry table directly.** Makes the index the truth, which
  contradicts decision 20 and the health feature's own scenario.

## Decision

Option A. `build.ps1` copies `features/requirements/*.feature` into `<package>/requirements/`
and `docs/requirements.md` into `<package>/requirements/registry.md`. Health resolves each
declared id against the feature files: the tag on the scenario gives kind and level, the
`Given` steps of the met scenario are the probe, and the remedy lines of the unmet scenarios
are the remedy. The registry copy is a reader's index and nothing in health depends on it.
Plugins ship their own `features/requirements/` the same way (formats.md section 3).

## Consequences

- The package grows by the requirement feature files; nothing else changes for consumers.
- A requirement with no scenario cannot be probed; the unit tier already fails on an id that is
  defined but uncited, and health reports an id it cannot resolve as "undefined" rather than
  guessing.
- Writing the health skill against the feature files will show where a Given step is not
  something an agent can actually do; those scenarios get rewritten, which is the point.
