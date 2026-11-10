# 0022: Opt into integration-branch full-suite checkpoints

**Date:** 2026-11-10 | **Status:** accepted | **Ticket:** AP-413

## Context

Long full suites can delay small merges, leading projects to carry local overrides of G-04.
The framework needs a visible policy for deferred full proof without weakening the default
or labelling scoped evidence full. See the [feature page](../knowledge/Requirements/framework/checkpoint-full-suite.md).

## Options

- **Per-branch only.** Simple, but leaves useful checkpoint policies as conflicting local overrides.
- **Scoped merges without checkpoints.** Fast, but lets integration failures and full proof drift indefinitely.
- **Explicit checkpoint policy.** Keep per-branch as default; require scoped gates and named full checkpoints.

## Decision

Adopt O-29: explicit `testing.fullSuite.mode: checkpoint` moves full-suite proof to the named
integration branch before each configured event, optionally bounded by merges or elapsed days.
Every merge still proves build, lint, smoke, changed components and changed public API/schema/
shared-kernel contracts, plus provenance. Full checkpoints include full build, lint, provenance
and every tier. A later config scope replaces the entire policy to avoid accidental mixtures.

## Consequences

R-49 makes missing events and malformed policies visible to health; G-04 and finish-branch
describe both modes. G-59 remains unchanged: evidence names actual scope and outstanding proof.
Failures are fixed forward, flakes get tickets and never retry-to-green. Existing release and
installed/exposure gates remain. This supersedes only the per-branch-only timing of full-suite
proof in decision 0021; it adds no scheduler, state store, tool or team-size assumption.
