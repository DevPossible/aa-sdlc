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

*From the `repository-write` set:* What every step that changes files in the repository does: keep artifacts with the code, write Conventional Commit messages, one cohesive change per commit, stage and present rather than commit, and name the purpose of every change.

- **G-11** Every artifact that belongs with the code goes into the same change set as the code, staged for the commit the user makes (G-40). Nothing that matters is left only on a local disk or in a conversation.
- **G-33** Write every commit message in Conventional Commits form: a type from the project's list, an optional scope, an imperative subject, a body that says why, and a footer carrying the ticket reference and any breaking change. One concern per commit (G-39); if you cannot name the type, split the commit.
- **G-39** Make each commit one understandable change: one concern per commit, one ticket per branch, a subject that says what and a body that says why, small enough to review in one sitting. If the subject needs "and" or the diff needs a tour, split it.
- **G-40** Never commit unless the user asked for that commit. Stage the change, write the message, present the staged diff summary and the message, and stop; a request to implement, fix, finish, or run a step is not a request to commit, and the commit is made under the user's identity with no agent attribution.
- **G-42** Before making a change, name what it is for: the ticket, the scenario it satisfies, or the decision record or page that explains it, and put that reference where the change lives: the branch, the commit footer, the merge request, and the artifact. A change that cannot name its purpose is a ticket to create first or work not to do; in review, a hunk that traces to nothing is a finding.

*For this step:*

- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-41** Write every significant decision, technical, product, or process, as a decision record the moment it is made: one screen, numbered next in the repository's sequence, dated, with context, options considered, decision, and consequences, linked from the anchor ticket. Never edit an accepted record; supersede it with a new one that links back.
- **G-43** Design for the scenarios that exist, not the ones you expect: choose the simplest structure that satisfies them, and add an abstraction, extension point, configuration option, or feature only when a scenario requires it or a decision record justifies it, naming which. In review, code or structure that serves no scenario is a finding, and so is a fourth copy of the same code where one named thing would do.
- Short enough to read, complete enough to trust. One screen. If it needs more, the decision is several decisions.
- Record the losing options with the same care as the winner; the next person will ask about them first.
- Write it when it happens. A decision reconstructed a month later is a story, not a record.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
