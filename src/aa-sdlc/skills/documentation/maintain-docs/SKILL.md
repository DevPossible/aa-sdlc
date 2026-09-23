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

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/repository-write.md`: What every step that changes files in the repository does: keep artifacts with the code, write Conventional Commit messages, one cohesive change per commit, stage and present rather than commit, and name the purpose of every change.

*For this step:*

- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-37** Commit everything needed to build, deploy, and operate the software with the change that needs it: configuration templates, migrations, scripts, pipeline, infrastructure, container, and alert definitions, runbooks, and the development environment configuration. If a fresh clone plus the documented secrets could not build, deploy, and run the system after your change, something is missing from the repository; find it and commit it.
- Start from the feature files and walk outward. They are the truth; every page and document is checked against them, never the reverse.
- Delete confidently. Documentation for something that no longer exists is worse than none; remove it and say so in the report.
- A contradiction between a page and a scenario is a conflict to surface, not a page to quietly fix (T-12).

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
