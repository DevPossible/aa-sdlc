---
name: review-ux
description: "Use the built software the way a user would and record where the interaction fails the scenario, the prototype, or plain sense. Raises tickets for what it finds."
aa:
  discipline: ux-design
  step: review-ux
  guidance_sets: [every-step, anchored-step]
  guidance: [G-36]
  requires: [R-16, R-29]
---

# /aa-ux-review-ux

Use the built software the way a user would and record where the interaction fails the scenario, the prototype, or plain sense. Raises tickets for what it finds.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The deployed or locally running feature
- The scenarios and the prototype

## Procedure

1. **Anchor and check currency.** Read the anchor ticket, its linked scenarios, its page, and
   the prototype (G-22). Compare the feature files at head with the revision the ticket records
   (O-13) and note on the ticket any scenario that changed after the prototype was made, so a
   difference between them is not mistaken for a finding. Confirm the deployed or locally
   running feature is the build the ticket names.
2. **Follow the scenario literally first.** For each scenario with a user interface, do exactly
   the Given, When, Then as written and compare what happened with the Then and with the mockup
   that names the scenario (G-36). Record every difference as a finding.
3. **Then wander.** Use the feature the way a user would: the wrong order, the back button, an
   empty state, a second attempt, a slow response. Record every surprise as a finding, whether
   or not a scenario covers it.
4. **Write each finding to the standard.** Each names the scenario or flow, what was expected,
   what happened, and the severity, with a capture as evidence where it helps (T-07).
5. **Distinguish defect from design.** "It does not do what the scenario says" is a defect for
   Development. "The scenario was wrong" is a requirement change for Business Analysis, raised
   as a question on the ticket and changed in the feature file first, then the mock-up (G-36).
   Behaviour the mock-up shows that no scenario states is a question, not a defect.
6. **Raise the tickets.** Every finding with severity above cosmetic becomes a ticket in the
   configured ticket project, linked to this one (G-27). Cosmetic findings are listed on the
   page.
7. **Update the ticket.** Record the usability findings on the anchor ticket and the knowledge
   base page, linked both ways (G-26), with the tickets raised, what was not exercised, and what
   remains (G-12). Then report.

## Artifacts

**Usability findings** in the anchor ticket and the knowledge base page. Done when:

- Each finding names the scenario or flow, what was expected, what happened, and the severity
- Each finding with severity above cosmetic is a ticket

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

*For this step:*

- **G-36** Generate every mock-up from confirmed scenarios and name on it the scenarios it renders. Behaviour a mock-up shows that no scenario states is a question on the ticket, not a requirement; change the scenario first, then the mock-up (T-12).
- Follow the scenario literally first, then wander. The literal pass finds what was missed; the wander finds what was never imagined.
- Distinguish defect from design. "It does not do what the scenario says" goes to Development; "the scenario was wrong" goes to Business Analysis as a requirement change.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
