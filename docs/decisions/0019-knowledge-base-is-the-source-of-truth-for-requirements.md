# 0019: The knowledge base is the source of truth for requirements; feature files are pulled from it

**Date:** 2026-09-28 | **Status:** accepted | **Ticket:** none

## Context

T-12 made the repository's feature files the source of truth and promised tooling that would
keep the ticket and the knowledge base page in step. No such tooling existed, and the business
analysis steps wrote only feature files. On a real project the whole of discovery ended up in
the repository, where business analysts and product managers, who do not work in source
control, could neither read nor change it; the ticket system and the knowledge base stayed
empty. The ticket system and knowledge base may also be shared with other teams (T-14).

## Options

- **A. The knowledge base holds each feature as a page of structured tables; feature files are
  generated from the pages per ticket, with a provenance header; review catches any feature file
  not generated from a page.** Chosen.
- **B. Keep the repository as the truth and publish pages from it.** The people who own the
  requirements would still have to change them through source control, or their edits would be
  overwritten.
- **C. Gherkin verbatim in a code block on each page.** Exact and simple, but a wall of syntax to
  the people the page is for; tables read as a document and still convert mechanically.

## Decision

A. A feature page is readable and editable by anyone who can use the knowledge base, and the
conversion both ways is a script, not an agent's judgement, so it is exact. The provenance
header's checksum lets a pre-commit hook and the pipeline catch a hand edit without reaching the
knowledge base. A project with no knowledge base keeps the pages in its documents folder in the
same format, so adopting one later is an upload. The framework's own repository follows the
same rule, with its pages in `docs/knowledge/`.

## Consequences

- T-12 is rewritten; T-14 is added. The page format is specified in `docs/formats.md`.
- `src/aa-sdlc/scripts/` holds `AaFeatures.psm1` (convert both ways, checksum),
  `Sync-FeatureFiles.ps1` (pull from a documents-folder knowledge base, `-Check` for the gate),
  `Test-FeatureProvenance.ps1` (the gate for any knowledge base), and
  `ConvertTo-KnowledgePages.ps1` (seed pages from existing feature files).
- A scenario on a page is Draft, Approved, or Retired; only Approved scenarios reach the
  repository. Stable ids are assigned on the page.
- Every anchored step begins by pulling the features its ticket links to; discovery and
  refinement write pages and tickets, not feature files; review and `finish-branch` run the gate;
  a change found while building is proposed back to the page.
- R-03 becomes required, satisfied by the documents folder where no knowledge base is in scope.
