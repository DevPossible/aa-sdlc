---
name: maintain-docs
description: "Audit the feature files, the documentation, and the knowledge base for drift from the feature pages and the code, fix what is wrong, and raise tickets for what needs an owner. Recurring; each run anchors on a maintenance ticket."
aa:
  discipline: documentation
  step: maintain-docs
  guidance_sets: [every-step, anchored-step, repository-write]
  guidance: [G-18, G-37, G-53]
  requires: [R-06, R-16, R-30, R-42]
---

# /aa-doc-maintain-docs

Audit the feature files, the documentation, and the knowledge base for drift from the feature pages and the code, fix what is wrong, and raise tickets for what needs an owner. Recurring; each run anchors on a maintenance ticket.

## Anchor

Anchor first (G-22). Read the anchor ticket and its knowledge base page, and pull the feature pages it links to into the features folder (G-54), before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The project's feature pages and other pages under its knowledge root, the feature files, and the documents folder
- Changes merged since the last audit

## Procedure

1. **Anchor and set the scope.** Read the maintenance ticket, its knowledge base page, and the
   previous health report with the revision and page versions it audited. Audit only what is
   this project's: the pages under `conventions.knowledge.root` and the tickets
   `conventions.ticket.filter` selects, never the rest of a shared space or ticket project (T-14,
   G-55). Compute the range of changes merged since then and list the feature pages, feature
   files, code, and documents changed in it (G-02). The scope of this run is that list plus
   anything the ticket names; record the head revision and the page versions the audit is made
   against.
2. **Check every feature file against its page.** The feature pages are the truth; every feature
   file in the repository must have been pulled from its page, unedited, and be current with it
   (T-12). Run `scripts/aa-sdlc/Test-FeatureProvenance.ps1 -FeaturesRoot <features>` and quote the
   output (R-46). For a documents-folder knowledge base also run
   `scripts/aa-sdlc/Sync-FeatureFiles.ps1 -KnowledgeRoot <folder> -FeaturesRoot <features> -Check`;
   otherwise compare the page version in each feature file's provenance header with the page's
   current version. Tabulate each difference: a feature file with no header or a checksum that
   no longer matches, a feature file no page generates, or a feature file behind its page.
3. **Sort every difference.** A feature file behind its page is fixed by pulling the page. A
   feature file edited by hand is never the requirement: restore it by pulling the page, and
   where the edit holds a change someone meant, convert it with `ConvertTo-FeaturePage` from
   `scripts/aa-sdlc/AaFeatures.psm1` and propose it on the page for its owner to approve (G-18).
   A feature file no page generates is a conflict: raise it as a question on the ticket, never
   absorb it into a page or delete it without its owner's word (T-12).
4. **Check every Approved scenario is linked to a ticket.** For every Approved scenario on the
   project's feature pages, confirm it carries its ticket tag and that the ticket links back to
   the page and the scenario id (G-19, G-26). A missing link is added where the ticket is this
   project's; anything else is raised for its owner.
5. **Check the rest of the documentation against the pages, the code, and the running
   software.** Other pages under the project's root, developer documentation, runbooks, and the
   development environment configuration must agree with the feature pages and name things that
   exist; run what they say to run where possible. A document that states behaviour no scenario
   states is a conflict: raise it as a question on the ticket, never absorb it into a page or
   quietly correct it (G-18, T-12). Documentation for something that no longer exists is deleted
   and the deletion listed. Anything a fresh clone would need and cannot find in the repository
   is a gap (O-16, G-37).
6. **Fix what this run can fix, on a branch linked to the ticket.** Each correction or deletion
   traces to a finding in the report (G-42). Change only pages under the project's own root and
   its own tickets; a problem in a shared space's structure or in another project's page or
   ticket is named for its owner, not changed (G-55). Raise a ticket in the configured project
   for anything that needs an owner, a decision, or more than this run, and link it from the
   anchor ticket (G-27, G-26).
7. **Write the health report in the knowledge base,** under the project's own root (G-53), for a
   reader who was not there (G-24): the revision range and page versions checked, what was
   checked, what was fixed, what was deleted, what was ticketed and to which ticket, and what
   was not checked (G-15).
8. **Stage and present, then update the ticket.** Stage the documentation changes as one change
   set with a Conventional Commit message naming the ticket (G-33, G-39), present the staged
   diff and the message, and stop; commit only if the user asked for that commit (O-17, G-40).
   Update the ticket with the report link, the tickets raised, and what remains (G-12). Then
   report.

## Artifacts

**Up-to-date documentation** in wherever it lives; changes on a branch linked to the ticket. Done when:

- Every feature file was pulled from its feature page, is unedited, and is current with the page (T-12, R-46)
- Every Approved scenario is linked to a ticket (G-19)
- No documented behaviour contradicts a scenario or the running software

**Documentation health report** in the knowledge base. Done when:

- Lists what was checked, what was fixed, and what is ticketed for someone else

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first and pull the feature pages it links to, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/repository-write.md`: What every step that changes files in the repository does: keep artifacts with the code, write Conventional Commit messages, one cohesive change per commit, stage and present rather than commit, and name the purpose of every change.

*For this step:*

- **G-18** Change a requirement on its feature page in the knowledge base, under the ticket that asks for it, then pull the page into the repository. Never edit a feature file by hand; a change found while building is converted to the page format and proposed on the page for its owner to approve.
- **G-37** Commit everything needed to build, deploy, and operate the software with the change that needs it: configuration templates, migrations, scripts, pipeline, infrastructure, container, and alert definitions, runbooks, and the development environment configuration. If a fresh clone plus the documented secrets could not build, deploy, and run the system after your change, something is missing from the repository; find it and commit it.
- **G-53** Put each knowledge base page under the project's own root, in the section its content belongs to (Overview, Requirements, Architecture, Operations, Releases, Guides, or the names the project config maps them to), name a requirement page after its feature and its feature id, and when a page is superseded mark it and link to what replaced it rather than deleting it.
- Start from the feature pages and walk outward. They are the truth; every feature file, page, and document is checked against them, never the reverse.
- Delete confidently. Documentation for something that no longer exists is worse than none; remove it and say so in the report.
- A contradiction between a document and a scenario is a conflict to surface, not something to quietly fix; a scenario changes only on its page, with its owner's approval (T-12).
- Audit only what is this project's, the pages under its knowledge root and the tickets its filter selects; a problem in a shared space or another project's page is named for its owner, not changed (T-14).

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
