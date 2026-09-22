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

*For this step:*

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-47** Build the release artifact once, from one commit, give it an immutable identity, and promote that same identity through every environment; supply environment configuration at deploy time from the committed templates (O-16), never by rebuilding. Record the identity on the release, roll back to a previous identity rather than a rebuilt tag, and verify in each environment that the running identity is the one deployed.
- Compare, do not glance. Compute before-and-after for each metric over a stated window; a dashboard that "looks fine" is not evidence.
- Validation is read-only. Never change production to make a check pass; a failing check is an incident or a rollback.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
