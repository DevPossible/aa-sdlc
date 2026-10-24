---
name: define-doctrines
description: "Write the product's first set of doctrines with the user: a one-sentence mission, who the product is for, a few doctrines with permanent D-nn ids, and its non-goals, on a page in the Overview section of the knowledge base, holding only what the user confirmed."
aa:
  discipline: product-management
  step: define-doctrines
  guidance_sets: [every-step, anchored-step]
  guidance: [G-41, G-53, G-58]
  requires: [R-32, R-42, R-48]
---

# /aa-pd-define-doctrines

Write the product's first set of doctrines with the user: a one-sentence mission, who the product is for, a few doctrines with permanent D-nn ids, and its non-goals, on a page in the Overview section of the knowledge base, holding only what the user confirmed.

## Anchor

A ticket is optional here. When one is given, read it and its page and pull the feature pages it links to first (G-22, G-54) and write the outcome back to it; when none is, produce the artifacts locally and say so.

## Inputs

- The doctrine proposal from /aa-pd-discover-doctrines, when the project has anything to read
- The user's answers, when it does not
- The Overview section under the project's knowledge root

## Procedure

1. **Anchor.** When a ticket is given, read it and its page first (G-22); when none is, say so.
   Read the Overview section under the project's knowledge root. If a doctrines page already
   exists, stop: say so and recommend `/aa-pd-amend-doctrines`. This step never overwrites a set.
2. **Start from the evidence or from the user.** Where a proposal from
   `/aa-pd-discover-doctrines` exists on the ticket or in this session, walk the user through it
   one item at a time: accept, edit, or drop each. Where there is none and the project has
   anything to read, run that step's reading first. Where there is nothing to read, ask one
   question at a time: what the product is for, who it is for, what it must always do, and
   what it must never become.
3. **Hold each doctrine to the test.** One sentence a requirement can be checked against,
   followed by why it holds. Push back on a doctrine no requirement could violate and on a set
   longer than anyone will read before deciding; three to seven is usual.
4. **Confirm the whole set.** Read back the mission, the audience, the doctrines numbered from
   `D-01`, and the non-goals, and write nothing until the user confirms them (G-58).
5. **Write the page.** In the Overview section under the project's knowledge root, or the
   documents folder's knowledge folder where no knowledge base is in scope (G-53): the mission,
   the audience, each doctrine with its id and its reason, the non-goals, and the date adopted.
6. **Record the decision.** Write a decision record, numbered next in the repository's
   sequence, recording the adoption and the candidates the user rejected and why (G-41), and
   link it from the page and the anchor ticket.
7. **Update the ticket and present.** Write the outcome on the anchor ticket when one is given
   (G-12). Stage the decision record, and the page where it lives in the repository, and
   present the summary with a Conventional Commit message; commit only if the user asked for
   that commit (O-17, G-40).

## Artifacts

**Doctrines page** in the Overview section under the project's knowledge root, or the documents folder's knowledge folder where no knowledge base is in scope. Done when:

- Holds a one-sentence mission, who the product is for, at least one doctrine, and the non-goals
- Every doctrine has a permanent id, numbered from D-01, and a sentence on why it holds
- Holds only statements the user confirmed or wrote
- Records the date the set was adopted and links the decision record and the proposal it came from, if any

**Decision record** in the decision record location the project config names. Done when:

- Records adopting the first set of doctrines, with the candidates the user rejected and why

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first and pull the feature pages it links to, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-41** Write every significant decision, technical, product, or process, as a decision record the moment it is made: one screen, numbered next in the repository's sequence, dated, with context, options considered, decision, and consequences, linked from the anchor ticket. Never edit an accepted record; supersede it with a new one that links back.
- **G-53** Put each knowledge base page under the project's own root, in the section its content belongs to (Overview, Requirements, Architecture, Operations, Releases, Guides, or the names the project config maps them to), name a requirement page after its feature and its feature id, and when a page is superseded mark it and link to what replaced it rather than deleting it.
- **G-58** Change the doctrines only deliberately and from evidence: a conflict G-57 raised, or what users, support, or production showed. Propose each doctrine with the evidence beside it, drawn from the project's code, documents, decision records, and tickets wherever there is anything to read, and write only what the user confirms. Record every amendment after the first set as a decision record that says what changed and why. Give a new doctrine the next `D-nn` id; never reuse or renumber one, and mark a retired doctrine retired rather than deleting it. Never edit a doctrine to fit the requirement in hand.
- One page, one set. If a doctrines page already exists, stop and recommend /aa-pd-amend-doctrines; this step never overwrites a set.
- Where there is no proposal, ask one question at a time, in this order. What is the product for, who is it for, what must it always do, and what must it never become.
- Few and checkable. Push back on a doctrine no requirement could violate, and on more doctrines than anyone will read before deciding; three to seven is usual.
- Write each doctrine as one sentence a requirement can be checked against, followed by why it holds.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
