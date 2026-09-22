---
name: rollback
description: "Return production to the previous known-good release using the pipeline, verify it, record what was rolled back and why, and hand the cause to Support or Development."
aa:
  discipline: release-management
  step: rollback
  guidance_sets: [every-step, anchored-step]
  guidance: [G-04, G-13, G-47]
  requires: [R-01, R-20, R-38]
---

# /aa-rel-rollback

Return production to the previous known-good release using the pipeline, verify it, record what was rolled back and why, and hand the cause to Support or Development.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The release to roll back and the previous known-good release
- The rollback runbook from Operations
- The incident or verification failure that triggered it

## Procedure

1. **Anchor and record the trigger.** Read the release ticket, the incident or verification
   failure that triggered the rollback, and the rollback runbook from Operations (G-22).
   Record the trigger on the release ticket before anything else, so the reason is there
   whatever happens next.
2. **Confirm the target is known-good, not just previous.** Read the verification record of the
   release you would return to; a release whose checks failed or were never run is not a
   target. Note its immutable artifact identity: the rollback returns to that identity, never
   to a rebuilt tag (O-24, G-47).
3. **Name what will not roll back with the code.** Schema and data migrations since the target
   may be one-way. Say so explicitly, name each, and follow the runbook's data steps; where the
   runbook is silent, stop and put the question to the user rather than guess.
4. **Stop and ask.** Present the current identity, the target identity, the trigger, the data
   implications, and the pipeline run that will do it. Roll back only when the user grants it
   (G-13); the pressure of an incident does not change who decides.
5. **Roll back through the pipeline** to the target identity and quote the run's result
   (G-04). Do not diagnose the cause in production; the goal now is to restore service.
6. **Verify after rollback.** Run the target release's verification checks and confirm the
   identity now running is the target (G-47). Record every result with its evidence; a check
   that still fails is escalated on the incident, not retried into green (G-06).
7. **Raise a ticket for the cause,** linked from the release ticket and the incident, with what
   was observed and the identities involved, so triage or fix-bug starts with the evidence in
   hand (G-26).
8. **Write the rollback record** on the release ticket and the incident: what was reverted to,
   when, by whom, the trigger, the verification results, and the cause ticket. Update the
   release ticket with what remains (G-12).

## Artifacts

**Rollback record** in the release ticket and the incident, if any. Done when:

- Records what was reverted to, when, by whom, and the trigger
- Verification after rollback is recorded
- A ticket exists for the cause

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
- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-47** Build the release artifact once, from one commit, give it an immutable identity, and promote that same identity through every environment; supply environment configuration at deploy time from the committed templates (O-16), never by rebuilding. Record the identity on the release, roll back to a previous identity rather than a rebuilt tag, and verify in each environment that the running identity is the one deployed.
- Roll back first, understand later. The goal is to restore service; the cause is a ticket.
- Confirm the rollback target is actually known-good, not just previous. Check its verification record, and roll back to that artifact identity; never rebuild the previous tag (O-24).
- Data changes may not roll back with code. Say so explicitly and involve Operations before proceeding.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
