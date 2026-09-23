---
name: refine-ticket
description: "Bring one ticket to the definition of ready: scenarios linked and complete, acceptance criteria checkable, size agreed, dependencies clear, questions answered or owned."
aa:
  discipline: refinement
  step: refine-ticket
  guidance_sets: [every-step, anchored-step]
  guidance: [G-16, G-18, G-28, G-31]
  requires: [R-16, R-23, R-27]
---

# /aa-rf-refine-ticket

Bring one ticket to the definition of ready: scenarios linked and complete, acceptance criteria checkable, size agreed, dependencies clear, questions answered or owned.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The ticket and its linked scenarios
- Open questions on the ticket
- The team's definition of ready from the project config or knowledge base

## Procedure

1. **Anchor.** Read the scenarios before the ticket description: the description is what
   someone thought, the scenarios are what was agreed. Read the open questions and the team's
   definition of ready from the project config or knowledge base.
2. **Scenarios linked and complete.** Every scenario the ticket delivers is in a feature file,
   tagged with the ticket, and concrete enough to test. The acceptance criteria are the
   scenarios, never a restatement. A gap found here goes back to Business Analysis as a
   question on the ticket, never forward as a guess (G-18).
3. **Dependencies and questions.** Dependencies are links to other tickets, not prose. Every
   open question has an answer or an owner (G-16). A ticket with an unanswered question that
   changes the scope is not ready, however small it looks.
4. **Size from the thinking, not the title.** Before any number, write on the ticket what
   changes, what is unknown, and what could go wrong, at a depth that matches the stakes: a
   sentence for a small change, a request for plan-implementation for a large one. Record the
   size citing that reasoning (O-10). If a number is asked for before the thinking exists, give
   a labelled range and do not record it as the size.
5. **Record the revision** the scenarios were checked against, so the step that picks the
   ticket up can see what moved (O-13, G-31).
6. **Say whether it is ready.** Either it meets every item of the definition of ready, or the
   ticket says which item it does not and why it proceeds anyway. Neither is hidden.
7. **Update the ticket** with the outcome and what remains (G-12). Then report.

## Artifacts

**Ready ticket** in the ticket system. Done when:

- Meets every item of the definition of ready, or says which item it does not and why it proceeds anyway
- Acceptance criteria are the scenarios, not a restatement of them
- Size is recorded with the implementation thinking that grounds it, and cites it
- Records the repository revision the scenarios were checked against (O-13)

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-28** Before recording a size, write on the ticket how the work will be built (what changes, what is unknown, what could go wrong) at a depth that matches the stakes, and cite that reasoning from the size. If a number is needed before that thinking exists, give a range labelled as a guess, do not record it as the size, and never commit an iteration on it.
- **G-31** When a ticket is refined or its plan is confirmed, record on the ticket the repository revision its scenarios and plan were checked against.
- Read the scenarios before the ticket description. The description is what someone thought; the scenarios are what was agreed.
- Size from the thinking, not the title. Before putting a number on it, write on the ticket what changes, what is unknown, and what could go wrong, at a depth that matches the stakes; a sentence for a small change, a full plan-implementation for a large one (O-10).
- A ticket with an unanswered question that changes the scope is not ready, however small it looks.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
