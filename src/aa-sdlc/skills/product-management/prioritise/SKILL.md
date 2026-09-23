---
name: prioritise
description: "Order epics and stories by value against the outcome, risk, and dependency, and record why. The ordered backlog lives in the ticket system; the reasoning lives on the tickets."
aa:
  discipline: product-management
  step: prioritise
  guidance_sets: [every-step, anchored-step]
  guidance: [G-28, G-41]
  requires: [R-23, R-32]
---

# /aa-pd-prioritise

Order epics and stories by value against the outcome, risk, and dependency, and record why. The ordered backlog lives in the ticket system; the reasoning lives on the tickets.

## Anchor

A ticket is optional here. When one is given, read it, its linked scenarios, and its page first (G-22) and write the outcome back to it; when none is, produce the artifacts locally and say so.

## Inputs

- The backlog as it stands in the ticket system
- Outcomes and metrics from define-outcome
- Dependencies and risks surfaced by Refinement, Technical Analysis, and Security

## Procedure

1. **Anchor.** Read the backlog as it stands in the ticket system, the outcomes and metrics from
   define-outcome, and the dependencies and risks Refinement, Technical Analysis, and Security
   have recorded on the tickets. When an anchor ticket is given, read it, its scenarios, and its
   page first (G-22). Write down the current order before changing anything, so every move can
   be seen.
2. **Score each item against the outcome.** For every epic and story, write a one-line reason on
   the ticket: which outcome it serves and by how much, what risk or unknown it retires, and
   what it costs. Rank by outcome contribution first, then risk reduction, then cost; when two
   tie, prefer the one that retires an unknown.
3. **Use only grounded sizes.** A size counts only where the ticket records the implementation
   thinking behind it (G-28, O-10). Where it does not, rank on a range labelled as a guess, say
   so on the ticket, and note that the size needs grounding before an iteration is committed on
   it.
4. **Order by dependency.** Rank every item blocked by another after the item that blocks it,
   with the dependency as a link between the tickets rather than prose.
5. **Check the top.** The top of the backlog is ready or in refinement, not raw ideas. Where a
   raw idea ranks high on value, send it to refinement with a note on the ticket rather than
   leaving it at the top.
6. **Ask before demoting.** If an item someone is working on would drop out of the iteration,
   stop and ask; that is a conversation, not a rank change (T-06). A demotion of committed work
   is written as a decision record, numbered next in the repository's sequence (G-41, O-18).
7. **Apply and record every move.** Change the ranks in the ticket system and comment on each
   moved ticket saying what moved and why; nothing is reordered silently. Update the anchor
   ticket, when there is one, with the new order, the decision records, and what remains
   (G-12). Where a decision record was written into the repository, stage it and present the
   summary with a Conventional Commit message; commit only if the user asked for that commit
   (O-17, G-40). Then report.

## Artifacts

**Ordered backlog** in the ticket system. Done when:

- Every item has a rank and a one-line reason on the ticket
- Items blocked by a dependency are ranked after what blocks them
- The top of the backlog is ready or in refinement, not raw ideas

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-28** Before recording a size, write on the ticket how the work will be built (what changes, what is unknown, what could go wrong) at a depth that matches the stakes, and cite that reasoning from the size. If a number is needed before that thinking exists, give a range labelled as a guess, do not record it as the size, and never commit an iteration on it.
- **G-41** Write every significant decision, technical, product, or process, as a decision record the moment it is made: one screen, numbered next in the repository's sequence, dated, with context, options considered, decision, and consequences, linked from the anchor ticket. Never edit an accepted record; supersede it with a new one that links back.
- Rank by outcome contribution first, then risk reduction, then cost. When two items tie, prefer the one that retires an unknown.
- Never reorder silently. Every change of rank is a comment on the ticket saying what moved and why, and a demotion of committed work is a decision record (O-18).
- Ask before demoting. If an item someone is working on drops out of the iteration, that is a conversation, not a rank change.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
