---
name: optimize
description: "Improve the performance of existing code against a measured baseline: profile, change the thing the profile says, measure again, and keep the change only if the measurement improved without breaking a test."
aa:
  discipline: development
  step: optimize
  guidance_sets: [every-step, anchored-step, code-change]
  guidance: [G-05]
  requires: [R-11]
---

# /aa-dev-optimize

Improve the performance of existing code against a measured baseline: profile, change the thing the profile says, measure again, and keep the change only if the measurement improved without breaking a test.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The performance ticket with the target metric and baseline from performance-test
- Profiling tools the project uses

## Procedure

1. **Anchor and check currency.** Read the ticket: the target metric, the baseline from
   performance-test with the method and environment that produced it, the linked scenarios, and
   the knowledge base page. If the ticket records a revision, compare it with the head for the
   code the baseline was measured on and the linked feature files, and record what changed
   (O-13). No numeric baseline or target means stop and get one; "slow" is not a target.
2. **Reproduce the baseline before changing anything.** Run the recorded method yourself at the
   head, with the same data volume and load profile, and record the number with the environment
   (G-05, T-07). If it does not reproduce within the noise of the method, that is the first
   finding on the ticket, and no optimisation starts against a number you cannot see.
3. **Profile.** Use the project's profiling tool category to find where the time or the memory
   goes, and record the top findings on the ticket. The change is what the profile says, not
   what looks slow.
4. **Change one thing, on a branch that references the ticket** (G-09, G-39). Every hunk serves
   the target metric on this ticket; adjacent problems become tickets, not changes here (O-19,
   G-42). A dependency changes only through the package manager (G-45).
5. **Measure again with the same method in the same environment.** Record before, after, and
   the difference, computed rather than estimated (G-02). If the number did not improve, revert
   the change, record the attempt and its number on the ticket, and return to the profile.
6. **Run the full suite before keeping the change.** Build with the lint switch (G-44) and run
   every tier from the root test script, then quote the output (G-04). A failing test is a
   defect in the optimisation, never a test to adjust, skip, or retry (G-06).
7. **Repeat, one change per measurement,** until the target is met or the profile has nothing
   left worth its cost. Record every round on the ticket. If the target cannot be met, say so
   with the numbers and raise a ticket for what would be needed.
8. **Stage and present.** Format the changed files (G-01), stage the change, write a perf-typed
   Conventional Commit message with the ticket in the footer (G-33), present the staged diff
   and the message, and stop. Commit only if the user asked for that commit (O-17, G-40).
9. **Write the optimisation implementation report on the ticket:** the baseline, each change
   with its before and after measurement, the method and environment, the test output, and the
   branch, linked both ways (G-12, G-26). Then report.

## Artifacts

**Optimisation implementation report** in the anchor ticket. Done when:

- Baseline, change, and after measurement are recorded with the method used
- The change is on a branch with all tests passing

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/code-change.md`: What every step that changes code, configuration, or infrastructure does, on top of repository-write: format changed files, prove with the build and tests, plan before a multi-step change, reference the ticket, commit everything needed to build and operate, let the tools decide style, change dependencies through the package manager.

*For this step:*

- **G-05** Reproduce a bug with a failing test or a captured observation before changing any code to fix it.
- No baseline, no optimisation. Measure first, with a tool, and record the number.
- Change one thing per measurement. Two changes measured together teach nothing.
- A faster wrong answer is a defect. Every optimisation runs the full suite before it is kept.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
