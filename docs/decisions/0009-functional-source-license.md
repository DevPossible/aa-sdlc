# 0009: The framework is licensed under the Functional Source License, converting to Apache 2.0

**Date:** 2026-09-22 | **Status:** accepted | **Ticket:** none

## Context

The repository is mirrored to GitHub and the site links it, so a licence had to be chosen
(design section 12). The user's constraints: commercial use by adopters is welcome, including
consultancies running client work on the framework; a hard fork that becomes a rival AA-SDLC is
not. The sibling projects use Apache 2.0 (power-stub) and MIT (DesktopPossible), both of which
permit that fork.

## Options

- **A. Functional Source License 1.1 with Apache 2.0 as the future licence (FSL-1.1-ALv2).**
  Any use except a competing one: offering the software as a substitute for the licensor's
  product. Each version becomes Apache 2.0 two years after release. Chosen.
- **B. Apache 2.0 or MIT.** Permits the rival fork outright; Apache's trademark clause only
  forces a rename.
- **C. AGPL 3.0.** Keeps forks open but does not stop an open rival, and deters the commercial
  adopters the framework wants.
- **D. Creative Commons no-derivatives for the methodology text, Apache 2.0 for the code.**
  Forbids the modified copies that plugins and adaptation depend on; ideas are not covered by
  copyright anyway.

## Decision

Option A. `LICENSE.md` at the repository root carries the FSL-1.1-ALv2 text with DevPossible
LLC as licensor and 2026 as the notice year. The npm packages declare `FSL-1.1-ALv2` as their
SPDX licence, and `pack.ps1` copies the licence into every package. The name AA-SDLC is treated
as a DevPossible trademark, stated in the README; the licence itself grants no trademark rights.
The GitHub mirror goes public with this commit.

## Consequences

- Companies whose policy requires an OSI-approved licence cannot adopt the current version;
  they can adopt any version older than two years under Apache 2.0.
- The licence stops a competing product built on the code and text. It does not stop a
  re-implementation of the methodology from scratch; the trademark and being the canonical,
  maintained version are what protect against that.
- Contributions arrive under the same licence; no contributor licence agreement is set up yet.
  If outside contributions grow, revisit with a decision record.
