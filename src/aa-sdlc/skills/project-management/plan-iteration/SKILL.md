---
name: plan-iteration
description: "Commit a set of ready tickets to an iteration against known capacity, in priority order, and record the commitment and the risks in the ticket system."
aa:
  discipline: project-management
  step: plan-iteration
  guidance_sets: [every-step, anchored-step]
  guidance: [G-13, G-28]
  requires: [R-23]
---

# /aa-pm-plan-iteration

Commit a set of ready tickets to an iteration against known capacity, in priority order, and record the commitment and the risks in the ticket system.

## Anchor

A ticket is optional here. When one is given, read it, its linked scenarios, and its page first (G-22) and write the outcome back to it; when none is, produce the artifacts locally and say so.

## Inputs

- The ordered backlog and which tickets are ready
- Capacity for the iteration, whatever unit the team uses
- Carry-over from the previous iteration and its reasons

## Procedure

1. **Anchor.** With a ticket (the iteration or milestone, or the epic it serves), read it, its
   linked scenarios, and its page first (G-22) and write the plan back to it; without one, read
   the ordered backlog directly, write the plan locally, and say so. Read the carry-over from the
   previous iteration and the reason recorded against each item.
2. **Compute capacity.** Take the completed size from the last few iterations out of the ticket
   system and calculate the capacity with a tool, quoting the figures and the iterations they
   came from (G-02). Capacity is computed, not felt; a figure the user supplies is recorded
   beside the computed one and the difference is a stated assumption.
3. **Check each candidate is ready.** Walk the ordered backlog from the top. A ticket is a
   candidate only if it meets the definition of ready and its size cites the implementation
   thinking that grounds it (O-10, G-28); a ticket sized from its title, or carrying a labelled
   guess, is not committed and gets a note saying it needs refine-ticket first.
4. **Fill in priority order and stop at capacity.** Add candidates in order with a running total
   computed with a tool (G-02), and stop when the next item would exceed capacity. Never pull a
   lower item over a higher one because it is smaller unless the higher one is blocked; if a
   candidate depends on a ticket that is not committed, commit both or neither and record which.
5. **Record risks and assumptions** on the iteration: the capacity figures and their source,
   carry-over and its reasons, dependencies and blocked items, and any overage with who agreed
   it. Nothing uncertain is smoothed over.
6. **Present the commitment and ask.** The plan is a proposal until the people doing the work
   agree, whoever they are (T-06, T-13). Present the committed list, the total against capacity,
   and the risks, and do not move tickets into the iteration or announce it until it is agreed
   (G-13).
7. **Write the plan into the ticket system** once agreed, as the iteration or milestone with its
   committed tickets, and update the anchor ticket with what was committed, the capacity used,
   and what was left out and why (G-12). If the plan had to be written locally, stage it and
   present it; commit only if the user asked for that commit (O-17, G-40). Then report.

## Artifacts

**Iteration plan** in the ticket system, as the iteration or milestone with its committed tickets. Done when:

- Committed size does not exceed capacity, or the overage is explicit and agreed
- Every committed ticket is ready; none is blocked by an uncommitted one
- Risks and assumptions are recorded on the iteration

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-28** Before recording a size, write on the ticket how the work will be built (what changes, what is unknown, what could go wrong) at a depth that matches the stakes, and cite that reasoning from the size. If a number is needed before that thinking exists, give a range labelled as a guess, do not record it as the size, and never commit an iteration on it.
- Fill in priority order and stop at capacity. Do not pull a lower item over a higher one because it is smaller unless the higher one is blocked.
- Capacity is computed, not felt. Use the team's actual completed size from recent iterations, calculated with a tool (G-02).
- Commitment is a proposal until the people doing the work agree; present it and ask.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
