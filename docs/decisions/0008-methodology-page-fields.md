# 0008: The generated methodology page drops the old page's actors and tooling and keeps the rest

**Date:** 2026-09-22 | **Status:** accepted | **Ticket:** none

## Context

The website's `docs/workflow.md` and the `workflow.html` rendered from it carry, per step,
**Actors**, **Reference Sources**, and **Tooling**. The step YAML has none of these fields, and
the old tooling lists name products, which is exactly what T-01 forbids in core. Plan task M1
asks what the generated page loses and keeps before the generator is written.

## Options

- **A. Drop tooling and actors; render what the step YAML holds; keep `docs/workflow.md` in the
  website repository as the historical record of the pre-SDK methodology and say so on the
  page.** Chosen.
- **B. Add `actors:` and `tooling:` to all 52 step YAML files so the page can keep them.**
  Tooling in core would violate T-01 on its face; actors name people and roles, which T-13 says
  the framework never assumes. Rejected explicitly.
- **C. Keep the old page alongside a new one.** Two methodology pages that disagree.

## Decision

Option A. The generated page renders, per step: name, discipline, command, summary, anchor,
inputs, artifacts with their acceptance criteria, guidance expanded from the step's guidance
sets plus its own, and the tenets and opinions it cites, with a callout naming the skill's
path in the package. Per process: name, summary, the ordered steps, and the exit condition. Per
discipline: code, purpose, and what it owns.

Not rendered, and why: **Tooling** (T-01: the agent infers tools from the project, and the
framework names categories only); **Actors** (T-13: the discipline is the actor, and the same
steps serve one person or fifteen); **Reference Sources** (folded into each step's inputs where
the workflow data carries them, otherwise gone). The old page's **Success Metrics** section is
not part of the workflow data and is dropped; the business case page is where measurable
claims belong, with their assumptions (T-07).

## Consequences

- The website repository keeps `docs/workflow.md` unchanged, labelled the historical record,
  and the methodology page links nothing to it because it is not served; it names it.
- Anyone who misses actors or tooling on the new page is pointed at the tenets that removed
  them, on the page itself.
