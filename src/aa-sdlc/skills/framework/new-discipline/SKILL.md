---
name: new-discipline
description: Add a discipline to the AA-SDLC framework with bounded responsibilities, a unique code, at least one fully-plumbed step, its skills folder, and its place in the design, vocabulary, and review plan, in the aa-sdlc repository only.
aa:
  discipline: framework
  step: new-discipline
  guidance_sets: [every-step, framework-authoring]
---

# /aa-fw-new-discipline

Adds one discipline and everything that lets it be reviewed and installed on day one: its
definition, at least one step with all of that step's plumbing, and its listing everywhere
disciplines are listed.

## Precondition

Run only in the aa-sdlc repository. Confirm `src/aa-sdlc/workflow/disciplines/` exists;
otherwise stop and say so.

## Inputs to gather

1. The name and the kind of work it owns.
2. What it explicitly does not own, and which existing discipline does.
3. A proposed short code (2 characters preferred, 3 if readability wins) and where it sits in
   SDLC order.
4. The steps it starts with: at least one, each with a name, artifacts, and guidance.

## Procedure

1. **Test it against T-13.** A discipline is a kind of work, not a headcount. If the proposal
   describes a role in one organisation's chart rather than a kind of work every project has,
   say so and redirect to `/aa-fw-extend` for a process pack. Stop.
2. **Check the code.** Read every `code:` in `src/aa-sdlc/workflow/disciplines/*.yaml`. Refuse
   a code already in use, one that reads as a common word or shell command, or one longer than
   three characters, and propose alternatives.
3. **Choose the id and order.** The id is the kebab-case name. Pick `order` by SDLC position
   and renumber the disciplines that follow it so the sequence stays contiguous.
4. **Write the definition** at `src/aa-sdlc/workflow/disciplines/<id>.yaml` with `id`, `code`,
   `name`, `order`, `purpose`, `owns`, `does_not_own`, `hands_off_to`, `steps`, `tenets`, and
   `opinions`. See any existing file for the shape.
5. **Fix neighbouring boundaries.** For every item in `owns`, find the discipline that used
   to cover it and update its `owns`, `does_not_own`, or `hands_off_to` in the same change.
6. **Create each step** by following `src/aa-sdlc/skills/fw/new-step/SKILL.md` in full, for
   every step in the list. A discipline with a stub step or an empty step list is not added.
7. **Create the skills folder** `src/aa-sdlc/skills/<id>/README.md` naming the discipline and
   its code, and update the discipline list in `src/aa-sdlc/skills/README.md`.
8. **List it in the documents.** Add a row to the disciplines table in `docs/design.md`
   section 3.1; add it to the discipline list in `docs/vocabulary.md`; add a row to the order
   table in `docs/plan-discipline-review.md` at the right position with status `drafted`;
   update the "Fourteen" wording wherever the count of disciplines is stated.
9. **Log the decision** in the `docs/design.md` decision log.
10. **Give it an icon and regenerate the site.** Add an entry for the discipline id to the icon
    table in `scripts/Build-WebsiteMethodology.ps1` (a small stroke-only SVG in the style of
    the others); the generator refuses a discipline without one. Then run
    `./scripts/Build-WebsiteMethodology.ps1` and commit the regenerated pages in the website
    repository (decision record 0007).
11. **Verify.** Run `./test.ps1 -Tier unit` and fix every problem. Run
    `./scripts/Build-DisciplineReview.ps1`.
11. **Stage and present.** Stage every changed file as one change set and present the staged
    summary with the message `feat(workflow): add <name> discipline`. Commit only if the user
    asked for the commit in this invocation (O-17, G-40). No attribution trailers.

## Report

Every file changed, the code and order chosen, the neighbouring disciplines whose boundaries
changed, the steps created, and the test result quoted from the run.
