---
name: new-process
description: Add a process to the AA-SDLC framework as an ordered set of existing or new steps with process guidance, a checkable exit condition, scenarios, and its place in the design, in the aa-sdlc repository only.
aa:
  discipline: framework
  step: new-process
  guidance_sets: [every-step, framework-authoring]
---

# /aa-fw-new-process

Adds one process. A process is an ordering of steps toward a goal, described and never
enforced (T-03): every step in it still runs alone.

## Precondition

Run only in the aa-sdlc repository. Confirm `src/aa-sdlc/workflow/processes/` exists;
otherwise stop and say so.

## Inputs to gather

1. The goal the process serves, and where it starts and ends.
2. The steps in order, from any disciplines. Identify any that do not yet exist.
3. Process-level guidance, if any, as existing `G-nn` ids.

## Procedure

1. **Check scope.** If the process only makes sense for one organisation, it is a process
   pack: redirect to `/aa-fw-extend` and stop.
2. **Reuse before inventing.** For each step in the list, check
   `src/aa-sdlc/workflow/steps/`. A process is an ordering, not an owner; use the existing
   step even if it belongs to another process.
3. **Create missing steps first** by following `src/aa-sdlc/skills/fw/new-step/SKILL.md` in
   full for each. Do not write the process until every step exists.
4. **Refuse gating steps.** If a proposed step exists only to check that an earlier step ran,
   remove it and cite T-03. The exit condition, not a gate, says what done looks like.
5. **Write the exit condition** as something a person or `/aa-fw-health` could check: named
   artifacts in named places, tickets in named states. Not a feeling.
6. **Write the definition** at `src/aa-sdlc/workflow/processes/<id>.yaml` with `id`, `name`,
   `summary`, `methodology` (if it traces to a methodology phase), ordered `steps`, `guidance`
   ids, and `exit`. See `conception.yaml` for the shape.
7. **Write the scenarios** at `features/framework/<id>.feature`, tagged `@framework @T-03`:
   one scenario running the process end to end, one running a single step from the middle of
   it alone, and one for the exit condition being checked.
8. **Update the design.** If this is a core process, name it in `docs/design.md` section 3.2.
   Add a decision log row.
9. **Verify.** Run `./test.ps1 -Tier unit` and fix every problem. Run
   `./scripts/Build-DisciplineReview.ps1`.
10. **Stage and present.** Stage every changed file as one change set and present the staged
    summary with the message `feat(workflow): add <name> process`. Commit only if the user
    asked for the commit in this invocation (O-17, G-40). No attribution trailers.

## Guidance

*From the `every-step` set:* What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-03** Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read.
- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).

*From the `framework-authoring` set:* What the framework authoring commands do in the aa-sdlc repository: prove with the unit tier, produce each artifact where the workflow names it, and stage rather than commit.

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-25** Produce each artifact in the location the workflow names for it, with the name it gives. Never invent a new location or a variant name; if the named location is wrong for this project, change the project config, not the artifact (T-08).
- **G-40** Never commit unless the user asked for that commit. Stage the change, write the message, present the staged diff summary and the message, and stop; a request to implement, fix, finish, or run a step is not a request to commit, and the commit is made under the user's identity with no agent attribution.

*For this step:*

- A process is described, not enforced (T-03). Never add a step that exists only to check that an earlier step ran; the exit condition says what done looks like, and every step still runs alone.
- Reuse steps before inventing them. If a needed step exists in another process or discipline, list it; a process is an ordering, not an owner.
- Write the exit condition as something /aa-fw-health or a person could check, not as a feeling.
- If the process only makes sense for one organisation, it is a process pack; redirect to /aa-fw-extend.

## Report

Every file changed, the steps reused and the steps created, any gating step refused, and the
test result quoted from the run.
