---
name: plan-implementation
description: "Before building a ticket, write down how: which files and components change, in what order, what tests prove each step, what could go wrong, and what is still unknown. The plan lives on the ticket and is confirmed before build starts."
aa:
  discipline: implementation-planning
  step: plan-implementation
  guidance_sets: [every-step, anchored-step]
  guidance: [G-08, G-16, G-23, G-28, G-31, G-32, G-43]
  requires: [R-05, R-16, R-23, R-27, R-34]
---

# /aa-ip-plan-implementation

Before building a ticket, write down how: which files and components change, in what order, what tests prove each step, what could go wrong, and what is still unknown. The plan lives on the ticket and is confirmed before build starts.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The ready ticket, its scenarios, and the implementation thinking its size was based on
- The architecture, decision records, and technical constraints
- The current code, read, not remembered
- What changed in the linked feature files and the code since the ticket was refined (O-13)

## Procedure

1. **Anchor and check currency.** Read the ticket, its scenarios, and the implementation thinking
   its size was based on. Compare the repository at the revision the ticket was refined against
   with the head, filtered to the linked feature files and the code the ticket touches, and say
   what changed and whether the scenarios still hold before planning against them (O-13).
2. **Read the code you will change.** The actual files, the architecture, the decision records,
   and the technical constraints; a plan written from the diagram alone will meet the real code
   and lose.
3. **Write the plan on the ticket.** The changes in build order, each with the test that proves
   it; the tiers of test the change touches (O-07); the risks and unknowns and how each will be
   resolved or accepted. Plan the smallest change that makes the scenarios pass; a step that
   adds an option, a generalisation, or a feature no scenario needs comes out (O-20). Order the
   steps so that stopping after any one leaves the system working. Time-box any unknown you
   must investigate and record what you found either way (G-23); an unknown bigger than the
   ticket goes to a spike or a decision, not into the plan.
4. **Check the size against the plan.** If the plan reveals more than the sizing reasoning saw,
   revise the size on the ticket and say why (O-10). If the plan is longer than the change, the
   ticket is too big: hand it back to refinement to split.
5. **Record the revision** the plan was written against, on the ticket (G-31).
6. **Present the plan for confirmation** by the user or the ticket owner. Implementation does
   not start on an unconfirmed plan; if it changes, the change is on the ticket, not in a
   conversation.
7. **Update the ticket** with the plan, its status, and what remains (G-12). Then report.

## Artifacts

**Implementation plan** in the anchor ticket. Done when:

- Lists the changes in build order, each with the test that proves it
- Names the risks and unknowns, and how each will be resolved or accepted
- Says which tiers of test the change touches (O-07)
- Confirmed by the user or the ticket owner before implement runs
- Records the repository revision it was written against (O-13)

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-08** Before any multi-step change, write the plan and get it confirmed; one concern per commit and one ticket per branch is G-39.
- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-23** State a time box for any open-ended investigation before starting it, stop when it is reached, and report what was found either way.
- **G-28** Before recording a size, write on the ticket how the work will be built (what changes, what is unknown, what could go wrong) at a depth that matches the stakes, and cite that reasoning from the size. If a number is needed before that thinking exists, give a range labelled as a guess, do not record it as the size, and never commit an iteration on it.
- **G-31** When a ticket is refined or its plan is confirmed, record on the ticket the repository revision its scenarios and plan were checked against.
- **G-32** Before starting work on a ticket, compare the repository at the revision recorded on the ticket with the current head, list the changes to the linked feature files and to the files the plan names, and record on the ticket whether the scenarios and plan still hold. A conflict goes back to refinement as a question on the ticket; never absorb it silently or start anyway without saying so.
- **G-43** Design for the scenarios that exist, not the ones you expect: choose the simplest structure that satisfies them, and add an abstraction, extension point, configuration option, or feature only when a scenario requires it or a decision record justifies it, naming which. In review, code or structure that serves no scenario is a finding, and so is a fourth copy of the same code where one named thing would do.
- Read the code you will change before planning the change. A plan written from the architecture diagram alone will meet the real code and lose.
- Check the ticket against the repository first. If the feature files or the code moved since refinement, say what changed and whether the scenarios still hold before planning against them (O-13).
- Plan the tests with the steps. A step with no test is a step you cannot know is done.
- Plan the smallest change that makes the scenarios pass. A step that adds an option, a generalisation, or a feature no scenario needs comes out of the plan (O-20).
- Prefer the plan that can be abandoned halfway. Order changes so that stopping after any step leaves the system working.
- If the plan is longer than the change, the ticket is too big; hand it back to Refinement to split.
- Check the size against the plan. If the plan reveals more than the sizing reasoning saw, revise the size on the ticket and say why (O-10).

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
