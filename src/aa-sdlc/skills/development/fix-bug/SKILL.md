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

*From the `every-step` set:* What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-03** Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read.
- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).

*From the `anchored-step` set:* What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-25** Produce each artifact in the location the workflow names for it, with the name it gives. Never invent a new location or a variant name; if the named location is wrong for this project, change the project config, not the artifact (T-08).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- **G-27** Create and anchor tickets only in the repository's one configured ticket project. If the work touches a ticket in another project, create or use a ticket in this project and link the two; never anchor a step on a ticket outside the configured project.

*From the `code-change` set:* What every step that changes code, configuration, or infrastructure does, on top of repository-write: format changed files, prove with the build and tests, plan before a multi-step change, reference the ticket, commit everything needed to build and operate, let the tools decide style, change dependencies through the package manager.

- **G-01** Always format the code for the changed files before committing, but do not format files that were not changed.
- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-08** Before any multi-step change, write the plan and get it confirmed; one concern per commit and one ticket per branch is G-39.
- **G-09** Reference the anchor ticket in the branch name and every commit message.
- **G-11** Every artifact that belongs with the code goes into the same change set as the code, staged for the commit the user makes (G-40). Nothing that matters is left only on a local disk or in a conversation.
- **G-33** Write every commit message in Conventional Commits form: a type from the project's list, an optional scope, an imperative subject, a body that says why, and a footer carrying the ticket reference and any breaking change. One concern per commit (G-39); if you cannot name the type, split the commit.
- **G-37** Commit everything needed to build, deploy, and operate the software with the change that needs it: configuration templates, migrations, scripts, pipeline, infrastructure, container, and alert definitions, runbooks, and the development environment configuration. If a fresh clone plus the documented secrets could not build, deploy, and run the system after your change, something is missing from the repository; find it and commit it.
- **G-39** Make each commit one understandable change: one concern per commit, one ticket per branch, a subject that says what and a body that says why, small enough to review in one sitting. If the subject needs "and" or the diff needs a tour, split it.
- **G-40** Never commit unless the user asked for that commit. Stage the change, write the message, present the staged diff summary and the message, and stop; a request to implement, fix, finish, or run a step is not a request to commit, and the commit is made under the user's identity with no agent attribution.
- **G-42** Before making a change, name what it is for: the ticket, the scenario it satisfies, or the decision record or page that explains it, and put that reference where the change lives: the branch, the commit footer, the merge request, and the artifact. A change that cannot name its purpose is a ticket to create first or work not to do; in review, a hunk that traces to nothing is a finding.
- **G-44** Let the tools decide style: conventions live as formatter and linter configuration in the repository, the formatter runs on changed files and the linter runs from the root build before a change is presented, and every finding is fixed or suppressed with a reason beside it. Never argue style in review; where a language has no known linter, record that once in the development environment configuration and expect the health warning.
- **G-45** Change dependencies only through the ecosystem's package manager: add, update, and remove with its commands so it resolves conflicts, surfaces warnings, and updates transitive dependencies and the lock file together, and stage the manifest and lock file changes as their own commit (G-39). Never edit a version in a manifest or lock file by hand; if the tool refuses, record the refusal on the ticket and resolve it, never bypass it.

*From the `test-writing` set:* What every step that writes or extends automated tests does: prove with the actual run, and keep every test deterministic and independent.

- **G-46** Make every test deterministic and independent: inject or freeze time, seed or inject randomness, give each test its own state and clean it up, and replace external dependencies with a container, a fake, or a recorded response; never depend on test order, on state another test left, or on a sleep. A test that fails intermittently is a defect: quarantine it with a ticket the same day, never retry it into green or skip it without one (G-06).

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
