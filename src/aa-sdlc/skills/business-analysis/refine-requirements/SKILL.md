---
name: refine-requirements
description: "Close the gaps. Turn draft scenarios into complete, unambiguous, testable ones; record the technical constraints they must live within; link every scenario to its ticket and page."
aa:
  discipline: business-analysis
  step: refine-requirements
  guidance_sets: [every-step, anchored-step, repository-write]
  guidance: [G-16, G-18, G-19, G-35]
  requires: [R-03, R-16, R-29]
---

# /aa-ba-refine-requirements

Close the gaps. Turn draft scenarios into complete, unambiguous, testable ones; record the technical constraints they must live within; link every scenario to its ticket and page.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- Draft scenarios and the question log from discover
- Answers from stakeholders
- Technical constraints from Technical Analysis and Security, if available

## Procedure

1. **Anchor.** Read the anchor ticket, its linked draft scenarios, and its page (G-22). Read the
   question log from discover, the answers stakeholders have given, and the technical
   constraints from Technical Analysis and Security where they exist. Read each feature file at
   head immediately before editing it (G-03).
2. **Apply the answers.** For each answered question, change the scenario in its feature file
   first; the ticket's acceptance criteria and the page follow through the tooling (G-18,
   T-12). Never edit the ticket first. A question still open stays on the ticket with an owner
   (G-16).
3. **Goals before pictures.** Where an answer arrived as a mock-up or screenshot, write the
   scenario it implies and log what it does not show as a question; the picture is evidence,
   not the requirement (G-35, O-15).
4. **One behaviour per scenario.** Split any scenario whose Then describes two outcomes that
   could fail independently. Replace every "should work correctly" with concrete Given, When,
   Then steps.
5. **Make it executable in principle.** Every step names something a test could observe; a step
   that cannot be observed is rewritten or recorded as a question, never left as a hope. Tag
   every scenario with its ticket and name the knowledge base page in the feature description
   (G-19, O-01).
6. **Record the constraints.** Write the technical constraints document in the knowledge base,
   linked from the epic: the platform, integration, compliance, and performance constraints the
   scenarios must satisfy, each with its source. A constraint that contradicts a scenario is a
   question on the ticket, not a silent edit.
7. **Update the ticket and present the change.** Link ticket, feature file, and page both ways
   (G-26). Update the ticket with which ambiguities were resolved, which remain as open
   questions, and what remains (G-12). Stage the changed feature files and present the summary
   with a Conventional Commit message; commit only if the user asked for that commit (O-17,
   G-40). Then report.

## Artifacts

**Feature files** in the features folder. Done when:

- Every scenario has concrete Given, When, Then steps with no "should work correctly"
- Every scenario is tagged with its ticket; every feature names its knowledge base page
- Ambiguities are resolved or recorded as open questions on the ticket

**Technical constraints document** in the knowledge base, linked from the epic. Done when:

- Lists the constraints (platform, integration, compliance, performance) the scenarios must satisfy, each with its source

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/repository-write.md`: What every step that changes files in the repository does: keep artifacts with the code, write Conventional Commit messages, one cohesive change per commit, stage and present rather than commit, and name the purpose of every change.

*For this step:*

- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-19** Tag every scenario with its anchor ticket, and name the feature's knowledge base page in the feature description.
- **G-35** Start every requirement from written goals: the outcome, then the scenarios. When a screenshot or mock-up arrives first, treat it as evidence of what someone wants: write the goals and scenarios it implies, record what it does not show as questions on the ticket, get them confirmed, and only then produce a mock-up from them.
- One behaviour per scenario. If a scenario needs "and" in its Then to describe two outcomes that could fail independently, split it.
- Make it executable in principle. Every step must be something a test could observe; if it cannot be observed, it is not a requirement, it is a hope.
- Trace every change. When a scenario changes, the ticket's acceptance criteria and the page follow (T-12); never edit the ticket first.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
