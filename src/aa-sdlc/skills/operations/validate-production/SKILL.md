---
name: validate-production
description: "After a release, confirm from production evidence that the system is doing what the release claimed: run the production validation checks, compare metrics to the baseline, and report."
aa:
  discipline: operations
  step: validate-production
  guidance_sets: [every-step, anchored-step]
  guidance: [G-04, G-47]
  requires: [R-03, R-38]
---

# /aa-ops-validate-production

After a release, confirm from production evidence that the system is doing what the release claimed: run the production validation checks, compare metrics to the baseline, and report.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The release, its verification checks, and its notes
- Dashboards, metrics, and logs since the release
- The performance baseline

## Procedure

1. **Anchor and read the release.** The release ticket, the verification checks and notes it
   carries, and its page (G-22); the artifact identity the release named; the performance
   baseline and the window it was measured over; the dashboards, metrics, and logs since the
   deployment.
2. **Confirm what is running.** Read the identity of the artifact running in production from
   the platform or the deployment record and compare it, character for character, with the
   identity the release named (O-24, G-47). A mismatch stops the step: record it on the
   release ticket and raise it as an incident.
3. **Run every verification check** the release defined, read-only, and record each result with
   its evidence: the query, the response, the log line, and the time it was taken. Never change
   production to make a check pass; a failing check is an incident or a rollback, recorded as
   such (G-06).
4. **Compute the before-and-after for each key metric** over a stated window, with a tool, not
   by eye (G-02): the outcome metrics, latency and error rate at the edge, and whatever else
   the baseline names. State the window, the query, and the numbers. A dashboard that looks
   fine is not evidence (G-04).
5. **Ticket every regression.** Where a metric has moved the wrong way beyond what the baseline
   allows, raise a ticket linked from the release ticket with the numbers and the window
   (G-26). Say plainly whether the regression is severe enough to recommend rollback.
6. **Write the production metrics report** in the knowledge base: the identity validated, the
   window, each metric before and after, and the tickets raised; link it from the release
   ticket and the ticket from it (G-26).
7. **Update the release ticket** with the validation results, every check and its evidence, the
   report link, and what remains (G-12). Report exactly: passed, failed, and skipped checks
   each named as such (G-15). This step changes nothing in production and nothing in the
   repository.

## Artifacts

**Production validation results** in the release ticket. Done when:

- Every check has a result with evidence
- The identity of the running artifact matches the one the release named (O-24)

**Production metrics report** in the knowledge base. Done when:

- Compares key metrics before and after, computed with a tool, with any regression ticketed

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-47** Build the release artifact once, from one commit, give it an immutable identity, and promote that same identity through every environment; supply environment configuration at deploy time from the committed templates (O-16), never by rebuilding. Record the identity on the release, roll back to a previous identity rather than a rebuilt tag, and verify in each environment that the running identity is the one deployed.
- Compare, do not glance. Compute before-and-after for each metric over a stated window; a dashboard that "looks fine" is not evidence.
- Validation is read-only. Never change production to make a check pass; a failing check is an incident or a rollback.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
