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

- **G-28** Before recording a size, write on the ticket how the work will be built (what changes, what is unknown, what could go wrong) at a depth that matches the stakes, and cite that reasoning from the size. If a number is needed before that thinking exists, give a range labelled as a guess, do not record it as the size, and never commit an iteration on it.
- **G-41** Write every significant decision, technical, product, or process, as a decision record the moment it is made: one screen, numbered next in the repository's sequence, dated, with context, options considered, decision, and consequences, linked from the anchor ticket. Never edit an accepted record; supersede it with a new one that links back.
- Rank by outcome contribution first, then risk reduction, then cost. When two items tie, prefer the one that retires an unknown.
- Never reorder silently. Every change of rank is a comment on the ticket saying what moved and why, and a demotion of committed work is a decision record (O-18).
- Ask before demoting. If an item someone is working on drops out of the iteration, that is a conversation, not a rank change.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
