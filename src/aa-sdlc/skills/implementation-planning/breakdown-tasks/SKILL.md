---
name: breakdown-tasks
description: "When a confirmed plan is too large to build as one change, split it into tasks on the ticket, each independently buildable and testable, with their order and dependencies."
aa:
  discipline: implementation-planning
  step: breakdown-tasks
  guidance_sets: [every-step, anchored-step]
  guidance: [G-08]
---

# /aa-ip-breakdown-tasks

When a confirmed plan is too large to build as one change, split it into tasks on the ticket, each independently buildable and testable, with their order and dependencies.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The confirmed implementation plan

## Procedure

1. **Anchor and check currency.** Read the ticket, its scenarios, and the confirmed
   implementation plan (G-22). Compare the repository at the revision the plan records with the
   head, filtered to the linked feature files and the files the plan names, and record the
   result on the ticket. If a scenario or a planned file moved, the plan goes back to
   plan-implementation before it is split (O-13).
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

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-08** Before any multi-step change, write the plan and get it confirmed; one concern per commit and one ticket per branch is G-39.
- A task is done when its test passes and its change is committed, not when its code exists.
- Keep tasks at a size where the first commit is an hour away, not a day.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
