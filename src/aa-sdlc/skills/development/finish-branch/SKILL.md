---
name: finish-branch
description: "Take a branch from \"the tests pass\" to merged: format changed files, rebase or merge from the target branch, run the full test suite, open or update the merge request linked to the ticket, and transition the ticket."
aa:
  discipline: development
  step: finish-branch
  guidance_sets: [every-step, anchored-step, code-change]
  guidance: [G-13, G-14, G-29]
  requires: [R-11, R-24]
---

# /aa-dev-finish-branch

Take a branch from "the tests pass" to merged: format changed files, rebase or merge from the target branch, run the full test suite, open or update the merge request linked to the ticket, and transition the ticket.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The branch and its ticket
- The project's branch, commit, and merge conventions from the project config

## Procedure

1. **Anchor.** Read the ticket, the branch, and the project's branch, commit, and merge
   conventions from the config.
2. **Check the history on the branch.** Every commit is a Conventional Commit with the ticket in
   its footer, one concern each (G-33, G-39). If one is not, say which and how to split or
   reword it; never rewrite history the user did not ask you to rewrite.
3. **Uncommitted work stays the user's.** If the working tree has changes, format the changed
   files, stage them, present the diff and a message, and stop: the branch waits on the user's
   commit (O-17). Do not commit on their behalf.
4. **Bring the branch up to date** with the target branch by the project's convention (rebase
   or merge). Resolve conflicts honestly; a conflict that changes behaviour goes on the ticket.
5. **Prove the whole thing.** Format only the files this branch changed (G-01). Run the root
   build with the lint switch and the full test suite, every tier, not just the one you worked
   in, and quote the output (G-04). A failing pipeline stage is reproduced locally with the
   same script before anything else is done (G-29). Nothing is skipped or suppressed (G-06).
6. **Open or update the merge request.** Title and description reference the ticket and
   summarise the change and the tests that prove it. Link the request from the ticket and the
   ticket from the request (G-26).
7. **Respect the gates.** Never bypass a hook, a check, or a protected-branch rule (G-14).
   Merge only if the project's conventions let you and the user granted it; otherwise stop at
   the open request (G-13).
8. **Transition the ticket** to the project's "in review" or "done" state with the merge
   request linked (G-12). Then report.

## Artifacts

**Merge request** in source control, linked from and to the ticket. Done when:

- Title and description reference the ticket and summarise the change and its tests; every commit on the branch references the ticket (O-19)
- Changed files are formatted; unrelated files are untouched (G-01); the root build passes with the lint switch (O-21)
- Full test suite passes on the branch as it will be merged
- Every commit on the branch is a Conventional Commit with a type from the project config (O-14), one cohesive change each, made by the user (O-17)

**Ticket transition** in the ticket system. Done when:

- The ticket moves to the state the project uses for "in review" or "done", with the merge request linked

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/code-change.md`: What every step that changes code, configuration, or infrastructure does, on top of repository-write: format changed files, prove with the build and tests, plan before a multi-step change, reference the ticket, commit everything needed to build and operate, let the tools decide style, change dependencies through the package manager.

*For this step:*

- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-14** Never use a bypass flag on a hook, check, or protected branch. If a gate blocks, fix the cause or tell the user.
- **G-29** Put every pipeline step's logic in a root script or a command committed to the repository and call it from the pipeline with the same arguments; when a pipeline step fails, reproduce it locally with that same script before changing anything. A step that can only run in the pipeline is a defect: ticket it and move the logic out.
- Format only what you changed. Reformatting untouched files hides the change and creates conflicts for everyone else.
- Bring the branch up to date before the final test run, and run the whole suite, not the tier you were working in.
- Never bypass a hook or a protected-branch rule. If a gate blocks, fix the cause or tell the user (G-14).
- Merge only if the project's conventions let you; otherwise open the request and stop (G-13).
- Never commit the remaining changes yourself. Stage them, present them, and report that the branch waits on the user's commit (O-17).

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
