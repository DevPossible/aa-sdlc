---
name: release
description: "Deploy a prepared release to production using the pipeline Operations provides, verify it did what the release notes say, and record the deployment. Stops and asks before the irreversible step."
aa:
  discipline: release-management
  step: release
  guidance_sets: [every-step, anchored-step]
  guidance: [G-04, G-13, G-14, G-47]
  requires: [R-01, R-20, R-38]
---

# /aa-rel-release

Deploy a prepared release to production using the pipeline Operations provides, verify it did what the release notes say, and record the deployment. Stops and asks before the irreversible step.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The prepared release with a "go" decision
- The deployment pipeline and runbook from Operations
- The verification checks defined in the release

## Procedure

1. **Anchor and confirm the go.** Read the release ticket and its page (G-22): the go decision
   and who made it, the artifact identity the release names, the verification checks it
   defines, and the deployment runbook and pipeline from Operations. No go decision, no
   deployment: stop and say what is missing.
2. **Confirm the artifact identity.** The identity the pipeline will deploy is exactly the one
   the release names and the one that passed every earlier environment; nothing is rebuilt for
   production (O-24, G-47). Check each precondition in the runbook and quote what you found.
3. **Stop and ask.** Present what will be deployed by its identity, where, with which pipeline
   run and strategy, and what rollback would return to. Deploy only when the user grants this
   deployment; a permission granted for an earlier release does not carry over (G-13).
4. **Deploy through the pipeline,** never by hand: a deployment done outside it is unrecorded
   and unrepeatable. If a gate or check blocks the run, fix the cause or tell the user; never
   bypass it (G-14). Quote the pipeline run's result (G-04).
5. **Verify in production before announcing anything.** Run every verification check the
   release defines and record each result with its evidence. Confirm the identity running in
   production is the one deployed (G-47). The release is done when the checks pass, not when
   the pipeline is green.
6. **On any failure, roll back by default.** Do not investigate in production: return to the
   previous known-good identity through the pipeline, or raise an incident where the runbook
   says rollback is unsafe, and record which was done and why on the release ticket.
7. **Write the deployment record** in the release ticket and the knowledge base: what was
   deployed by its immutable identity, when, by whom, with which pipeline run, and the
   verification report with every check's result (O-24). Link both ways (G-26). Update the
   release ticket with the outcome and what remains (G-12).

## Artifacts

**Production deployment record** in the release ticket and the knowledge base. Done when:

- Records what was deployed, by its immutable artifact identity, when, by whom, with which pipeline run (O-24)

**Deployment verification report** in the release ticket. Done when:

- Every verification check has a result; any failure triggers rollback or an incident, recorded

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-14** Never use a bypass flag on a hook, check, or protected branch. If a gate blocks, fix the cause or tell the user.
- **G-47** Build the release artifact once, from one commit, give it an immutable identity, and promote that same identity through every environment; supply environment configuration at deploy time from the committed templates (O-16), never by rebuilding. Record the identity on the release, roll back to a previous identity rather than a rebuilt tag, and verify in each environment that the running identity is the one deployed.
- Ask before you deploy, every time, unless the user granted this deployment in advance. Production is the irreversible step (G-13).
- Use the pipeline, not your hands. A deployment done outside the pipeline is unrecorded and unrepeatable.
- Verify before you announce. The release is not done when the pipeline is green; it is done when the checks pass in production.
- If verification fails, the default is rollback, not investigation in production.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
