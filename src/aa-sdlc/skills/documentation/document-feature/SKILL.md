---
name: document-feature
description: "Write or update the user-facing and developer-facing documentation for a ticket, from its scenarios and its implementation, in the places the project keeps each kind."
aa:
  discipline: documentation
  step: document-feature
  guidance_sets: [every-step, anchored-step, repository-write]
  guidance: [G-37, G-53]
  requires: [R-06, R-16, R-30, R-42]
---

# /aa-doc-document-feature

Write or update the user-facing and developer-facing documentation for a ticket, from its scenarios and its implementation, in the places the project keeps each kind.

## Anchor

Anchor first (G-22). Read the anchor ticket and its knowledge base page, and pull the feature pages it links to into the features folder (G-54), before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The ticket, its feature pages and their scenarios, and the merged change
- The project's documentation locations from the config or knowledge base

## Procedure

1. **Anchor, pull, and check currency.** Read the ticket and pull the feature pages it links to:
   their Approved scenarios into the features folder, and the page versions recorded on the
   ticket (G-54). For a documents-folder knowledge base run `scripts/aa-sdlc/Sync-FeatureFiles.ps1
   -KnowledgeRoot <folder> -FeaturesRoot <features>`; otherwise read each page and convert it with
   `ConvertFrom-FeaturePage` from `scripts/aa-sdlc/AaFeatures.psm1`. Read the merged change and
   confirm it is at the head; if the ticket records a revision or page versions, compare them
   with the head and the pages now (O-13). If a scenario changed on its page after the change
   merged, document what the page says now and put the difference on the ticket as a question
   (T-12).
2. **Find where each kind of documentation lives.** Take the locations from the project config
   or the knowledge base: developer documentation in the documents folder, user documentation
   in the Guides section of the knowledge base under the project's own root, or the project's
   user documentation location (G-25, G-53). Read what already exists there for this feature
   before writing (G-03). If a location is not configured, ask or change the config; never
   invent one.
3. **Run the feature before describing it.** Start the software, from the repository's container
   definitions where possible, and walk each scenario as the user would. Where the software and
   the scenario disagree, put a question on the ticket; the documentation describes what the
   scenarios say and never papers over the gap (T-12).
4. **Write the user documentation from the scenarios,** for a reader with no context (G-24):
   what the user can now do, how, and what happens when it goes wrong, because that is when
   documentation is read. The scenarios live on the feature page: link to it, and where the page
   needs explanation, write it as prose around its tables, which the conversion ignores. Never
   restate a scenario in prose, since two copies drift, and never edit a feature file (G-18).
5. **Write the developer documentation** in the documents folder: where the feature lives, the
   configuration keys and environment templates it reads, any migration it needs, how it is
   tested at each tier, and how to run those tests from the root test script. Anything a fresh
   clone needs to build and run the feature that is not in the repository is a gap to fix or
   ticket (O-16, G-37).
6. **Link both ways.** Every page and document links to the ticket and the feature page, and the
   ticket and the page link back (G-26).
7. **Stage and present, then update the ticket.** Stage the documentation changes as one change
   set on a branch that references the ticket, with a docs-typed Conventional Commit message
   (G-33, G-39), present the staged diff and the message, and stop; commit only if the user
   asked for that commit (O-17, G-40). Update the ticket with what was written, where, and what
   remains (G-12). Then report.

## Artifacts

**Feature documentation** in the documents folder for developer docs; the knowledge base's Guides section, around the feature page, or the project's user documentation location for user docs. Done when:

- A user can do what the scenarios describe by following the user documentation
- A developer can find where the feature lives and how it is tested from the developer documentation
- Linked from the ticket and the feature page, and restates no scenario the page holds

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first and pull the feature pages it links to, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/repository-write.md`: What every step that changes files in the repository does: keep artifacts with the code, write Conventional Commit messages, one cohesive change per commit, stage and present rather than commit, and name the purpose of every change.

*For this step:*

- **G-37** Commit everything needed to build, deploy, and operate the software with the change that needs it: configuration templates, migrations, scripts, pipeline, infrastructure, container, and alert definitions, runbooks, and the development environment configuration. If a fresh clone plus the documented secrets could not build, deploy, and run the system after your change, something is missing from the repository; find it and commit it.
- **G-53** Put each knowledge base page under the project's own root, in the section its content belongs to (Overview, Requirements, Architecture, Operations, Releases, Guides, or the names the project config maps them to), name a requirement page after its feature and its feature id, and when a page is superseded mark it and link to what replaced it rather than deleting it.
- Write from the scenarios, verify against the software. The scenarios say what should happen; run the feature to confirm the documentation is describing what does.
- Document the unhappy path. Users read documentation when something went wrong.
- Never duplicate a scenario in prose. The feature page holds it; link to the page and write the explanation around it, since two copies drift.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
