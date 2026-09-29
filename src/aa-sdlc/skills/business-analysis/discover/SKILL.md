---
name: discover
description: "Capture what stakeholders need, as they say it and as they mean it. Produces the initial requirements as draft scenarios and a question log of everything not yet answered."
aa:
  discipline: business-analysis
  step: discover
  guidance_sets: [every-step, anchored-step, repository-write]
  guidance: [G-16, G-18, G-19, G-35, G-49]
  requires: [R-16, R-29]
---

# /aa-ba-discover

Capture what stakeholders need, as they say it and as they mean it. Produces the initial requirements as draft scenarios and a question log of everything not yet answered.

## Anchor

Anchor first (G-22). Read the anchor ticket and its knowledge base page, and pull the feature pages it links to into the features folder (G-54), before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The anchor epic and its outcome
- Stakeholder input: a conversation, a transcript, a document, or a session with the user
- Existing system documentation and the project's feature pages
- Any screenshot or mock-up offered as the request, treated as evidence rather than as the requirement (O-15)

## Procedure

1. **Anchor.** Read the anchor epic and its outcome, its linked scenarios, and its knowledge
   base page (G-22). Pull the feature pages the epic links to: their Approved scenarios into the
   features folder and the page versions onto the epic (G-54), with
   `scripts/aa-sdlc/Sync-FeatureFiles.ps1 -KnowledgeRoot <folder> -FeaturesRoot <features>` for a
   documents-folder knowledge base, or by reading each page and converting it with
   `ConvertFrom-FeaturePage` from `scripts/aa-sdlc/AaFeatures.psm1`. Read the existing feature
   pages under the project's own root and the system documentation for the area, so a need
   already stated is recognised rather than written twice; read nothing from another project's
   pages as this project's (G-55).
2. **Take the input as it arrives.** A conversation, a transcript, a document, or a session with
   the user. If it arrives as a screenshot or mock-up, treat it as a witness, not a
   specification: write the goals and scenarios it implies and log what it does not show as
   questions (G-35, O-15). The mock-up is regenerated from the confirmed scenarios later.
3. **Write it as Gherkin from the first pass.** Capture each stated need as a Draft scenario on
   a feature page in the knowledge base, at `<project root>/Requirements/<topic>/<feature>`, in
   the page format (O-01, T-12): the feature table, then a scenario table and step table per
   scenario, tagged with the epic, with the business objectives and scope boundaries in the
   feature's description. Where no knowledge base is in scope, the page is a markdown file at
   `docs/knowledge/Requirements/<topic>/<feature>.md` in the same format. Create and change
   pages only under the project's own root (G-55). Leave the id cell of a new feature or
   scenario empty and assign the ids once the page is written: run
   `scripts/aa-sdlc/Add-FeatureId.ps1 -KnowledgeRoot <folder>` for a documents-folder knowledge
   base, or give each the next free id on the page yourself (G-49). Never write a feature file:
   the repository gets a scenario by pulling its page once the scenario is Approved (G-18). A
   need that is out of scope is recorded as an explicit non-requirement, not dropped.
4. **Ask the confirming question, not the leading one.** Where the input is ambiguous, ask
   "What happens when X?" rather than "So when X happens you need Y?", and record the answer as
   a scenario or as a question.
5. **Record what was not said.** Silence on error cases, permissions, and edge conditions is a
   question, not an assumption. Put every question in the question log on the anchor epic with
   its context and an owner (G-16).
6. **Check where the truth lives.** Every stated need is now a scenario or an explicit
   non-requirement on a feature page; nothing lives only in the ticket, a feature file, or the
   conversation. A requirement found only in the ticket, or in a feature file no page generates,
   is raised as a conflict, never absorbed (G-18).
7. **Update the epic and present the change.** Link the epic to each feature page and its
   scenario ids, and each page back (G-19, G-26). Update the epic with what was captured, the
   question log, and what remains (G-12). Where the pages are in the documents folder, stage the
   new and changed pages and present the summary with a Conventional Commit message; commit only
   if the user asked for that commit (O-17, G-40). Then report.

## Artifacts

**Initial requirements** in the knowledge base, as Draft scenarios on feature pages under the project's Requirements section (in the documents folder where no knowledge base is in scope), tagged with the epic. Done when:

- Every stated need is a scenario or an explicit non-requirement
- Business objectives and scope boundaries appear in the feature description
- Every feature and scenario has its id, and the epic links to each page and its scenario ids

**Question log** in the anchor epic, as open questions. Done when:

- Every unanswered question has context and an owner

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first and pull the feature pages it links to, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/repository-write.md`: What every step that changes files in the repository does: keep artifacts with the code, write Conventional Commit messages, one cohesive change per commit, stage and present rather than commit, and name the purpose of every change.

*For this step:*

- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-18** Change a requirement on its feature page in the knowledge base, under the ticket that asks for it, then pull the page into the repository. Never edit a feature file by hand; a change found while building is converted to the page format and proposed on the page for its owner to approve.
- **G-19** Tag every Approved scenario on its feature page with the ticket that asked for it, and link the ticket to the page and the scenario ids.
- **G-35** Start every requirement from written goals: the outcome, then the scenarios. When a screenshot or mock-up arrives first, treat it as evidence of what someone wants: write the goals and scenarios it implies, record what it does not show as questions on the ticket, get them confirmed, and only then produce a mock-up from them.
- **G-49** Give every feature a stable id (F-nnn) and every scenario one derived from it (F-nnn-nn), assigned on its feature page once and never renumbered or reused; tag or name every automated test with the ids of the scenarios it proves, so coverage is the set of scenario ids that at least one test names.
- Write it as Gherkin from the first pass. A requirement captured in prose has to be translated later and loses something each time; a Draft scenario on a feature page can be wrong in a way everyone can see, and the repository gets it only once it is Approved.
- Ask the confirming question, not the leading one. "So when X happens you need Y?" invites agreement; "What happens when X?" invites the truth.
- Record what was not said. Silence on error cases, permissions, and edge conditions is a question, not an assumption.
- A picture is a witness, not a specification. When the request arrives as a screenshot or mock-up, write the goals and scenarios it implies, log what it does not show as questions, and let the mock-up be regenerated from the confirmed scenarios later (O-15).

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
