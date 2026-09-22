---
name: generate-tests
description: "Start from the scenarios and the tests Development wrote, then apply general testing strategies to find and test what the requirement did not say. Every gap becomes a question on the ticket and a scenario in the feature file."
aa:
  discipline: testing
  step: generate-tests
  guidance_sets: [every-step, anchored-step, repository-write, test-writing]
  guidance: [G-07, G-18, G-19, G-21]
  requires: [R-16, R-17]
---

# /aa-qa-generate-tests

Start from the scenarios and the tests Development wrote, then apply general testing strategies to find and test what the requirement did not say. Every gap becomes a question on the ticket and a scenario in the feature file.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The ticket's scenarios and the tests already written for them
- The test strategy for the epic
- The built code, read for branches and states the scenarios do not mention

## Procedure

1. **Anchor and check currency.** Read the ticket, its scenarios, its knowledge base page, and
   the test strategy for the epic. Confirm the change Development made for the ticket is at the
   head; if the ticket records a revision, compare it with the head for the linked feature
   files and record what changed on the ticket (O-13). Run the tiers the ticket touches from
   the root test script and keep the output as the starting point (G-04).
2. **Read Development's tests and say what they cover.** For each scenario, list the unit,
   integration, and end-to-end tests that already prove it (O-08). Write that coverage on the
   ticket. This step starts where those tests stop and never duplicates one (G-21).
3. **Read the built code for what the scenarios do not say.** Look for branches, states, and
   inputs no scenario names, and look hardest at the seams: between components, between tiers,
   and between the system and its dependencies. List each candidate with the strategy that
   found it: boundaries, state transitions, error and recovery paths, concurrency, realistic
   interaction sequences (G-21).
4. **Sort every finding before writing a test.** Behaviour a scenario states but no test proves
   is a test to write. Behaviour the code has that no scenario states is a question on the
   ticket and a pending scenario in the feature file, tagged with the ticket and tagged as
   awaiting an answer (G-07, G-19); the feature file changes first and the ticket and page
   follow (G-18). A gap is never left as a comment in test code.
5. **Write the tests on a branch that references the ticket** (G-39). Unit tests live with the
   project; integration and end-to-end tests live under the tests folder (G-25). Every test
   controls time, randomness, state, and dependencies, and runs alone and in any order with the
   same result (O-23, G-46); end-to-end tests run against containers started from the
   repository's definitions where the stack allows (O-12). Each test names the scenario or the
   question it serves (G-42).
6. **Prove the suite.** Run the touched tiers from the root test script, then each new test on
   its own and the tier in shuffled order, and quote the output (G-04, O-23). A new test that
   fails because the software is wrong is a defect ticket linked to this one; it is never
   weakened, skipped, or retried into green (G-06).
7. **Stage and present.** Stage the tests and the feature file changes as one change set with a
   Conventional Commit message naming the ticket (G-33, G-39), present the staged diff and
   the message, and stop. Commit only if the user asked for that commit (O-17, G-40).
8. **Update the ticket** with which scenarios now have tests beyond Development's, the questions
   and pending scenarios raised, any defect tickets, and what remains, linked both ways (G-12,
   G-26). Then report.

## Artifacts

**Extended test suite** in unit tests with the project; integration and e2e under tests/. Done when:

- Adds tests for boundaries, state transitions, error and recovery paths, concurrency, and realistic interaction sequences where relevant
- Does not duplicate Development's tests

**Gaps as scenarios and questions** in the features folder and the anchor ticket. Done when:

- Every behaviour found that the requirement did not specify is a question on the ticket and a pending scenario in the feature file

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

*From the `test-writing` set:* What every step that writes or extends automated tests does: prove with the actual run, and keep every test deterministic and independent.

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-46** Make every test deterministic and independent: inject or freeze time, seed or inject randomness, give each test its own state and clean it up, and replace external dependencies with a container, a fake, or a recorded response; never depend on test order, on state another test left, or on a sleep. A test that fails intermittently is a defect: quarantine it with a ticket the same day, never retry it into green or skip it without one (G-06).

*For this step:*

- **G-07** Write business-facing behaviour as Gherkin scenarios in the features folder before the change, and technical behaviour as executable tests alongside it.
- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-19** Tag every scenario with its anchor ticket, and name the feature's knowledge base page in the feature description.
- **G-21** Start from the feature files, then apply general testing strategies (boundaries, state transitions, error and recovery paths, concurrency, realistic user interaction sequences) to find what the requirement did not say. Record each gap as a question on the ticket and a new scenario in the feature file.
- Read Development's tests first and say what they cover. Your job starts where theirs stops.
- Test the seams. The boundaries between components, between tiers, and between the system and its dependencies are where the requirement was vaguest.
- Every test you add runs alone and in any order with the same result. Control time, randomness, state, and dependencies; never lean on another test having run first (O-23).
- A pending scenario is a real scenario with a tag saying it awaits an answer. Do not leave gaps as comments in test code.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
