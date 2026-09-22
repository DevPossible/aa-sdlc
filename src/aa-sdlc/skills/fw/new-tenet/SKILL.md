---
name: new-tenet
description: Add a tenet to the AA-SDLC framework with its scenarios, citations from the disciplines and steps it governs, and a consistency pass over existing opinions and guidance, in the aa-sdlc repository only.
aa:
  discipline: framework
  step: new-tenet
  requires: [R-04, R-05, R-16, R-31]
  guidance: [G-03, G-04, G-15, G-24, G-25, G-40]
---

# /aa-fw-new-tenet

Adds one tenet. Tenets are few and govern everything, so adding one means showing it in
action, citing it from what it governs, and proving nothing already written contradicts it.

## Precondition

Run only in the aa-sdlc repository. Confirm `docs/tenets.md` and `src/aa-sdlc/workflow/`
exist; otherwise stop and say so.

## Inputs to gather

1. The principle, in one sentence.
2. The reasoning behind it, in a short paragraph.
3. Which existing disciplines, steps, opinions, or guidance it governs or contradicts, if the
   user knows.

## Procedure

1. **Classify it.** A tenet is framework-level: it governs how the framework and its content
   are designed. If the statement is about how to perform a step, it is guidance: redirect to
   `docs/guidance.md`. If it chooses between defensible alternatives, it is an opinion:
   redirect to `/aa-fw-new-opinion`. Stop in either case and say why.
2. **Check for overlap.** Read every tenet in `docs/tenets.md`. If an existing tenet already
   covers the principle, propose strengthening its text instead of adding a new one, and stop
   unless the user insists.
3. **Write the feature file first.** Create `features/framework/<slug>.feature` tagged
   `@framework @T-nn` (using the next id) with at least three scenarios showing the principle
   applied in concrete situations. If you cannot write three, the principle is too abstract to
   govern anything; say so.
4. **Take the next id** from `docs/tenets.md` and **add the entry** after the last tenet, in
   this shape: a bold one-line statement, then one paragraph of reasoning. Update the sentence
   near the top that groups tenets by purpose so it includes the new one.
5. **Update ranges.** In `docs/design.md` section 2, extend the cited tenet range. Search
   the docs for any other list of tenets and add it.
6. **Cite it from what it governs.** For each discipline or step the tenet governs, add
   `T-nn` to the `tenets:` list in `src/aa-sdlc/workflow/disciplines/<id>.yaml` or
   `src/aa-sdlc/workflow/steps/<step>.yaml`.
7. **Consistency pass.** Read every entry in `docs/opinions.md` and every row in
   `docs/guidance.md` against the new tenet. For each contradiction, either fix the opinion or
   guidance in this change or stop and report that the tenet cannot be added as written.
8. **Log the decision** in the `docs/design.md` decision log, citing `T-nn`.
9. **Verify.** Run `./test.ps1 -Tier unit` and fix every problem. Run
   `./scripts/Build-DisciplineReview.ps1`.
10. **Stage and present.** Stage every changed file as one change set and present the staged
    summary with the message `docs(tenets): T-nn <short statement>`. Commit only if the user
    asked for the commit in this invocation (O-17, G-40). No attribution trailers.

## Report

Every file changed, the new id, the disciplines and steps that now cite it, any contradictions
found and how each was resolved, and the test result quoted from the run.
