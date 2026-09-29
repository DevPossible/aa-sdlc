---
name: refine-requirements
description: "Close the gaps. Turn draft scenarios into complete, unambiguous, testable ones; record the technical constraints they must live within; link every scenario to its ticket and page."
aa:
  discipline: business-analysis
  step: refine-requirements
  guidance_sets: [every-step, anchored-step, repository-write]
  guidance: [G-16, G-18, G-19, G-35, G-49, G-53]
  requires: [R-16, R-29, R-42]
---

# /aa-ba-refine-requirements

Close the gaps. Turn draft scenarios into complete, unambiguous, testable ones; record the technical constraints they must live within; link every scenario to its ticket and page.

## Anchor

Anchor first (G-22). Read the anchor ticket and its knowledge base page, and pull the feature pages it links to into the features folder (G-54), before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- Draft scenarios on their feature pages and the question log from discover
- Answers from stakeholders
- Technical constraints from Technical Analysis and Security, if available

## Procedure

1. **Anchor.** Read the anchor ticket, its linked draft scenarios, and its page (G-22). Pull the
   feature pages the ticket links to: their Approved scenarios into the features folder and the
   page versions onto the ticket (G-54), with
   `scripts/aa-sdlc/Sync-FeatureFiles.ps1 -KnowledgeRoot <folder> -FeaturesRoot <features>` for a
   documents-folder knowledge base, or by reading each page and converting it with
   `ConvertFrom-FeaturePage` from `scripts/aa-sdlc/AaFeatures.psm1`. Read the question log from
   discover, the answers stakeholders have given, and the technical constraints from Technical
   Analysis and Security where they exist. Read each feature page immediately before changing
   it (G-03).
2. **Apply the answers.** For each answered question, change the scenario on its feature page
   first, under the project's own root only (G-18, G-55, T-12); the ticket's acceptance criteria
   follow the page. Never edit the ticket first, and never edit a feature file: the repository
   gets the change by pulling the page. A question still open stays on the ticket with an owner
   (G-16).
3. **Goals before pictures.** Where an answer arrived as a mock-up or screenshot, write the
   scenario it implies and log what it does not show as a question; the picture is evidence,
   not the requirement (G-35, O-15).
4. **One behaviour per scenario.** Split any scenario whose Then describes two outcomes that
   could fail independently. Replace every "should work correctly" with concrete Given, When,
   Then steps.
5. **Make it executable in principle.** Every step names something a test could observe; a step
   that cannot be observed is rewritten or recorded as a question, never left as a hope. A new
   feature or scenario leaves its id cell empty until ids are assigned: run
   `scripts/aa-sdlc/Add-FeatureId.ps1 -KnowledgeRoot <folder>` for a documents-folder knowledge
   base, or give each the next free id on the page yourself (G-49).
6. **Approve what the stakeholder confirms.** When the stakeholder confirms a scenario, set its
   Status to Approved and tag it with its ticket; a scenario still in question stays Draft, and
   one no longer wanted is Retired, never deleted (G-19, O-01). Then pull the page, so the
   Approved scenarios reach the features folder with their provenance header (G-54).
7. **Record the constraints.** Write the technical constraints document in the knowledge base,
   linked from the epic: the platform, integration, compliance, and performance constraints the
   scenarios must satisfy, each with its source. A constraint that contradicts a scenario is a
   question on the ticket, not a silent edit.
8. **Update the ticket and present the change.** Link the ticket to each feature page and the
   ids of its scenarios, and each page back (G-19, G-26). Update the ticket with which
   ambiguities were resolved, which remain as open questions, and what remains (G-12). Stage the
   pulled feature files, and the changed pages where they are in the documents folder, and
   present the summary with a Conventional Commit message; commit only if the user asked for
   that commit (O-17, G-40). Then report.

## Artifacts

**Feature pages** in the knowledge base under the project's Requirements section (in the documents folder where no knowledge base is in scope). Done when:

- Every scenario has concrete Given, When, Then steps with no "should work correctly"
- Every scenario the stakeholder confirmed is Approved and tagged with its ticket; the ticket links to the page and the scenario ids
- Ambiguities are resolved or recorded as open questions on the ticket

**Technical constraints document** in the knowledge base, linked from the epic. Done when:

- Lists the constraints (platform, integration, compliance, performance) the scenarios must satisfy, each with its source

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
- **G-53** Put each knowledge base page under the project's own root, in the section its content belongs to (Overview, Requirements, Architecture, Operations, Releases, Guides, or the names the project config maps them to), name a requirement page after its feature and its feature id, and when a page is superseded mark it and link to what replaced it rather than deleting it.
- One behaviour per scenario. If a scenario needs "and" in its Then to describe two outcomes that could fail independently, split it.
- Make it executable in principle. Every step must be something a test could observe; if it cannot be observed, it is not a requirement, it is a hope.
- Trace every change. Change the scenario on its feature page first; the ticket's acceptance criteria follow the page and the repository gets the change by pulling it (T-12). Never edit the ticket first, and never edit a feature file.
- A scenario is Approved when the stakeholder confirms it, not when it reads well. Until then it stays Draft on the page and never reaches the repository.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
