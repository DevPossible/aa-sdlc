---
name: amend-doctrines
description: "Add, change, or retire one doctrine or non-goal, deliberately and from evidence, with a decision record that says what changed and why. Ids are permanent; a retired doctrine keeps its id and is marked retired."
aa:
  discipline: product-management
  step: amend-doctrines
  guidance_sets: [every-step, anchored-step]
  guidance: [G-41, G-57, G-58]
  requires: [R-32, R-48]
---

# /aa-pd-amend-doctrines

Add, change, or retire one doctrine or non-goal, deliberately and from evidence, with a decision record that says what changed and why. Ids are permanent; a retired doctrine keeps its id and is marked retired.

## Anchor

A ticket is optional here. When one is given, read it and its page and pull the feature pages it links to first (G-22, G-54) and write the outcome back to it; when none is, produce the artifacts locally and say so.

## Inputs

- The doctrines page as it is now
- The evidence for the change: a conflict a step raised (G-57), a /aa-pd-check-doctrines report, or what users, support, or production showed
- The open tickets, approved scenarios, and decision records that cite the doctrine being changed

## Procedure

1. **Anchor.** When a ticket is given, read it and its page first (G-22); when none is, say so.
   Read the doctrines page as it is now. If there is none, stop and recommend
   `/aa-pd-discover-doctrines` or `/aa-pd-define-doctrines`.
2. **Name the one change.** Add a doctrine, change one, retire one, or add, change, or remove a
   non-goal. One change per run; a second change is a second run with its own record.
3. **Weigh the evidence.** State what shows the change is needed: a conflict a step raised
   (G-57), a `/aa-pd-check-doctrines` report, or what users, support, or production showed. If
   the only reason is the requirement in hand, say so and recommend changing the requirement
   instead (G-58).
4. **Follow the citations.** Find every open ticket, approved scenario, and decision record
   that cites the doctrine, and say for each whether it still holds after the change.
5. **Propose the wording and the record.** The doctrine before and after, its id (the next
   free `D-nn` for a new doctrine; the same id for a changed one; the same id marked retired for
   a retired one), and the decision record: context, evidence, options, decision, and
   consequences. Write nothing until the user confirms.
6. **Write it.** Write the decision record, numbered next in the repository's sequence (G-41),
   then amend the page, linking the record beside the doctrine it changed. Never reuse or
   renumber an id, and never delete a retired doctrine (G-58).
7. **Raise what it invalidates.** For each item step 4 found no longer holds, put a question on
   its ticket naming the amendment; change none of them here.
8. **Update the ticket and present.** Write the outcome on the anchor ticket when one is given
   (G-12). Stage the decision record, and the page where it lives in the repository, and
   present the summary with a Conventional Commit message; honor existing explicit task commit authorization (O-17, G-40).

## Artifacts

**Amended doctrines page** in the Overview section under the project's knowledge root. Done when:

- A new doctrine takes the next free D-nn id; no id is reused or renumbered
- A changed doctrine keeps its id, and the page shows its earlier wording or links the version that held it
- A retired doctrine is marked retired, keeps its id, and links the decision record that retired it
- Every amendment links its decision record

**Decision record** in the decision record location the project config names. Done when:

- States the doctrine before and after, the evidence, the options considered, and the consequences
- Lists the tickets, scenarios, and decision records that cited the doctrine and whether each still holds

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first and check requirement currency, update the ticket at meaningful checkpoints, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-41** Write every significant decision, technical, product, or process, as a decision record the moment it is made: one screen, numbered next in the repository's sequence, dated, with context, options considered, decision, and consequences, linked from the anchor ticket. Never edit an accepted record; supersede it with a new one that links back.
- **G-57** Before writing or approving an outcome, a scenario, an architecture, a decision record, an order of the backlog, or a merge request, read the product's doctrines and check the work against each doctrine and non-goal, and cite the doctrine it serves or is bounded by (`D-nn`). When the work conflicts with one, name the doctrine and the conflict and do not go on with that part until the user decides: change the work, or propose an amendment (G-58). Never absorb a conflict silently. Where there are no doctrines, say the check was made against nothing.
- **G-58** Change the doctrines only deliberately and from evidence: a conflict G-57 raised, or what users, support, or production showed. Propose each doctrine with the evidence beside it, drawn from the project's code, documents, decision records, and tickets wherever there is anything to read, and write only what the user confirms. Record every amendment after the first set as a decision record that says what changed and why. Give a new doctrine the next `D-nn` id; never reuse or renumber one, and mark a retired doctrine retired rather than deleting it. Never edit a doctrine to fit the requirement in hand.
- One amendment per run. Each change to the doctrines is its own decision, so it gets its own record and its own run.
- Follow the citations. Before writing the record, find every ticket, scenario, and decision record that cites the doctrine, say which the amendment invalidates, and raise those as questions on their tickets rather than changing them here.
- Evidence, not convenience. If the only reason for the change is the requirement in hand, say so and recommend changing the requirement instead.
- The user decides. Propose the wording and the record, and write them only once the user confirms.

## Report

State what was produced and where, link actual run output and summarize its scope and results, name failures/skips and what remains (G-15). Update the anchor at the meaningful milestone (G-12), referencing one proportionate evidence record instead of repacking unchanged proof. Stage only task-owned changes; honor existing explicit task commit authorization, otherwise present the diff and Conventional Commit message without committing (G-40).
