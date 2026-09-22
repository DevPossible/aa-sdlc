---
name: e2e-tests
description: "Automate the scenarios that can only be proven through the whole system as the user sees it, and where a user interface exists, the visual regression suite that catches what functional tests cannot."
aa:
  discipline: testing
  step: e2e-tests
  guidance_sets: [every-step, anchored-step, repository-write, test-writing]
  guidance: [G-21, G-30]
  requires: [R-16, R-25, R-26, R-17]
---

# /aa-qa-e2e-tests

Automate the scenarios that can only be proven through the whole system as the user sees it, and where a user interface exists, the visual regression suite that catches what functional tests cannot.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The scenarios assigned to the end-to-end tier by the strategy
- The system and its dependencies, started in containers from the repository's definitions where the stack allows (O-12)
- The project's end-to-end and visual testing tool categories

## Procedure

1. **Anchor and check currency.** Read the ticket, its knowledge base page, and the scenarios
   the test strategy assigns to the end-to-end tier. If the ticket records a revision, compare
   it with the head for the linked feature files and record what changed (O-13). Read the
   happy-path end-to-end tests Development already wrote for those scenarios (O-08); this step
   adds to them and does not repeat them (G-21).
2. **Start the environment from the repository.** Bring up the system and its dependencies in
   containers from the committed definitions (O-12, G-30) and record the revision under test.
   A missing or broken definition is a finding on the ticket. A dependency that cannot be
   containerised is reached in a shared environment, and every test that needs it is marked
   with the reason.
3. **Decide what only end-to-end can see.** For each assigned scenario, say what must be proven
   through the real entry points and what a lower tier already proves. Anything the scenarios
   do not say about the user's path becomes a question on the ticket and a pending scenario in
   the feature file (G-21).
4. **Write each test the way a user would act,** on a branch that references the ticket (G-39).
   Drive the system through its real entry points and never reach into internals to make a
   test pass. Every test creates the data it needs and cleans it up, controls time and
   randomness, and runs alone and in any order with the same result (O-23, G-46). Each test
   lives under the end-to-end folder and is tagged with the scenario it proves (G-25).
5. **Where a user interface exists, build the visual regression suite** in the same folder. The
   baselines are versioned beside the tests, captured from the containerised environment so
   they are stable, and any change to a baseline appears in the staged diff for review rather
   than being accepted silently.
6. **Run the tier from the root test script** with the end-to-end tier selected, then each new
   test alone and the tier in shuffled order, and quote the output (G-04, O-23). A test that
   fails intermittently is quarantined with a ticket the same day and is never wrapped in a
   retry (G-06). Tear the environment down afterwards.
7. **Stage and present.** Stage the tests, the baselines, any container definition changes, and
   the feature file changes as one change set with a Conventional Commit message naming the
   ticket (G-33, G-39), present the staged diff and the message, and stop. Commit only if the
   user asked for that commit (O-17, G-40).
8. **Update the ticket** with which scenarios now have end-to-end tests, which tests depend on
   a shared environment and why, which tests are quarantined and under what ticket, and what
   remains, linked both ways (G-12, G-26). Then report.

## Artifacts

**End-to-end test suite** in tests/e2e. Done when:

- Runs from the root test script with the e2e tier
- Each test maps to a scenario by tag; flaky tests are quarantined with a ticket, not retried into green

**Visual regression suite** in tests/e2e. Done when:

- Baselines are versioned and reviewed when they change

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

- **G-21** Start from the feature files, then apply general testing strategies (boundaries, state transitions, error and recovery paths, concurrency, realistic user interaction sequences) to find what the requirement did not say. Record each gap as a question on the ticket and a new scenario in the feature file.
- **G-30** Run the end-to-end tier against the system and its dependencies started in containers from definitions committed to the repository, so it runs the same way on any machine and in the pipeline. Reach a shared environment only for a dependency that cannot be containerised, and record which tests depend on it.
- Drive the system the way a user does, through its real entry points; do not reach into internals to make a test pass.
- Own the test data. Every end-to-end test creates what it needs and cleans up; a test that depends on leftover state will lie eventually.
- Own the environment too. Start it from the repository's container definitions and tear it down after; a test that needs a shared environment is marked and the reason recorded (O-12).
- A flaky test is a defect in the test or the system. Quarantine it with a ticket the same day; never wrap it in a retry to hide it (G-06, O-23).

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
