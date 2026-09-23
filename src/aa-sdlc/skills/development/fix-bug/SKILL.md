---
name: fix-bug
description: "Reproduce a reported defect with a failing test, find the cause, fix the cause, and prove it with the test now passing, on a branch that references the ticket."
aa:
  discipline: development
  step: fix-bug
  guidance_sets: [every-step, anchored-step, code-change, test-writing]
  guidance: [G-05, G-17, G-29, G-32]
  requires: [R-16, R-24, R-27]
---

# /aa-dev-fix-bug

Reproduce a reported defect with a failing test, find the cause, fix the cause, and prove it with the test now passing, on a branch that references the ticket.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The defect ticket: symptoms, environment, steps to reproduce, severity
- The scenario the defect violates, if one exists

## Procedure

1. **Anchor and check currency.** Read the defect ticket: symptoms, environment, steps to
   reproduce, severity, and the scenario it violates if one is named. If the ticket records the
   revision it was triaged against, compare it with the head for the scenario and the suspected
   location and note what changed (O-13).
2. **Reproduce before touching code.** Write a failing test at the tier where the defect is
   observable, or capture the observation exactly (G-05). If it cannot be reproduced, put what
   was tried on the ticket and hand it back for more information; do not guess.
3. **Find the cause, not the symptom.** Form a hypothesis, test it, record the result on the
   ticket. Three hypotheses without evidence means stop and reassess (G-17). If the defect is
   an intermittent test, the cause is one of time, randomness, shared state, or a live
   dependency; control it. Never add a retry or lengthen a sleep (O-23).
4. **Fix on a branch that references the ticket** (G-09). One concern: the fix and its test.
   If the defect violates no scenario, one is missing; add it to the feature file with the fix
   so the requirement is stated (T-12). If the fix changes a dependency, do it through the
   package manager, never by editing a version (O-22).
5. **Prove it.** The reproducing test passes; the full tier it lives in passes; no existing test
   was weakened, skipped, or retried (G-06). If the defect was a pipeline failure, run the same
   root script locally with the same arguments and show the same result (G-29). Quote the
   output (G-04).
6. **Stage and present.** Format the changed files, run the build with the lint switch, stage,
   write a `fix(<scope>): ...` message with the ticket in the footer (G-33), present, and stop.
   Commit only if the user asked for that commit (O-17).
7. **Record the cause on the ticket** in one or two sentences, with the test that now guards
   it and links both ways (G-12, G-26). Then report.

## Artifacts

**Reproducing test** in the test tier where the defect is observable. Done when:

- Fails before the fix and passes after; staged with the fix for the user to commit (O-17)

**Fix** in source folder, on a branch named per the ticket convention. Done when:

- Addresses the cause, not the symptom; the ticket says what the cause was
- No existing test was weakened or skipped to make it pass

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/code-change.md`: What every step that changes code, configuration, or infrastructure does, on top of repository-write: format changed files, prove with the build and tests, plan before a multi-step change, reference the ticket, commit everything needed to build and operate, let the tools decide style, change dependencies through the package manager.
- `src/aa-sdlc/skills/aa-guidance/sets/test-writing.md`: What every step that writes or extends automated tests does: prove with the actual run, and keep every test deterministic and independent.

*For this step:*

- **G-05** Reproduce a bug with a failing test or a captured observation before changing any code to fix it.
- **G-17** After three failed attempts at the same fix, stop and reassess the approach rather than trying a fourth variation.
- **G-29** Put every pipeline step's logic in a root script or a command committed to the repository and call it from the pipeline with the same arguments; when a pipeline step fails, reproduce it locally with that same script before changing anything. A step that can only run in the pipeline is a defect: ticket it and move the logic out.
- **G-32** Before starting work on a ticket, compare the repository at the revision recorded on the ticket with the current head, list the changes to the linked feature files and to the files the plan names, and record on the ticket whether the scenarios and plan still hold. A conflict goes back to refinement as a question on the ticket; never absorb it silently or start anyway without saying so.
- No reproduction, no fix. If it cannot be reproduced, the ticket gets what was tried and goes back for more information.
- Find the cause before touching code. Form a hypothesis, test it, and record the result on the ticket; three hypotheses without evidence means stop and reassess (G-17).
- If the defect violates no scenario, one is missing. Add it to the feature file with the fix so the requirement is now stated.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
