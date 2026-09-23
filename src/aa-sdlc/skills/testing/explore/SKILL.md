---
name: explore
description: "A time-boxed session using the system with a charter and a testing lens (boundaries, states, errors, interruptions, roles), recording every surprise as a defect, a question, or a new scenario."
aa:
  discipline: testing
  step: explore
  guidance_sets: [every-step, anchored-step]
  guidance: [G-18, G-21, G-23]
  requires: [R-16]
---

# /aa-qa-explore

A time-boxed session using the system with a charter and a testing lens (boundaries, states, errors, interruptions, roles), recording every surprise as a defect, a question, or a new scenario.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- A charter: what area, what lens, what time box
- The running system and its scenarios

## Procedure

1. **Anchor and fix the charter.** Read the ticket, the scenarios for the area, and its
   knowledge base page. Write the charter on the ticket before touching the system: the area,
   the lens (boundaries, states, errors, interruptions, roles), and the time box (G-23). If any
   of the three is missing, ask. Read what the existing tests already prove for the area (O-08)
   so the session spends its time on what they do not.
2. **Start the system as it runs.** Prefer the repository's container definitions (O-12) so that
   any surprise can be reproduced later. Record the revision and the configuration under test
   at the top of the session notes (T-07).
3. **Work the charter and write as you go.** For each thing tried, note what was done, what
   happened, and whether any scenario says what should have happened (G-21). Interrupt things:
   cancel midway, drop the connection, submit twice, go back, change role. The scenarios almost
   never say what should happen then.
4. **Stop at the time box.** Report what the charter covered and what it did not. If the most
   interesting surprise deserves more, state a second time box for it before continuing, and
   never extend a session silently (G-23).
5. **Sort every surprise.** Behaviour that contradicts a scenario is a defect ticket in the
   configured project, with the steps to reproduce it, linked to this ticket (G-27). Behaviour
   no scenario states is a question on the ticket and a pending scenario in the feature file,
   changed there first (G-18, G-21). Anything unclear is a question. Nothing stays only a note.
6. **Write the session notes on the ticket:** the charter, the environment, what was tried, what
   surprised, and what was concluded, with a link to every ticket and scenario raised (G-12,
   G-24, G-26). If a feature file was changed, stage it and present it with a Conventional
   Commit message; commit only if the user asked for that commit (O-17, G-40). Then report,
   naming what the charter did not reach (G-15).

## Artifacts

**Session notes** in the anchor ticket. Done when:

- Records what was tried, what surprised, and what was concluded
- Every surprise is a ticket, a question, or a pending scenario

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-21** Start from the feature files, then apply general testing strategies (boundaries, state transitions, error and recovery paths, concurrency, realistic user interaction sequences) to find what the requirement did not say. Record each gap as a question on the ticket and a new scenario in the feature file.
- **G-23** State a time box for any open-ended investigation before starting it, stop when it is reached, and report what was found either way.
- Follow the charter until the time box, then follow the most interesting surprise. Both halves matter.
- Interrupt things. Cancel midway, lose the connection, double-submit, go back; the scenarios almost never say what should happen.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
