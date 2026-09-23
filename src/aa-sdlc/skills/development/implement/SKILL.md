---
name: implement
description: "Build what the anchor ticket asks for, with the tests that prove it, on a branch that references the ticket, following the confirmed plan."
aa:
  discipline: development
  step: implement
  guidance_sets: [every-step, anchored-step, code-change, test-writing]
  guidance: [G-05, G-17, G-20, G-30, G-32, G-43, G-48]
  requires: [R-26, R-27, R-34, R-39, R-13]
---

# /aa-dev-implement

Build what the anchor ticket asks for, with the tests that prove it, on a branch that references the ticket, following the confirmed plan.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The anchor ticket and its scenarios in the feature files
- The confirmed implementation plan and tasks
- The current code, read before it is changed
- What changed in the linked feature files and the files the plan names since the ticket was planned (O-13)

## Procedure

1. **Anchor and check currency.** Read the ticket, its scenarios, and its confirmed plan. Compare
   the repository at the revision the ticket records with the head, filtered to the feature
   files the ticket links and the files the plan names. Record the result on the ticket. If a
   scenario or a planned file changed, say what and send the question back to refinement or
   re-run plan-implementation; do not build on a plan the repository has moved under (O-13).
2. **Branch.** One ticket, one branch, named per the project convention with the ticket id in it
   (G-09, G-39). Never work on the default branch.
3. **Build the plan, one step at a time.** For each plan step: write the failing test for the
   scenario first, then the code that passes it. Tests control time, randomness, state, and
   dependencies from the start (O-23); a sleep or a live call is not finished. Run the root
   build and the tiers the step touches and read the output (G-04). When the plan meets reality
   and loses, stop and update the plan on the ticket before continuing.
4. **Keep the change to the ticket.** Every hunk names the scenario it serves or the reason on
   the ticket; adjacent problems become tickets, not fixes here (O-19). The simplest structure
   that meets the scenarios, nothing for scenarios that do not exist (O-20). A new setting goes
   in one place: the environment templates if it varies by environment, the application
   configuration if it does not (O-25). A dependency changes only through the package manager
   (O-22). The migration, the configuration key, and the runbook ship with the code that needs
   them (O-16).
5. **Stop at every green.** Format the changed files (G-01), run the build with the lint switch
   (O-21), stage the change, write a Conventional Commit message with the ticket in the footer
   (G-33), and present the staged diff and message. Split when the message needs "and" (G-39).
   Commit only if the user asked for that commit (O-17).
6. **Before saying done.** Every scenario the ticket delivers has passing unit and integration
   tests and a happy-path end-to-end test as the change warrants (G-20). The full build with
   lint and every touched tier pass and are quoted. Nothing was skipped, suppressed, or retried
   into green (G-06). After three failed attempts at the same fix, stop and reassess (G-17).
7. **Close the loop on the ticket.** Record what was built, where, which tests prove it, and what
   remains, with links both ways (G-12, G-26). Then report.

## Artifacts

**Application code** in source folder, on a branch named per the ticket convention. Done when:

- Builds with the root build script, and passes it with the lint switch (O-21)
- Every scenario for the ticket has a passing unit test, integration test, and happy-path end-to-end test, as the change warrants each tier
- Follows the plan, or the deviation is recorded on the ticket with the reason

**Tests that prove the requirement** in unit tests with the project; integration and happy-path end-to-end tests under tests/. Done when:

- Happy paths, general permutations, and obvious negative cases are covered (G-20)

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/code-change.md`: What every step that changes code, configuration, or infrastructure does, on top of repository-write: format changed files, prove with the build and tests, plan before a multi-step change, reference the ticket, commit everything needed to build and operate, let the tools decide style, change dependencies through the package manager.
- `src/aa-sdlc/skills/aa-guidance/sets/test-writing.md`: What every step that writes or extends automated tests does: prove with the actual run, and keep every test deterministic and independent.

*For this step:*

- **G-05** Reproduce a bug with a failing test or a captured observation before changing any code to fix it.
- **G-17** After three failed attempts at the same fix, stop and reassess the approach rather than trying a fourth variation.
- **G-20** When implementing a ticket, write the automated tests that prove it: unit and integration tests for every happy path, the general permutations and cases, and the obvious negative cases, plus a happy-path end-to-end test for each scenario. The ticket is not done until they exist and pass.
- **G-30** Run the end-to-end tier against the system and its dependencies started in containers from definitions committed to the repository, so it runs the same way on any machine and in the pipeline. Reach a shared environment only for a dependency that cannot be containerised, and record which tests depend on it.
- **G-32** Before starting work on a ticket, compare the repository at the revision recorded on the ticket with the current head, list the changes to the linked feature files and to the files the plan names, and record on the ticket whether the scenarios and plan still hold. A conflict goes back to refinement as a question on the ticket; never absorb it silently or start anyway without saying so.
- **G-43** Design for the scenarios that exist, not the ones you expect: choose the simplest structure that satisfies them, and add an abstraction, extension point, configuration option, or feature only when a scenario requires it or a decision record justifies it, naming which. In review, code or structure that serves no scenario is a finding, and so is a fourth copy of the same code where one named thing would do.
- **G-48** Split configuration by what varies: settings that differ between environments (endpoints, connection strings, resource names, credentials) go in an environment file or the platform's equivalent, one per environment with a committed template, supplied at deploy time; settings that are the same everywhere (timeouts, limits, behaviour) go in the application configuration committed once with the code. Never put a key in both; when adding a setting, ask which kind it is and put it in that one place, and if a functional setting must differ for one environment, record why in a decision record rather than copying the configuration.
- Check the ticket against the repository before anything else. Diff from the recorded revision to the head, filtered to the feature files and the files the plan names; record the result on the ticket, and send a conflict back to refinement rather than building on it (O-13).
- Write the failing test for the scenario before the code that passes it. Then the code has one job.
- Control what varies. Inject or freeze time, seed randomness, own the test data, and fake or containerise external dependencies; a test with a sleep or a live call in it is not finished (O-23).
- Stop at every green. Stage the change, write a Conventional Commit message that names its type and its ticket (O-14), present the staged diff and the message, and wait; commit only if the user asked for that commit (O-17).
- When the plan meets reality and loses, stop and update the plan on the ticket before continuing. Do not improvise silently.
- Do not widen the change. Adjacent problems become tickets, not fixes on this branch; every hunk on the branch names the ticket, scenario, or decision it serves (O-19).
- Change a dependency with the package manager, never by editing a version in a file. If the tool refuses, the refusal goes on the ticket; it is not bypassed (O-22).
- Ship the change with what it needs to run: the migration, the new configuration key in every template, the updated runbook. A change that works on your machine because of a file only you have is not done (O-16).
- Put each new setting in one place. If its value differs between environments it goes in every environment template; if it does not, it goes in the application configuration once (O-25).

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
