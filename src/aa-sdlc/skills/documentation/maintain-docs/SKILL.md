---
name: maintain-docs
description: "Audit the documentation and knowledge base for drift from the feature files and the code, fix what is wrong, and raise tickets for what needs an owner. Recurring; each run anchors on a maintenance ticket."
aa:
  discipline: documentation
  step: maintain-docs
  guidance_sets: [every-step, anchored-step, repository-write]
  guidance: [G-18, G-37]
  requires: [R-03, R-06, R-16, R-30]
---

# /aa-doc-maintain-docs

Audit the documentation and knowledge base for drift from the feature files and the code, fix what is wrong, and raise tickets for what needs an owner. Recurring; each run anchors on a maintenance ticket.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The feature files, the knowledge base, and the documents folder
- Changes merged since the last audit

## Procedure

1. **Anchor and set the scope.** Read the maintenance ticket, its knowledge base page, and the
   previous health report with the revision it audited. Compute the range of changes merged
   since then and list the feature files, code, and documents changed in it (G-02). The scope
   of this run is that list plus anything the ticket names; record the head revision the audit
   is made against.
2. **Walk from the feature files outward.** For every feature file in scope, find the knowledge
   base page named in its description and compare the two. Tabulate each difference: a page
   missing, a page behind the feature, or a page stating behaviour the feature does not.
3. **Sort every difference.** A page missing or behind is fixed from the feature file. A page
   that states a requirement no scenario states was edited alone, and is a conflict: raise it
   as a question on the ticket, never absorb it into the feature file or quietly correct the
   page (G-18, T-12).
4. **Check the documents folder against the code and the running software.** Developer
   documentation, runbooks, and the development environment configuration must name things that
   exist; run what they say to run where possible. Documentation for something that no longer
   exists is deleted and the deletion listed. Anything a fresh clone would need and cannot find
   in the repository is a gap (O-16, G-37).
5. **Fix what this run can fix, on a branch linked to the ticket.** Each correction or deletion
   traces to a finding in the report (G-42). Raise a ticket in the configured project for
   anything that needs an owner, a decision, or more than this run, and link it from the anchor
   ticket (G-27, G-26).
6. **Write the health report in the knowledge base,** for a reader who was not there (G-24):
   the revision range checked, what was checked, what was fixed, what was deleted, what was
   ticketed and to which ticket, and what was not checked (G-15).
7. **Stage and present, then update the ticket.** Stage the documentation changes as one change
   set with a Conventional Commit message naming the ticket (G-33, G-39), present the staged
   diff and the message, and stop; commit only if the user asked for that commit (O-17, G-40).
   Update the ticket with the report link, the tickets raised, and what remains (G-12). Then
   report.

## Artifacts

**Up-to-date documentation** in wherever it lives; changes on a branch linked to the ticket. Done when:

- Every feature file has a knowledge base page that matches it (T-12)
- No documented behaviour contradicts a scenario or the running software

**Documentation health report** in the knowledge base. Done when:

- Lists what was checked, what was fixed, and what is ticketed for someone else

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

*From the `repository-write` set:* What every step that changes files in the repository does: keep artifacts with the code, write Conventional Commit messages, one cohesive change per commit, stage and present rather than commit, and name the purpose of every change.

- **G-11** Every artifact that belongs with the code goes into the same change set as the code, staged for the commit the user makes (G-40). Nothing that matters is left only on a local disk or in a conversation.
- **G-33** Write every commit message in Conventional Commits form: a type from the project's list, an optional scope, an imperative subject, a body that says why, and a footer carrying the ticket reference and any breaking change. One concern per commit (G-39); if you cannot name the type, split the commit.
- **G-39** Make each commit one understandable change: one concern per commit, one ticket per branch, a subject that says what and a body that says why, small enough to review in one sitting. If the subject needs "and" or the diff needs a tour, split it.
- **G-40** Never commit unless the user asked for that commit. Stage the change, write the message, present the staged diff summary and the message, and stop; a request to implement, fix, finish, or run a step is not a request to commit, and the commit is made under the user's identity with no agent attribution.
- **G-42** Before making a change, name what it is for: the ticket, the scenario it satisfies, or the decision record or page that explains it, and put that reference where the change lives: the branch, the commit footer, the merge request, and the artifact. A change that cannot name its purpose is a ticket to create first or work not to do; in review, a hunk that traces to nothing is a finding.

*For this step:*

- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-37** Commit everything needed to build, deploy, and operate the software with the change that needs it: configuration templates, migrations, scripts, pipeline, infrastructure, container, and alert definitions, runbooks, and the development environment configuration. If a fresh clone plus the documented secrets could not build, deploy, and run the system after your change, something is missing from the repository; find it and commit it.
- Start from the feature files and walk outward. They are the truth; every page and document is checked against them, never the reverse.
- Delete confidently. Documentation for something that no longer exists is worse than none; remove it and say so in the report.
- A contradiction between a page and a scenario is a conflict to surface, not a page to quietly fix (T-12).

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
