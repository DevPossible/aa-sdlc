---
name: new-opinion
description: Add an opinion to the AA-SDLC framework with all of its plumbing (entry, implied requirements and guidance, scenarios, documents, decision log), in the aa-sdlc repository only.
aa:
  discipline: framework
  step: new-opinion
  requires: [R-04, R-05, R-16, R-31]
  guidance: [G-03, G-04, G-15, G-24, G-25, G-40]
---

# /aa-fw-new-opinion

Adds one opinion and everything that makes it real. An opinion nothing depends on is a slogan;
this skill traces the stance forward into requirements, guidance, scenarios, and documents, and
stages every change as one change set for the user to commit.

## Precondition

Run only in the aa-sdlc repository. Confirm `src/aa-sdlc/workflow/` and `docs/opinions.md`
exist; if not, stop and say this command applies to the framework repository only.

## Inputs to gather

Ask for anything missing before writing:

1. The stance, in one sentence.
2. Why the framework holds it.
3. The alternatives it rejects.
4. What would change the framework's mind.
5. Any capability the stance assumes (becomes a requirement) and any practice it demands
   (becomes guidance).

## Procedure

1. **Check the stance against the tenets** in `docs/tenets.md`. It must name no tool or
   language (T-01) and assume no team size or hand-off (T-13). If it does, rewrite it with the
   user until it does not. If it is really guidance or a tenet, say so and stop.
2. **Take the next id.** Read `docs/opinions.md`, find the highest `O-nn`, use the next
   number. Never reuse or renumber.
3. **Write the entry** in `docs/opinions.md`, before the summary section that begins
   "Opinions O-05, O-06", in this exact shape:

   ```
   **O-nn <Short statement>.**
   *The stance:* ...
   *Why:* ...
   *Rejected:* ...
   *Would change our mind:* ...
   *Requirements:* R-.. *Guidance:* G-..
   ```

   Then update that summary paragraph so it names the new opinion.
4. **List it up front.** Add a numbered line to the opinions list in `README.md` and extend
   the opinions sentence in `docs/design.md` section 2.
5. **Create implied requirements.** For each capability the stance assumes, add a row to the
   right table in `docs/requirements.md` with the next `R-nn`, then add a met scenario and an
   unmet scenario to the matching file under `features/requirements/`, tagged `@R-nn`, the
   level, and `@O-nn`. If `aa init` should lay it down, add a scenario to
   `features/cli/init.feature`.
6. **Create implied guidance.** For each practice the stance demands, add a row to
   `docs/guidance.md` with the next `G-nn`, then cite it from every step it applies to by
   editing that step's `guidance:` list in `src/aa-sdlc/workflow/steps/<step>.yaml`. Add the
   new requirement ids to those steps' `requires:` lists.
7. **Update the config format** in `docs/formats.md` if the stance needs a new
   `aa.config.yaml` key, with a comment citing `O-nn`.
8. **Write the scenarios** for the opinion in action: `features/framework/<slug>.feature`,
   tagged `@O-nn`, at least three scenarios, each with a Then step.
9. **Log the decision.** Add the next row to the decision log in `docs/design.md`, citing
   `O-nn` and the ids it created.
10. **Verify.** Run `./test.ps1 -Tier unit`; fix every problem it reports. Run
    `./scripts/Build-DisciplineReview.ps1`.
11. **Stage and present.** Stage every changed file as one change set and present the staged
    summary with a conventional message such as `docs(opinions): O-nn <short statement>`.
    Commit only if the user asked for the commit in this invocation (O-17, G-40).
    No attribution trailers.

## Report

List every file changed, one line each, then the new ids created (O, R, G), then the test
result quoted from the run. Report faithfully: if something was skipped or could not be done,
say so and why.
