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
