---
name: implement
description: "Build what the anchor ticket asks for, with the tests that prove it, on a branch that references the ticket, following the confirmed plan."
aa:
  discipline: development
  step: implement
  guidance_sets: [every-step, anchored-step, code-change, test-writing]
  guidance: [G-05, G-17, G-20, G-30, G-32, G-43, G-48, G-49, G-51]
  requires: [R-26, R-27, R-34, R-39, R-13, R-41, R-43]
---

# /aa-dev-implement

Build what the anchor ticket asks for, with the tests that prove it, on a branch that references the ticket, following the confirmed plan.

## Anchor

Anchor first (G-22). Read the ticket, linked scenarios and knowledge page; check requirement currency under G-54. Pull instructions below apply only when the snapshot changed or currency is unknown. If no ticket system is reachable, record the anchor and artifacts locally, say so, and continue (T-05, T-10).

## Inputs

- The anchor ticket and its scenarios, pulled from their feature pages into the feature files (G-54)
- The confirmed implementation plan and tasks
- The current code, read before it is changed
- What changed in the linked feature pages, their feature files, and the files the plan names since the ticket was planned (O-13)

## Procedure

1. **Anchor and check currency.** Pull the feature pages the ticket links to (G-54): their Approved
   scenarios into the features folder as feature files with their provenance header. With a
   documents-folder knowledge base run `scripts/aa-sdlc/Sync-FeatureFiles.ps1 -KnowledgeRoot
   <folder> -FeaturesRoot <features>`; with a knowledge base, read each page and convert it with
   `ConvertFrom-FeaturePage` from `scripts/aa-sdlc/AaFeatures.psm1`. Read the ticket, its scenarios,
   and its confirmed plan. Compare the page versions recorded on the ticket with the pages' current
   versions, and the repository at the revision the ticket records with the head, filtered to the
   feature files the ticket links and the files the plan names. Record the result on the ticket. If
   a scenario or a planned file changed, assess and record whether the plan still holds. Escalate
   actual conflicts or material boundary changes; unrelated or compatible changes do not require
   another plan approval (O-13).
2. **Branch.** One ticket, one branch, named per the project convention with the ticket id in it
   (G-09, G-39). Never work on the default branch.
3. **Build the plan, one step at a time.** Establish a meaningful failing scenario or bug
   reproduction, then develop tests and implementation together. Missing types alone do not
   prove behavior; exhaustive private API goldens and prewritten fixtures are not universal
   prerequisites. Identify authority, money, schema/wire, lifetime, and race invariants before
   coding and prove the applicable cases before acceptance. Tests control time, randomness,
   state, and dependencies (O-23). After the first focused behavior works, exercise the
   brief's real collaborator before expanding combinatorial private/unit cases. This early
   join exposes protocol, timing and fixture mistakes; all promised negative and coverage
   gates still precede acceptance. Run focused checks during development, then the affected
   build and tiers before review (G-04). Own routine implementation and fixture repairs within
   the approved brief; record adjustments, escalating material changes as plan-implementation
   defines. When a scenario turns out
   wrong or missing, never edit the feature file: convert the change to the page format with
   `ConvertTo-FeaturePage` from `scripts/aa-sdlc/AaFeatures.psm1`, propose it on its feature page
   for its owner to approve, and name it on the ticket; the repository gets it only by pulling
   the page once it is Approved (G-18).
4. **Keep the change to the ticket.** Every hunk names the scenario it serves or the reason on
   the ticket; adjacent problems become tickets, not fixes here (O-19). The simplest structure
   that meets the scenarios, nothing for scenarios that do not exist (O-20). A new setting goes
   in one place: the environment templates if it varies by environment, the application
   configuration if it does not (O-25). A dependency changes only through the package manager
   (O-22). The migration, the configuration key, and the runbook ship with the code that needs
   them (O-16).
5. **Checkpoint coherent changes.** Format the changed files (G-01), run the build with the lint switch
   (O-21), run the feature-file check (G-56): `scripts/aa-sdlc/Test-FeatureProvenance.ps1
   -FeaturesRoot <features>`, or `Sync-FeatureFiles.ps1 ... -Check` with a documents-folder
   knowledge base, and never stage a feature file that fails it. Stage the change, write a
   Conventional Commit message with the ticket in the footer (G-33), and present the staged diff and
   message. Keep commits cohesive (G-39). Existing explicit authorization for local task commits
   covers these checkpoints; otherwise present them for the user (O-17). Do not stop the
   implementation loop merely because a focused test became green.
6. **Before saying done.** Every delivered scenario has passing proof at the tiers it warrants,
   with the scenario-to-test mapping and tier rationale recorded (G-20). The affected build with
   lint and relevant tiers pass with actual output retained. Nothing was silently skipped, suppressed, or retried
   into green (G-06). After three failed attempts at the same fix, stop and reassess (G-17).
7. **Close the loop on the ticket.** Record what was built, where, which tests prove it, and what
   remains, with links both ways (G-12, G-26). When verification is complete and the identified
   candidate is ready for review, move it to configured In Review with its merge request or
   authorized local review record. Record whether independent review is pending; this is not
   stakeholder acceptance, full branch finish or release. Then report.

## Artifacts

**Application code** in source folder, on a branch named per the ticket convention. Done when:

- Builds with the root build script, and passes it with the lint switch (O-21)
- Every delivered scenario has passing tests at justified tiers with its mapping and rationale recorded; all promised acceptance cases and required coverage remain due
- Follows the plan, or the deviation is recorded on the ticket with the reason
- No feature file was edited by hand; the feature-file check passes (G-56)

