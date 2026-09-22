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

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The threat model and security scenarios
- The built and deployed system, or the code and dependencies for static checks
- The project's security tooling category: static analysis, dependency scanning, dynamic testing

## Procedure

1. **Anchor.** Read the ticket, the threat model, the security scenarios in the feature files,
   and the controls the organisation requires or the existing compliance report (G-22). Note
   which environment holds the built system. If it is production, stop: no security test runs
   there without written permission on the ticket (G-13); prefer a production-like environment
   and record which one was used.
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
   ticket, present the staged summary, and stop; commit only if the user asked for that commit
   (O-17, G-40).

## Artifacts

**Security test results** in the anchor ticket, with the run output in the documents folder or test system. Done when:

- Every security scenario has a result; every finding has a severity and a ticket
- Findings are reproducible from the recorded steps

**Security compliance report** in the knowledge base. Done when:

- Maps each control the organisation requires to the evidence that it is met, or the ticket that will meet it

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
- Test against the model first, the checklist second. The threat model says what matters here; the checklist says what matters everywhere.
- Never test a production system without written permission on the ticket. Prefer a production-like environment.
- Report findings without drama and without softening. Severity comes from impact and likelihood, not from how it will be received.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
