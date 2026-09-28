# 0017: Steps that author the framework are internal and named /aa-internal-<step>

**Date:** 2026-09-28 | **Status:** accepted | **Ticket:** none

## Context

The five authoring steps (`new-opinion`, `new-tenet`, `new-discipline`, `new-process`,
`new-step`) only work in the aa-sdlc repository, but as `/aa-fw-new-*` they sat beside
`/aa-fw-health` and `/aa-fw-init` in every user's command list and on the website's Framework
card. Consumers were being shown commands they cannot use. `extend` stays public, because it
builds extensions in the user's own project.

## Options

- **A. A step field `internal: true` that replaces the discipline code with `internal` in the
  command, `/aa-internal-<step>`; the website skips internal steps.** Chosen.
- **B. A new discipline with the code `internal`.** The steps are the Framework discipline's
  work, and a discipline would add a card and a count to the site, the opposite of hiding them.
- **C. Stop installing the authoring skills.** The repository's own `.claude/commands` would
  still work, but an installed `aa` could no longer author a framework checkout, and the
  command still has to be named something.

## Decision

A. The steps stay in the Framework discipline where they belong, the name tells a user at a
glance that the command is not for them, and typing `/aa-fw-` again lists only what the
framework does for a project.

## Consequences

This is the one exception to decision 34 in the design log, "the rule has no exceptions".
`scripts/Test-WorkflowStructure.ps1` requires `/aa-internal-<id>` for an internal step and
reserves the code `internal`; the CLI installs internal skills as `aa-internal-<step>`, removes
them with the other core skills, and refuses a plugin named `internal`; the website generator
neither lists nor counts internal steps. `docs/discipline-review.md` still lists them.
Reinstalling removes the old `aa-fw-new-*` folders, because they carry the `aa-fw-` core prefix.
