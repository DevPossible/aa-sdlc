---
name: define-outcome
description: "Write down what an initiative is meant to achieve and how we will know. Produces the anchor epic with a measurable outcome, so every later step can answer \"does this serve the outcome\"."
aa:
  discipline: product-management
  step: define-outcome
  guidance_sets: [every-step, anchored-step]
  guidance: [G-16, G-35, G-41]
  requires: [R-29, R-32]
---

# /aa-pd-define-outcome

Write down what an initiative is meant to achieve and how we will know. Produces the anchor epic with a measurable outcome, so every later step can answer "does this serve the outcome".

## Anchor

A ticket is optional here. When one is given, read it, its linked scenarios, and its page first (G-22) and write the outcome back to it; when none is, produce the artifacts locally and say so.

## Inputs

- The idea, request, or problem statement
- Existing roadmap and outcomes, to avoid duplicates and find conflicts

## Procedure

1. **Anchor.** Read the idea, request, or problem statement as it was given. When a ticket is
   given, read it, its linked scenarios, and its page first (G-22); when none is, say so and
   produce the epic locally. Read the existing roadmap and outcomes and list any outcome this
   one duplicates or conflicts with before writing a new one.
2. **Start from goals, whatever arrived.** If the request arrived as a screenshot, a mock-up, or
   a list of features, treat it as evidence of what someone wants: write the goal it implies
   and record on the ticket what it does not show as questions (G-35, O-15). No mock-up is
   produced here.
3. **State the outcome as a change in a measure.** Name who benefits and what they can do
   afterwards that they cannot do now. If the statement could be satisfied by shipping something
   nobody uses, rewrite it until it cannot.
4. **Put a number on it.** Name the success metric, its current value, and the target. Measure
   the current value where the data exists, computing it with a tool (G-02); where it does not,
   estimate it and label the estimate as one (G-16).
5. **Draw the boundary.** Say in the same place what is out of scope, so refinement does not
   have to guess, and list the assumptions the outcome rests on (G-16).
6. **Record the decision.** Where choosing this outcome over an alternative was a significant
   product decision, write it as a decision record, numbered next in the repository's sequence
   and linked from the epic (G-41, O-18).
7. **Update the epic.** Create or update the anchor epic in the ticket system with the outcome,
   metric, baseline, target, scope, and open questions, linked both ways to its page and any
   decision record (G-12, G-26). Where a decision record was written into the repository, stage
   it and present the summary with a Conventional Commit message; commit only if the user asked
   for that commit (O-17, G-40). Then report.

## Artifacts

**Anchor epic** in the ticket system. Done when:

- States the outcome as a change in a measure, not a list of features
- Names the success metric, its current value, and the target
- Names who benefits and what they can do afterwards that they cannot do now

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-35** Start every requirement from written goals: the outcome, then the scenarios. When a screenshot or mock-up arrives first, treat it as evidence of what someone wants: write the goals and scenarios it implies, record what it does not show as questions on the ticket, get them confirmed, and only then produce a mock-up from them.
- **G-41** Write every significant decision, technical, product, or process, as a decision record the moment it is made: one screen, numbered next in the repository's sequence, dated, with context, options considered, decision, and consequences, linked from the anchor ticket. Never edit an accepted record; supersede it with a new one that links back.
- Outcome, not output. If the statement can be satisfied by shipping something nobody uses, rewrite it until it cannot.
- Put a number on it. A metric with no baseline is a wish; measure or estimate the current value and say which.
- Say what is out of scope in the same place, so refinement does not have to guess.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
