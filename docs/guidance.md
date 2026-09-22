# Guidance Backlog

**Status:** working draft. Last updated 2026-09-21.

Guidance is a detail on a step or process that indicates how best to perform it (see the
[vocabulary](vocabulary.md)). Guidance is specific and actionable, written against tool
categories rather than tools (tenet T-01), and exists to compensate for what agents and humans
each reliably get wrong (T-06). Anything a piece of guidance depends on is declared as a
requirement (T-11) and listed in its `Requires` column by ID from
[requirements.md](requirements.md).

This file is the backlog of guidance not yet attached to a step or process. As skills are
written, guidance moves out of here and into the skill (for a step) or the process definition
(for a process). Each item keeps its ID so it can be traced.

| ID | Guidance | Attaches to | Requires |
|----|----------|-------------|----------|
| G-01 | Always format the code for the changed files before committing, but do not format files that were not changed. | Development: finish-branch | R-09; R-15 for enforcement |
| G-02 | Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate. | all steps | R-04 |
| G-03 | Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read. | all steps | none |
| G-04 | Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence. | Development, Testing | R-10, R-11 |
| G-05 | Reproduce a bug with a failing test or a captured observation before changing any code to fix it. | Development: implement | R-11 |
| G-06 | Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket. | all steps | none |
| G-07 | Write business-facing behaviour as Gherkin scenarios in the features folder before the change, and technical behaviour as executable tests alongside it. | Testing: generate-tests; Development: implement | R-11, R-16, R-17 |
| G-08 | One concern per commit, one ticket per branch. Before any multi-step change, write the plan and get it confirmed. | Implementation Planning; Development | R-01, R-05 |
| G-09 | Reference the anchor ticket in the branch name and every commit message. | Development: finish-branch | R-01, R-02, R-08 |
| G-10 | Record architectural and product decisions in the knowledge base, or as decision records in the documents folder, and link them from the anchor ticket. | Technical Analysis: architect; Documentation | R-03 or R-06 |
| G-11 | Commit every artifact that belongs with the code. Nothing that matters is left only on a local disk or in a conversation. | all steps | R-05 |
| G-12 | End every step by updating the anchor ticket with what was done, what was produced, and what remains. | all steps | R-02 |
| G-13 | Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance. | Release Management: release, rollback; Development: finish-branch | none |
| G-14 | Never use a bypass flag on a hook, check, or protected branch. If a gate blocks, fix the cause or tell the user. | Development: finish-branch | none |
| G-15 | Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial. | all steps | none |
| G-16 | State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket. | Business Analysis; Technical Analysis | R-02 |
| G-17 | After three failed attempts at the same fix, stop and reassess the approach rather than trying a fourth variation. | Development: implement | none |
| G-18 | Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict. | Business Analysis: refine-requirements; Refinement: plan-work | R-16, R-02, R-03 |
| G-19 | Tag every scenario with its anchor ticket, and name the feature's knowledge base page in the feature description. | Business Analysis: discover, refine-requirements | R-16, R-02, R-03 |
| G-20 | When implementing a ticket, write the automated tests that prove it: unit and integration tests for every happy path, the general permutations and cases, and the obvious negative cases, plus a happy-path end-to-end test for each scenario. The ticket is not done until they exist and pass. | Development: implement | R-11, R-21 |
| G-21 | Start from the feature files, then apply general testing strategies (boundaries, state transitions, error and recovery paths, concurrency, realistic user interaction sequences) to find what the requirement did not say. Record each gap as a question on the ticket and a new scenario in the feature file. | Testing: generate-tests, e2e-tests | R-11, R-16, R-21 |
| G-22 | Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone. | all steps | R-02, R-16 |
| G-23 | State a time box for any open-ended investigation before starting it, stop when it is reached, and report what was found either way. | Technical Analysis: spike, architect; Testing: explore; Implementation Planning | none |
| G-24 | Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13). | all steps | none |
| G-25 | Produce each artifact in the location the workflow names for it, with the name it gives. Never invent a new location or a variant name; if the named location is wrong for this project, change the project config, not the artifact (T-08). | all steps | R-07, R-18 |
| G-26 | Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature. | all steps | R-02, R-03 |
| G-27 | Create and anchor tickets only in the repository's one configured ticket project. If the work touches a ticket in another project, create or use a ticket in this project and link the two; never anchor a step on a ticket outside the configured project. | all anchored steps; Support: triage; Refinement: plan-work | R-02, R-07, R-22 |
| G-28 | Before recording a size, write on the ticket how the work will be built (what changes, what is unknown, what could go wrong) at a depth that matches the stakes, and cite that reasoning from the size. If a number is needed before that thinking exists, give a range labelled as a guess, do not record it as the size, and never commit an iteration on it. | Refinement: refine-ticket, plan-work; Implementation Planning: plan-implementation; Project Management: plan-iteration; Product Management: prioritise | R-02, R-23 |
| G-29 | Put every pipeline step's logic in a root script or a command committed to the repository and call it from the pipeline with the same arguments; when a pipeline step fails, reproduce it locally with that same script before changing anything. A step that can only run in the pipeline is a defect: ticket it and move the logic out. | Operations: setup-pipeline; Development: setup-environment, finish-branch, fix-bug | R-10, R-11, R-20, R-24 |
| G-30 | Run the end-to-end tier against the system and its dependencies started in containers from definitions committed to the repository, so it runs the same way on any machine and in the pipeline. Reach a shared environment only for a dependency that cannot be containerised, and record which tests depend on it. | Testing: e2e-tests, performance-test; Development: setup-environment, implement | R-11, R-21, R-25, R-26 |
| G-31 | When a ticket is refined or its plan is confirmed, record on the ticket the repository revision its scenarios and plan were checked against. | Refinement: refine-ticket; Implementation Planning: plan-implementation | R-01, R-02, R-05, R-27 |
| G-32 | Before starting work on a ticket, compare the repository at the revision recorded on the ticket with the current head, list the changes to the linked feature files and to the files the plan names, and record on the ticket whether the scenarios and plan still hold. A conflict goes back to refinement as a question on the ticket; never absorb it silently or start anyway without saying so. | Development: implement, fix-bug; Implementation Planning: plan-implementation | R-01, R-02, R-05, R-16, R-27 |

## Conventions for writing guidance

- One sentence where possible, two at most. The example G-01 is the model.
- Say what to do and, where it matters, what not to do.
- Name a tool category only if the guidance cannot be followed without one, and when you do,
  declare it as a requirement and cite the ID.
- If the guidance only makes sense for one stack or one team, it belongs in a plugin, not here.
