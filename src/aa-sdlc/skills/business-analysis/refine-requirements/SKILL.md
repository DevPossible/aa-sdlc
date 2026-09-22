---
name: refine-requirements
description: "Close the gaps. Turn draft scenarios into complete, unambiguous, testable ones; record the technical constraints they must live within; link every scenario to its ticket and page."
aa:
  discipline: business-analysis
  step: refine-requirements
  guidance_sets: [every-step, anchored-step, repository-write]
  guidance: [G-16, G-18, G-19, G-35]
  requires: [R-03, R-16, R-29]
---

# /aa-ba-refine-requirements

Close the gaps. Turn draft scenarios into complete, unambiguous, testable ones; record the technical constraints they must live within; link every scenario to its ticket and page.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- Draft scenarios and the question log from discover
- Answers from stakeholders
- Technical constraints from Technical Analysis and Security, if available

## Procedure

1. **Anchor.** Read the anchor ticket, its linked draft scenarios, and its page (G-22). Read the
   question log from discover, the answers stakeholders have given, and the technical
   constraints from Technical Analysis and Security where they exist. Read each feature file at
   head immediately before editing it (G-03).
2. **Apply the answers.** For each answered question, change the scenario in its feature file
   first; the ticket's acceptance criteria and the page follow through the tooling (G-18,
   T-12). Never edit the ticket first. A question still open stays on the ticket with an owner
   (G-16).
3. **Goals before pictures.** Where an answer arrived as a mock-up or screenshot, write the
   scenario it implies and log what it does not show as a question; the picture is evidence,
   not the requirement (G-35, O-15).
4. **One behaviour per scenario.** Split any scenario whose Then describes two outcomes that
   could fail independently. Replace every "should work correctly" with concrete Given, When,
   Then steps.
5. **Make it executable in principle.** Every step names something a test could observe; a step
   that cannot be observed is rewritten or recorded as a question, never left as a hope. Tag
   every scenario with its ticket and name the knowledge base page in the feature description
   (G-19, O-01).
6. **Record the constraints.** Write the technical constraints document in the knowledge base,
   linked from the epic: the platform, integration, compliance, and performance constraints the
   scenarios must satisfy, each with its source. A constraint that contradicts a scenario is a
   question on the ticket, not a silent edit.
7. **Update the ticket and present the change.** Link ticket, feature file, and page both ways
   (G-26). Update the ticket with which ambiguities were resolved, which remain as open
   questions, and what remains (G-12). Stage the changed feature files and present the summary
   with a Conventional Commit message; commit only if the user asked for that commit (O-17,
   G-40). Then report.

## Artifacts

**Feature files** in the features folder. Done when:

- Every scenario has concrete Given, When, Then steps with no "should work correctly"
- Every scenario is tagged with its ticket; every feature names its knowledge base page
- Ambiguities are resolved or recorded as open questions on the ticket

**Technical constraints document** in the knowledge base, linked from the epic. Done when:

- Lists the constraints (platform, integration, compliance, performance) the scenarios must satisfy, each with its source

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

*From the `repository-write` set:* What every step that changes files in the repository does: keep artifacts with the code, write Conventional Commit messages, one cohesive change per commit, stage and present rather than commit, and name the purpose of every change.

- **G-11** Every artifact that belongs with the code goes into the same change set as the code, staged for the commit the user makes (G-40). Nothing that matters is left only on a local disk or in a conversation.
- **G-33** Write every commit message in Conventional Commits form: a type from the project's list, an optional scope, an imperative subject, a body that says why, and a footer carrying the ticket reference and any breaking change. One concern per commit (G-39); if you cannot name the type, split the commit.
- **G-39** Make each commit one understandable change: one concern per commit, one ticket per branch, a subject that says what and a body that says why, small enough to review in one sitting. If the subject needs "and" or the diff needs a tour, split it.
- **G-40** Never commit unless the user asked for that commit. Stage the change, write the message, present the staged diff summary and the message, and stop; a request to implement, fix, finish, or run a step is not a request to commit, and the commit is made under the user's identity with no agent attribution.
- **G-42** Before making a change, name what it is for: the ticket, the scenario it satisfies, or the decision record or page that explains it, and put that reference where the change lives: the branch, the commit footer, the merge request, and the artifact. A change that cannot name its purpose is a ticket to create first or work not to do; in review, a hunk that traces to nothing is a finding.

*For this step:*

- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-19** Tag every scenario with its anchor ticket, and name the feature's knowledge base page in the feature description.
- **G-35** Start every requirement from written goals: the outcome, then the scenarios. When a screenshot or mock-up arrives first, treat it as evidence of what someone wants: write the goals and scenarios it implies, record what it does not show as questions on the ticket, get them confirmed, and only then produce a mock-up from them.
- One behaviour per scenario. If a scenario needs "and" in its Then to describe two outcomes that could fail independently, split it.
- Make it executable in principle. Every step must be something a test could observe; if it cannot be observed, it is not a requirement, it is a hope.
- Trace every change. When a scenario changes, the ticket's acceptance criteria and the page follow (T-12); never edit the ticket first.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
