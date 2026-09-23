# 0010: The website currency check reads the website's committed HEAD, never its working tree

**Date:** 2026-09-22 | **Status:** accepted | **Ticket:** none

## Context

Decision record 0007 put a website currency check in this repository's unit tier, comparing
the generator's output with the website repository checked out beside this one. The review of
that work found that the check read the website's working tree, so an uncommitted edit, an
unsaved editor buffer, or a half-finished regeneration in the other repository changed this
repository's test result. O-23 requires tests to be deterministic and independent of state
outside the code under test; G-46 names shared state as the thing to remove.

## Options

- **A. Export `site/` from the website repository's committed HEAD into a temporary folder and
  check that.** The result depends only on which commit the website has checked out, which is
  the thing the check is meant to protect. Chosen.
- **B. Run the check only when `AA_WEBSITE_PATH` is set and have the pipeline check the website
  out at a pinned ref.** Removes the accidental coupling on developer machines but also removes
  the check from the machines where the drift happens.
- **C. A separate switch on `test.ps1`.** Same coverage loss as B, with one more thing to know.

## Decision

Option A. `scripts/Test-WebsiteCurrency.ps1` takes the website repository root, runs
`git archive HEAD site` into a temporary folder, runs the generator's check mode and the
content checks against that export, names the website commit in any stale message, and deletes
the export. The working tree is never read. The skip when no website repository is present is
unchanged, as is decision 0007's mechanism otherwise.

## Consequences

- A developer with uncommitted website changes sees the unit tier judge what they have
  committed, not what they are typing; the message names the website commit it checked.
- The check still depends on which website commit is checked out beside this repository. That
  is intended: it is how a stale committed site is caught before it is pushed.
- The generator itself still writes to the working tree, as it must.
