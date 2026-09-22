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

- **G-05** Reproduce a bug with a failing test or a captured observation before changing any code to fix it.
- No baseline, no optimisation. Measure first, with a tool, and record the number.
- Change one thing per measurement. Two changes measured together teach nothing.
- A faster wrong answer is a defect. Every optimisation runs the full suite before it is kept.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
