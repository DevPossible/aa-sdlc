---
name: decide
description: "Record one significant technical decision: the context, the options, the choice, and the consequences, so the next person can understand it without asking. Standalone so that decisions made mid-implementation are captured too."
aa:
  discipline: technical-analysis
  step: decide
  guidance_sets: [every-step, anchored-step, repository-write]
  guidance: [G-16, G-41, G-43]
  requires: [R-03, R-06, R-32, R-34]
---

# /aa-ta-decide

Record one significant technical decision: the context, the options, the choice, and the consequences, so the next person can understand it without asking. Standalone so that decisions made mid-implementation are captured too.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The decision to be made or just made, and the anchor ticket it arose from
- Existing decision records that touch the same area

## Procedure

1. **Anchor.** Read the ticket the decision arose from, its linked scenarios, and its knowledge
   base page (G-22). State the decision in one sentence: what is being chosen, and for which
   scenario or constraint. If it will not fit in one sentence it is several decisions; record
   each on its own.
2. **Read the records that touch the same area.** Find the existing decision records and the
   next number in the repository sequence. If an accepted record already answers the question,
   cite it on the ticket and stop; if this decision reverses one, name the record it will
   supersede (O-18).
3. **Set out the options.** Every option seriously considered, with what it costs and what it
   gives in the terms the scenarios care about. Record the losing options with the same care as
   the winner; the next reader will ask about them first. Prefer the simplest option that meets
   the scenarios that exist; an option chosen for a scenario that does not exist yet says so
   (O-20, G-43).
4. **Write the record.** One screen: number, date, status, context, options considered, the
   decision, and its consequences including what becomes harder. Assumptions and unverified
   claims are stated as such (G-16). Put it where the project config names, the knowledge base
   or the documents folder as a numbered record (G-25, G-41), written for a reader with no
   context (G-24).
5. **Supersede rather than edit.** If this record replaces an accepted one, the new record names
   the one it supersedes and links back to it. The old record is not changed; once accepted, a
   record is immutable (O-18).
6. **Link both ways.** The record links to the ticket and the ticket links to the record (G-26).
   Anything the decision leaves open becomes a question on the ticket (G-16).
7. **Update the ticket and present the change.** Record on the ticket what was decided, the
   record's number, and what remains (G-12). If the record lives in the repository, stage it,
   write a Conventional Commit message naming the ticket (G-33), present the staged diff and
   the message, and stop; commit only if the user asked for that commit (O-17, G-40).

## Artifacts

**Decision record** in the knowledge base, or the documents folder as a numbered record, linked from the ticket. Done when:

- States context, options considered, the decision, and consequences
- Is numbered next in the repository sequence, dated, and immutable once accepted; a reversal is a new record that supersedes it and links back (O-18)

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/repository-write.md`: What every step that changes files in the repository does: keep artifacts with the code, write Conventional Commit messages, one cohesive change per commit, stage and present rather than commit, and name the purpose of every change.

*For this step:*

- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-41** Write every significant decision, technical, product, or process, as a decision record the moment it is made: one screen, numbered next in the repository's sequence, dated, with context, options considered, decision, and consequences, linked from the anchor ticket. Never edit an accepted record; supersede it with a new one that links back.
- **G-43** Design for the scenarios that exist, not the ones you expect: choose the simplest structure that satisfies them, and add an abstraction, extension point, configuration option, or feature only when a scenario requires it or a decision record justifies it, naming which. In review, code or structure that serves no scenario is a finding, and so is a fourth copy of the same code where one named thing would do.
- Short enough to read, complete enough to trust. One screen. If it needs more, the decision is several decisions.
- Record the losing options with the same care as the winner; the next person will ask about them first.
- Write it when it happens. A decision reconstructed a month later is a story, not a record.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
