---
name: uat
description: "Confirm with the people who asked for it that what was built is what they meant. Walks stakeholders through the scenarios against the built software and records acceptance or the gap."
aa:
  discipline: business-analysis
  step: uat
  guidance_sets: [every-step, anchored-step]
  guidance: [G-18]
  requires: [R-16, R-17]
---

# /aa-ba-uat

Confirm with the people who asked for it that what was built is what they meant. Walks stakeholders through the scenarios against the built software and records acceptance or the gap.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The feature files for the ticket or release
- A deployed environment the stakeholder can use
- The tests Development and Testing wrote, as evidence

## Procedure

1. **Anchor and check currency.** Read the anchor ticket, its linked scenarios, and its page
   (G-22). Compare the feature files at head with the revision the ticket records they were
   built against (O-13); a scenario that changed since is noted on the ticket before the
   walkthrough, so what is accepted is what was built. Confirm that the deployed environment the
   stakeholder can use is running the build the ticket names.
2. **Assemble the evidence.** Read the tests Development and Testing wrote for the scenarios and
   their most recent results. A scenario with no passing automated test is still walked through,
   and the gap is noted on the ticket.
3. **Write the walkthrough order.** On the ticket, list every scenario for the ticket or release
   in the order the stakeholder will walk them, with the Given each needs set up first. The
   scenarios themselves are the test cases; nothing is rewritten, and none is left out.
4. **Walk the scenario, not the demo.** For each scenario, take the stakeholder through the
   Given, When, Then as written against the deployed environment and observe the result. If
   they want something else, that is a requirement change: it is recorded as a question on the
   ticket and goes through the feature file (G-18), never through the ticket alone.
5. **Record acceptance by name.** Mark each scenario accepted or not, by whom and on what date,
   with the gap described where not. "UAT passed" is not evidence (T-07).
6. **Turn every gap into work.** A scenario not met is a new ticket for Development, linked to
   this one. A scenario met but not what was meant is a new requirement, raised as a question
   and changed in the feature file first (G-18), not a failure of the build. No gap is left as a
   note that fades.
7. **Update the ticket.** Write the UAT results report on the anchor ticket, linked from the
   knowledge base page and back (G-26), with what was accepted, what was not, the tickets
   raised, and what remains (G-12). Where this step changed a feature file, stage it and present
   the summary with a Conventional Commit message; commit only if the user asked for that
   commit (O-17, G-40). Then report.

## Artifacts

**UAT test cases** in the features folder, as the scenarios themselves, plus a walkthrough order on the ticket. Done when:

- Every scenario for the ticket is covered by the walkthrough

**UAT results report** in the anchor ticket, linked from the knowledge base page. Done when:

- Each scenario is marked accepted or not, by whom, with the gap described where not
- Every gap is a new ticket or a scenario change, never a note that fades

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

- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- Test the scenario, not the demo. Walk the stakeholder through the Given, When, Then as written; if they want something else, that is a requirement change, and it goes through the feature file.
- A gap is not a failure of the build if the scenario was met. Record it as a new requirement so Development is not blamed for a discovery miss.
- Record acceptance by name. "Accepted by the product owner on this date" is evidence; "UAT passed" is not.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
