---
name: release
description: "Deploy a prepared release to production using the pipeline Operations provides, verify it did what the release notes say, and record the deployment. Stops and asks before the irreversible step."
aa:
  discipline: release-management
  step: release
  guidance_sets: [every-step, anchored-step]
  guidance: [G-04, G-13, G-14, G-47, G-51, G-53]
  requires: [R-01, R-20, R-38, R-41, R-43, R-42]
---

# /aa-rel-release

Deploy a prepared release to production using the pipeline Operations provides, verify it did what the release notes say, and record the deployment. Stops and asks before the irreversible step.

## Anchor

Anchor first (G-22). Read the ticket, linked scenarios and knowledge page; check requirement currency under G-54. Pull instructions below apply only when the snapshot changed or currency is unknown. If no ticket system is reachable, record the anchor and artifacts locally, say so, and continue (T-05, T-10).

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

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first and check requirement currency, update the ticket at meaningful checkpoints, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-04** During development run focused checks; before review run the affected build, lint and relevant test tiers, retaining actual output and declaring the scope. At actual branch finish run full build, lint, provenance and every test tier; at release satisfy the release checks. Instruction-only changes use the framework's applicable structural validation rather than claiming product behavior.
- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-14** Never use a bypass flag on a hook, check, or protected branch. If a gate blocks, fix the cause or tell the user.
- **G-47** Build the release artifact once, from one commit, give it an immutable identity, and promote that same identity through every environment; supply environment configuration at deploy time from the committed templates (O-16), never by rebuilding. Record the identity on the release, roll back to a previous identity rather than a rebuilt tag, and verify in each environment that the running identity is the one deployed.
- **G-51** Move tickets only with their producing evidence: Refined when scenarios/revision are recorded, Planned when the brief is confirmed and sized, In progress when implementation starts, In review when a verified candidate is ready with a linked merge request or authorized local review record, Accepted when the stakeholder confirms, Done when released. Distinguish author verification, independent review, local integration and release, using the configured state names.
- **G-53** Put each knowledge base page under the project's own root, in the section its content belongs to (Overview, Requirements, Architecture, Operations, Releases, Guides, or the names the project config maps them to), name a requirement page after its feature and its feature id, and when a page is superseded mark it and link to what replaced it rather than deleting it.
- Ask before you deploy, every time, unless the user granted this deployment in advance. Production is the irreversible step (G-13).
- Use the pipeline, not your hands. A deployment done outside the pipeline is unrecorded and unrepeatable.
- Verify before you announce. The release is not done when the pipeline is green; it is done when the checks pass in production.
- If verification fails, the default is rollback, not investigation in production.

## Report

State what was produced and where, link actual run output and summarize its scope and results, name failures/skips and what remains (G-15). Update the anchor at the meaningful milestone (G-12), referencing one proportionate evidence record instead of repacking unchanged proof. Stage only task-owned changes; honor existing explicit task commit authorization, otherwise present the diff and Conventional Commit message without committing (G-40).