**Tests that prove the requirement** in unit tests with the project; integration and happy-path end-to-end tests under tests/. Done when:

- Happy paths, general permutations, and obvious negative cases are covered (G-20)

**Reviewable candidate** on the ticket, linked to its merge request or authorized local review record. Done when:

- Author verification identifies the candidate, affected gates, scenario mapping and remaining work
- The ticket moves to configured In review when ready; independent review, integration, stakeholder acceptance and release remain distinct

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first and check requirement currency, update the ticket at meaningful checkpoints, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/code-change.md`: What every step that changes code, configuration, or infrastructure does, on top of repository-write: format changed files, prove with the build and tests, plan before a multi-step change, reference the ticket, commit everything needed to build and operate, let the tools decide style, change dependencies through the package manager, and never let a hand-edited feature file through.
- `src/aa-sdlc/skills/aa-guidance/sets/test-writing.md`: What every step that writes or extends automated tests does: prove with the actual run, and keep every test deterministic and independent.

*For this step:*

- **G-05** Reproduce a bug with a failing test or a captured observation before changing any code to fix it.
- **G-17** After three failed attempts at the same fix, stop and reassess the approach rather than trying a fourth variation.
- **G-20** Prove each delivered scenario at justified tiers: behavior and relevant negative cases, integration at changed boundaries, and happy-path end-to-end proof for user-visible flows. Record the scenario-to-test mapping and tier rationale, avoid automatically duplicating equivalent assertions at every tier, and preserve all promised acceptance cases and required coverage.
- **G-30** Run the end-to-end tier against the system and its dependencies started in containers from definitions committed to the repository, so it runs the same way on any machine and in the pipeline. Reach a shared environment only for a dependency that cannot be containerised, and record which tests depend on it.
- **G-32** Before starting work on a ticket, compare the repository at the revision recorded on the ticket with the current head, list the changes to the linked feature files and to the files the plan names, and record on the ticket whether the scenarios and plan still hold. A conflict goes back to refinement as a question on the ticket; never absorb it silently or start anyway without saying so.
- **G-43** Design for the scenarios that exist, not the ones you expect: choose the simplest structure that satisfies them, and add an abstraction, extension point, configuration option, or feature only when a scenario requires it or a decision record justifies it, naming which. In review, code or structure that serves no scenario is a finding, and so is a fourth copy of the same code where one named thing would do.
- **G-48** Split configuration by what varies: settings that differ between environments (endpoints, connection strings, resource names, credentials) go in an environment file or the platform's equivalent, one per environment with a committed template, supplied at deploy time; settings that are the same everywhere (timeouts, limits, behaviour) go in the application configuration committed once with the code. Never put a key in both; when adding a setting, ask which kind it is and put it in that one place, and if a functional setting must differ for one environment, record why in a decision record rather than copying the configuration.
- **G-49** Give every feature a stable id (F-nnn) and every scenario one derived from it (F-nnn-nn), assigned on its feature page once and never renumbered or reused; tag or name every automated test with the ids of the scenarios it proves, so coverage is the set of scenario ids that at least one test names.
- **G-51** Move tickets only with their producing evidence: Refined when scenarios/revision are recorded, Planned when the brief is confirmed and sized, In progress when implementation starts, In review when a verified candidate is ready with a linked merge request or authorized local review record, Accepted when the stakeholder confirms, Done when released. Distinguish author verification, independent review, local integration and release, using the configured state names.
- Check the ticket against the repository and the pages before anything else. Compare the page versions recorded on the ticket with the pages' current versions, and diff from the recorded revision to the head, filtered to the feature files and the files the plan names; record the result on the ticket, and send a conflict back to refinement rather than building on it (O-13).
- Establish meaningful failing behavior, then evolve tests and code together; exercise the named real collaborator after the first focused behavior before broad private test expansion (G-60).
- Control what varies. Inject or freeze time, seed randomness, own the test data, and fake or containerise external dependencies; a test with a sleep or a live call in it is not finished (O-23).
- Checkpoint coherent changes under existing explicit task commit authorization (G-40); a focused green test does not require another permission round.
- Record routine adjustments within the approved brief and continue; renew approval before dependent work for material requirement, scope, public contract, schema/wire, dependency or authority changes (G-08).
- Never edit a feature file. A scenario found wrong or missing while building is converted to the page format with ConvertTo-FeaturePage and proposed on its feature page for its owner to approve; the repository gets it only by pulling the page once it is Approved (G-18).
- Do not widen the change. Adjacent problems become tickets, not fixes on this branch; every hunk on the branch names the ticket, scenario, or decision it serves (O-19).
- Change a dependency with the package manager, never by editing a version in a file. If the tool refuses, the refusal goes on the ticket; it is not bypassed (O-22).
- Ship the change with what it needs to run: the migration, the new configuration key in every template, the updated runbook. A change that works on your machine because of a file only you have is not done (O-16).
- Put each new setting in one place. If its value differs between environments it goes in every environment template; if it does not, it goes in the application configuration once (O-25).

## Report

State what was produced and where, link actual run output and summarize its scope and results, name failures/skips and what remains (G-15). Update the anchor at the meaningful milestone (G-12), referencing one proportionate evidence record instead of repacking unchanged proof. Stage only task-owned changes; honor existing explicit task commit authorization, otherwise present the diff and Conventional Commit message without committing (G-40).
