---
name: breakdown-tasks
description: "When a confirmed plan is too large to build as one change, split it into tasks on the ticket, each independently buildable and testable, with their order and dependencies."
aa:
  discipline: implementation-planning
  step: breakdown-tasks
  guidance_sets: [every-step, anchored-step]
  guidance: [G-08, G-52]
  requires: [R-41, R-43]
---

# /aa-ip-breakdown-tasks

When a confirmed plan is too large to build as one change, split it into tasks on the ticket, each independently buildable and testable, with their order and dependencies.

## Anchor

Anchor first (G-22). Read the ticket, linked scenarios and knowledge page; check requirement currency under G-54. Pull instructions below apply only when the snapshot changed or currency is unknown. If no ticket system is reachable, record the anchor and artifacts locally, say so, and continue (T-05, T-10).

## Inputs

- The confirmed implementation plan

## Procedure

1. **Anchor and check currency.** Pull the feature pages the ticket links to (G-54): their
   Approved scenarios into the features folder as feature files with their provenance header.
   With a documents-folder knowledge base run `scripts/aa-sdlc/Sync-FeatureFiles.ps1
   -KnowledgeRoot <folder> -FeaturesRoot <features>`; with a knowledge base, read each page and
   convert it with `ConvertFrom-FeaturePage` from `scripts/aa-sdlc/AaFeatures.psm1`. Read the
   ticket, its scenarios, and the confirmed implementation plan (G-22). Compare the page versions
   the plan records with the pages' current versions, and the repository at the revision the
   plan records with the head, filtered to the linked feature files and the files the plan
   names, and record the result on the ticket. If a scenario or a planned file moved, the plan
   goes back to plan-implementation before it is split (O-13).
2. **Confirm there is something to split.** An unconfirmed plan is not split; it returns to
   plan-implementation. A plan small enough to build as one change is left whole, and the ticket
   says so; this step exists for the plan that is too large for one change.
3. **Cut the plan into tasks.** Each task maps to one or more plan steps, is independently
   buildable and testable, and names the test that proves it. Keep each at a size where the
   first commit is an hour away, not a day; a task whose test cannot be named is not yet a task.
4. **Order the tasks and record their dependencies.** The plan's build order becomes the task
   order, so that stopping after any task leaves the system working (G-08). Where one task needs
   another first, record it as a link or an ordered checklist entry, not as prose.
5. **Check the sum.** Walk the plan step by step and confirm every step is covered by a task and
   no task covers work the plan does not name. A gap is a new task or a change to the plan on
   the ticket, never a note in the conversation.
6. **Create the tasks** in the ticket system, as children or a checklist of the anchor ticket as
   the project config names (G-25), each linked back to the ticket and to the plan steps it
   covers (G-26). State on each what done means: its test passes and its change is committed,
   not that its code exists.
7. **Update the ticket.** Record on the ticket the tasks, their order and dependencies, the
   revision they were cut against, and what remains (G-12). Then report.

## Artifacts

**Tasks** in the ticket system, as children or a checklist of the anchor ticket. Done when:

- Each task maps to one or more plan steps and names its test
- Order and dependencies are explicit
- The sum of the tasks is the whole plan; nothing is left implicit

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first and check requirement currency, update the ticket at meaningful checkpoints, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-08** Confirm one proportionate brief before a multi-step change: scenarios, boundaries, invariants, owned paths, proof and next runnable join. Approval covers implementation through review within that boundary; honor delegated approval authority, record routine adjustments and renew approval for material requirement, scope, public contract, schema/wire, dependency or authority changes.
- **G-52** Create every ticket as one of the five kinds, in the ticket system's name for it from the project config: an epic for an outcome, a story for one behaviour a user can observe with its scenarios, a task for a buildable piece of a story's plan, a bug for behaviour that contradicts a scenario, a spike for a time-boxed question; link each to its parent (task to story, story to epic).
- A task is done when its test passes and its change is committed, not when its code exists.
- Keep tasks at a size where the first commit is an hour away, not a day.

## Report

State what was produced and where, link actual run output and summarize its scope and results, name failures/skips and what remains (G-15). Update the anchor at the meaningful milestone (G-12), referencing one proportionate evidence record instead of repacking unchanged proof. Stage only task-owned changes; honor existing explicit task commit authorization, otherwise present the diff and Conventional Commit message without committing (G-40).
