---
name: discover-doctrines
description: "Read what an existing product already shows about what it is for, in its code, documents, decision records, and tickets, and propose a mission, who it is for, candidate doctrines, and non-goals, each with the evidence it was drawn from. It proposes; it writes no doctrine."
aa:
  discipline: product-management
  step: discover-doctrines
  guidance_sets: [every-step, anchored-step]
  guidance: [G-16, G-58]
  requires: [R-48]
---

# /aa-pd-discover-doctrines

Read what an existing product already shows about what it is for, in its code, documents, decision records, and tickets, and propose a mission, who it is for, candidate doctrines, and non-goals, each with the evidence it was drawn from. It proposes; it writes no doctrine.

## Anchor

A ticket is optional here. When one is given, read it and its page and pull the feature pages it links to first (G-22, G-54) and write the outcome back to it; when none is, produce the artifacts locally and say so.

## Inputs

- The repository's README, documents folder, and decision records
- The code, for what it does and what it conspicuously does not do
- The knowledge base pages under the project's root, including any doctrines page that already exists
- The epics and recent tickets in the ticket project, through the project's ticket filter

## Procedure

1. **Anchor.** When a ticket is given, read it and its page first (G-22); when none is, say so
   and return the proposal to the user only. Read the Overview section under the project's
   knowledge root. If a doctrines page already exists, read it: from here on propose only what
   it misses or what the project now contradicts.
2. **Read what the project says about itself.** The README, the documents folder, the
   knowledge base pages under the project's root, and every decision record. Note each
   statement of purpose, audience, principle, or scope with where it was found.
3. **Read what it built.** Survey the code for what it does, who it serves, and what it
   conspicuously does not do. Read the epics and recent tickets through the project's ticket
   filter, including those closed as rejected or out of scope. Note each with where it was found.
4. **Find the non-goals.** Collect what the product deliberately leaves out: options rejected
   in decision records, tickets closed as out of scope, scope notes on epics.
5. **Draft the proposal.** A one-sentence mission, who the product is for, three to seven
   candidate doctrines, and the non-goals. Each candidate is one sentence a requirement could be
   checked against, with the evidence it came from and whether it is stated or inferred. Drop a
   candidate no conceivable requirement could violate.
6. **List the contradictions.** Where a stated aim and the code, or two sources, disagree,
   list both sides with their evidence rather than choosing between them (G-16).
7. **Stop short of writing.** Change no doctrines page and assign no `D-nn` id. Return the
   proposal, write it on the anchor ticket when one is given (G-12), and recommend
   `/aa-pd-define-doctrines` to adopt it, or `/aa-pd-amend-doctrines` for each change where
   doctrines already exist. Where there was nothing to read, say so and recommend
   `/aa-pd-define-doctrines`, which asks.

## Artifacts

**Doctrine proposal** in returned to the user, and written on the anchor ticket when one is given. Done when:

- Proposes a one-sentence mission, who the product is for, candidate doctrines, and non-goals
- Every proposal names the evidence it was drawn from, by file, decision record, page, or ticket
- Marks each proposal as stated (written down somewhere) or inferred (implied by what was built), and lists where the sources contradict each other
- Changes no doctrines page and assigns no D-nn id

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first and pull the feature pages it links to, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-58** Change the doctrines only deliberately and from evidence: a conflict G-57 raised, or what users, support, or production showed. Propose each doctrine with the evidence beside it, drawn from the project's code, documents, decision records, and tickets wherever there is anything to read, and write only what the user confirms. Record every amendment after the first set as a decision record that says what changed and why. Give a new doctrine the next `D-nn` id; never reuse or renumber one, and mark a retired doctrine retired rather than deleting it. Never edit a doctrine to fit the requirement in hand.
- Read before proposing. Start from what the project says about itself, then hold it against what it built; a stated aim the code contradicts is a contradiction to list, not a doctrine.
- Few and governing. Propose the handful of statements a requirement could actually be checked against, not a list of values; a candidate that no conceivable requirement could violate is not a doctrine.
- Non-goals are evidence too. What the product deliberately leaves out, in decision records, rejected tickets, and scope notes, is where its non-goals come from.
- Where there is nothing to read, say so and recommend /aa-pd-define-doctrines, which asks the user instead.
- Where doctrines already exist, propose only what they miss or what the project now contradicts, and recommend /aa-pd-amend-doctrines for each.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
