---
name: finish-branch
description: "Take a branch from \"the tests pass\" to merged: format changed files, rebase or merge from the target branch, run the full test suite, open or update the merge request linked to the ticket, and transition the ticket."
aa:
  discipline: development
  step: finish-branch
  guidance_sets: [every-step, anchored-step, code-change]
  guidance: [G-13, G-14, G-29, G-51]
  requires: [R-11, R-24, R-41, R-43]
---

# /aa-dev-finish-branch

Take a branch from "the tests pass" to merged: format changed files, rebase or merge from the target branch, run the full test suite, open or update the merge request linked to the ticket, and transition the ticket.

## Anchor

Anchor first (G-22). Read the ticket, linked scenarios and knowledge page; check requirement currency under G-54. Pull instructions below apply only when the snapshot changed or currency is unknown. If no ticket system is reachable, record the anchor and artifacts locally, say so, and continue (T-05, T-10).

## Inputs

- The branch and its ticket
- The project's branch, commit, and merge conventions from the project config

## Procedure

1. **Anchor.** Pull the feature pages the ticket links to (G-54): their Approved scenarios into the
   features folder as feature files with their provenance header. With a documents-folder knowledge
   base run `scripts/aa-sdlc/Sync-FeatureFiles.ps1 -KnowledgeRoot <folder> -FeaturesRoot
   <features>`; with a knowledge base, read each page and convert it with `ConvertFrom-FeaturePage`
   from `scripts/aa-sdlc/AaFeatures.psm1`. Read the ticket, the branch, and the project's branch,
   commit, and merge conventions from the config. If the pull changed a feature file, the
   requirement moved under the branch: say what on the ticket before going further.
2. **Check the history on the branch.** Every commit is a Conventional Commit with the ticket in
   its footer, one concern each (G-33, G-39). If one is not, say which and how to split or
   reword it; never rewrite history the user did not ask you to rewrite.
3. **Respect ownership and commit authorization.** Inspect uncommitted work; touch and stage
   only this task's files. Format and present the diff/message, then commit only under explicit
   user authorization, including standing authorization for this task's local commits (G-40).
   Otherwise leave the task changes for the user's commit. Never absorb another worker's files.
4. **Bring the branch up to date** with the target branch by the project's convention (rebase
   or merge). Resolve conflicts honestly; a conflict that changes behaviour goes on the ticket.
5. **Prove the whole thing.** Format only the files this branch changed (G-01). Run the root
   build with the lint switch and the full test suite, every tier, not just the one you worked
   in, and quote the output (G-04). Run the feature-file check (G-56):
   `scripts/aa-sdlc/Test-FeatureProvenance.ps1 -FeaturesRoot <features>` for any knowledge base,
   or `scripts/aa-sdlc/Sync-FeatureFiles.ps1 -KnowledgeRoot <folder> -FeaturesRoot <features>
   -Check` for a documents-folder one, and quote its output; a feature file that fails it blocks
   the merge until its page is changed and pulled. A failing pipeline stage is reproduced
   locally with the same script before anything else is done (G-29). Nothing is skipped or
   suppressed (G-06).
   This is the actual branch-finish gate, not a prerequisite for each development checkpoint
   or scoped local integration. A prior independent full-suite run can satisfy this gate only
   when its candidate, relevant dependencies/environment, requirements, and evidence remain
   valid for the branch as it will be merged. Do not relabel a partial run as the full suite.
6. **Open or update the merge request.** Title and description reference the ticket and
   summarise the change and the tests that prove it. Link the request from the ticket and the
   ticket from the request (G-26).
7. **Respect the gates.** Never bypass a hook, a check, or a protected-branch rule (G-14).
   Merge only if the project's conventions let you and the user granted it; otherwise stop at
   the open request (G-13).
8. **Record integration evidence** on the ticket with the merge request linked (G-12).
   Keep configured In Review until stakeholder acceptance; only release makes it Done
   (G-51). Then report.

## Artifacts

**Merge request** in source control, linked from and to the ticket. Done when:

- Title and description reference the ticket and summarise the change and its tests; every commit on the branch references the ticket (O-19)
- Changed files are formatted; unrelated files are untouched (G-01); the root build passes with the lint switch (O-21)
- Full test suite passes on the branch as it will be merged
- The feature-file check passes on the branch as it will be merged; every feature file was pulled from its page (G-56)
- Every commit is a task-owned cohesive Conventional Commit made under explicit user authorization (O-17)

**Ticket transition** in the ticket system. Done when:

- The ticket retains the configured In review state with the request and merge evidence linked; stakeholder acceptance and release remain separate

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first and check requirement currency, update the ticket at meaningful checkpoints, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/code-change.md`: What every step that changes code, configuration, or infrastructure does, on top of repository-write: format changed files, prove with the build and tests, plan before a multi-step change, reference the ticket, commit everything needed to build and operate, let the tools decide style, change dependencies through the package manager, and never let a hand-edited feature file through.

*For this step:*

- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-14** Never use a bypass flag on a hook, check, or protected branch. If a gate blocks, fix the cause or tell the user.
- **G-29** Put every pipeline step's logic in a root script or a command committed to the repository and call it from the pipeline with the same arguments; when a pipeline step fails, reproduce it locally with that same script before changing anything. A step that can only run in the pipeline is a defect: ticket it and move the logic out.
- **G-51** Move tickets only with their producing evidence: Refined when scenarios/revision are recorded, Planned when the brief is confirmed and sized, In progress when implementation starts, In review when a verified candidate is ready with a linked merge request or authorized local review record, Accepted when the stakeholder confirms, Done when released. Distinguish author verification, independent review, local integration and release, using the configured state names.
- Format only what you changed. Reformatting untouched files hides the change and creates conflicts for everyone else.
- Bring the branch up to date before the final test run, and run the whole suite, not the tier you were working in.
- Run the feature-file check before opening or merging the request. A feature file that fails it blocks the merge; change the page and pull it, never edit the file (G-56).
- Never bypass a hook or a protected-branch rule. If a gate blocks, fix the cause or tell the user (G-14).
- Merge only if the project's conventions let you; otherwise open the request and stop (G-13).
- Honor explicit local task commit permission; otherwise present task-owned changes without committing (G-40). Remote writes, protected merges and release require separate authorization.

## Report

State what was produced and where, link actual run output and summarize its scope and results, name failures/skips and what remains (G-15). Update the anchor at the meaningful milestone (G-12), referencing one proportionate evidence record instead of repacking unchanged proof. Stage only task-owned changes; honor existing explicit task commit authorization, otherwise present the diff and Conventional Commit message without committing (G-40).
