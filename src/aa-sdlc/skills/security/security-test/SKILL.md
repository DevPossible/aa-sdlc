---
name: security-test
description: "Test the built system for the weaknesses the threat model and common weakness classes predict, and produce evidence for the compliance report. Raises tickets for what it finds."
aa:
  discipline: security
  step: security-test
  guidance_sets: [every-step, anchored-step]
  guidance: [G-04, G-13]
  requires: [R-11]
---

# /aa-sec-security-test

Test the built system for the weaknesses the threat model and common weakness classes predict, and produce evidence for the compliance report. Raises tickets for what it finds.

## Anchor

Anchor first (G-22). Read the ticket, linked scenarios and knowledge page; check requirement currency under G-54. Pull instructions below apply only when the snapshot changed or currency is unknown. If no ticket system is reachable, record the anchor and artifacts locally, say so, and continue (T-05, T-10).

## Inputs

- The threat model and security scenarios
- The built and deployed system, or the code and dependencies for static checks
- The project's security tooling category: static analysis, dependency scanning, dynamic testing

## Procedure

**Use a separate context when explicitly authorized** (G-63, decision record 0021). If this
assignment authorizes the harness to run the `aa-sec` subagent, give it steps 2 to 5 (plan against the model, run the
tooling, exercise the scenarios, record the findings), with the ticket, the threat model, and the
security scenarios, and write what it returns as the results in step 6, saying the findings came
from the agent. Otherwise do those steps yourself, working from the threat model rather than from
what the code was meant to do.
Installed agents alone grant no delegation authority. Label a fallback as self-review and
never substitute it for independent acceptance that the project requires.

1. **Anchor and pull.** Read the ticket and pull the feature pages it links to: their Approved
   scenarios into the features folder, and the page versions recorded on the ticket (G-54). For
   a documents-folder knowledge base run `scripts/aa-sdlc/Sync-FeatureFiles.ps1 -KnowledgeRoot
   <folder> -FeaturesRoot <features>`; otherwise read each page and convert it with
   `ConvertFrom-FeaturePage` from `scripts/aa-sdlc/AaFeatures.psm1`. Read the threat model, the
   security scenarios in the pulled feature files, and the controls the organisation requires or
   the existing compliance report (G-22). Note which environment holds the built system. If it
   is production, stop: no security test runs there without written permission on the ticket
   (G-13); prefer a production-like environment and record which one was used.
2. **Plan against the model first, the checklist second.** From the threat model, list each
   security scenario and the test that proves it; then add the common weakness classes that
   matter everywhere. Every planned test names the scenario or the class it covers, so a
   scenario with no test is visible before anything runs.
3. **Run the project's security tooling** over the current code and dependencies: static
   analysis, dependency scanning, and dynamic testing as the project has each. Confirm each ran
   against the current revision before trusting its result, and quote the actual output (G-04).
4. **Exercise each security scenario** against the built system and record the steps taken and
   the observed result, so that every finding can be reproduced from the record alone. A
   scenario that cannot be run is reported as not run, with the reason (G-15).
5. **Record each finding** with a severity from impact and likelihood, the reproduction steps,
   and the evidence, and raise a ticket for it in the configured ticket project linked to the
   scenario or threat it relates to (G-27, G-26). Report without drama and without softening;
   severity does not depend on how it will be received.
6. **Write the results** on the anchor ticket, one result per security scenario, and put the run
   output in the documents folder or the test system as the project config names (G-25).
7. **Write or update the security compliance report** in the knowledge base. Map each control
   the organisation requires to the evidence that it is met or to the ticket that will meet it;
   no control is left unmapped.
8. **Update the ticket and present.** Record on the ticket what was tested and where, the
   findings and their tickets, what was not run and why, and what remains (G-12). If run output
   was written into the repository, stage it with a Conventional Commit message naming the
   ticket, present the staged summary; honor existing explicit task commit authorization
   (O-17, G-40).

## Artifacts

**Security test results** in the anchor ticket, with the run output in the documents folder or test system. Done when:

- Every security scenario has a result; every finding has a severity and a ticket
- Findings are reproducible from the recorded steps

**Security compliance report** in the knowledge base. Done when:

- Maps each control the organisation requires to the evidence that it is met, or the ticket that will meet it

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first and check requirement currency, update the ticket at meaningful checkpoints, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-04** During development run focused checks; before review run the affected build, lint and relevant test tiers, retaining actual output and declaring the scope. At actual branch finish run full build, lint, provenance and every test tier; at release satisfy the release checks. Instruction-only changes use the framework's applicable structural validation rather than claiming product behavior.
- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- Test against the model first, the checklist second. The threat model says what matters here; the checklist says what matters everywhere.
- Never test a production system without written permission on the ticket. Prefer a production-like environment.
- Report findings without drama and without softening. Severity comes from impact and likelihood, not from how it will be received.

## Report

State what was produced and where, link actual run output and summarize its scope and results, name failures/skips and what remains (G-15). Update the anchor at the meaningful milestone (G-12), referencing one proportionate evidence record instead of repacking unchanged proof. Stage only task-owned changes; honor existing explicit task commit authorization, otherwise present the diff and Conventional Commit message without committing (G-40).
