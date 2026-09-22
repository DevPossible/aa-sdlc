---
name: new-step
description: Add a step to an existing AA-SDLC discipline with all of its plumbing (definition, command, skill scaffold, scenarios, guidance, requirements, process membership, documents), in the aa-sdlc repository only.
aa:
  discipline: framework
  step: new-step
  requires: [R-04, R-05, R-16, R-31]
  guidance: [G-03, G-04, G-15, G-24, G-25, G-40]
---

# /aa-fw-new-step

Adds one step to an existing discipline. A step is a definition, a command, a skill, scenarios,
guidance, and requirements, listed by its discipline and any process it belongs to. This skill
creates all of it or none of it.

## Precondition

Run only in the aa-sdlc repository. Confirm `src/aa-sdlc/workflow/steps/` exists; otherwise
stop and say so.

## Inputs to gather

1. The discipline it belongs to (an id from `src/aa-sdlc/workflow/disciplines/`).
2. The unit of work it performs, in one or two sentences.
3. Whether it anchors on a ticket: `required`, `optional`, or `none`.
4. The artifacts it produces, each with a location and acceptance criteria.
5. The guidance it needs, and the requirements that guidance implies.
6. Any process it belongs to and where in the order.

## Procedure

1. **Name it.** Imperative, by the work, kebab-case: `implement`, `fix-bug`, not
   `development-work`. Read every file name in `src/aa-sdlc/workflow/steps/`; refuse an id that
   exists in any discipline, because ids are unique across the framework and cannot change
   later.
2. **Derive the command.** Read the discipline's `code:`; the command is
   `/aa-<code>-<id>`. Nothing else is accepted.
3. **Write the definition** at `src/aa-sdlc/workflow/steps/<id>.yaml` with `id`, `name`,
   `discipline`, `command`, `summary`, `methodology` (only if it traces to the methodology),
   `anchor`, `inputs`, `artifacts` (each with `name`, `location`, `acceptance`), `guidance`
   ids, `guidance_inline`, `requires`, `tenets`, `opinions`. Copy the shape from
   `implement.yaml`. Quote any list item containing a colon followed by a space.
4. **Guidance rules.** Name tool categories, never tools (T-01); if the step needs a tool
   category, add a requirement and cite it. Promote an inline item to a `G-nn` in
   `docs/guidance.md` only when a second step shares it; otherwise keep it inline. For an
   anchored step, always cite G-22 (read the ticket first) and G-12 (update it last).
5. **Add requirements** the guidance implies as rows in `docs/requirements.md` with met and
   unmet scenarios in `features/requirements/`, if they do not already exist.
6. **List it.** Add the id to `steps:` in `src/aa-sdlc/workflow/disciplines/<discipline>.yaml`
   and, if it belongs to a process, at the right position in
   `src/aa-sdlc/workflow/processes/<process>.yaml`.
7. **Scaffold the skill** at `src/aa-sdlc/skills/<discipline>/<id>/SKILL.md`: frontmatter
   `name` equal to the id, a one-sentence `description`, and an `aa:` block whose `requires`
   equals the step's `requires` and whose `guidance` equals the step's `guidance`. Body: a
   heading with the command, the precondition, inputs to gather, a numbered procedure that
   begins with reading the anchor ticket when anchor is required and ends with updating it,
   the artifacts and their locations, and a report section. Cite guidance by id.
8. **Write the scenarios** at `features/<discipline>/<id>.feature`, tagged with the
   discipline and step: the command run with an anchor, run without one if anchor is
   optional, producing each artifact, and reporting a failure faithfully.
9. **Update the design** if the step traces to the methodology: add a row to the step map in
   `docs/design.md` section 4. Update the command count for the discipline in
   `docs/plan-discipline-review.md`.
10. **Verify.** Run `./scripts/Test-WorkflowStructure.ps1` and fix every problem; a step the
    validator rejects is not added. Then run `./test.ps1 -Tier unit` and
    `./scripts/Build-DisciplineReview.ps1`.
11. **Stage and present.** Stage every changed file as one change set and present the staged
    summary with the message `feat(workflow): add <discipline> step <id>`. Commit only if the
    user asked for the commit in this invocation (O-17, G-40). No attribution trailers.

## Report

Every file changed, the command, the guidance promoted to ids, the requirements created, the
process it joined, and the test result quoted from the run.
