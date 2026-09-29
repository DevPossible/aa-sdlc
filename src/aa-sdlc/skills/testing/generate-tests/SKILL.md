---
name: generate-tests
description: "Start from the scenarios and the tests Development wrote, then apply general testing strategies to find and test what the requirement did not say. Every gap becomes a question on the ticket and a Draft scenario on the feature page."
aa:
  discipline: testing
  step: generate-tests
  guidance_sets: [every-step, anchored-step, repository-write, test-writing]
  guidance: [G-07, G-18, G-19, G-21, G-49]
  requires: [R-16, R-17, R-40]
---

# /aa-qa-generate-tests

Start from the scenarios and the tests Development wrote, then apply general testing strategies to find and test what the requirement did not say. Every gap becomes a question on the ticket and a Draft scenario on the feature page.

## Anchor

Anchor first (G-22). Read the anchor ticket and its knowledge base page, and pull the feature pages it links to into the features folder (G-54), before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The ticket's scenarios and the tests already written for them
- The test strategy for the epic
- The built code, read for branches and states the scenarios do not mention

## Procedure

**Hand the independent part to a separate context where you can** (decision record 0015). If this
harness can run the `aa-qa` subagent, give it steps 2 to 4 (read Development's tests, read the built
code for what the scenarios do not say, sort the findings), with the ticket, its scenarios, and the
branch, and write the tests from what it returns in step 5, saying the findings came from the agent.
Otherwise do those steps yourself, without relying on what you know of how the code was meant to
work.

1. **Anchor, pull, and check currency.** Read the ticket and pull the feature pages it links to:
   their Approved scenarios into the features folder, and the page versions recorded on the
   ticket (G-54). For a documents-folder knowledge base run `scripts/aa-sdlc/Sync-FeatureFiles.ps1
   -KnowledgeRoot <folder> -FeaturesRoot <features>`; otherwise read each page and convert it with
   `ConvertFrom-FeaturePage` from `scripts/aa-sdlc/AaFeatures.psm1`. Then read the pulled
   scenarios and the test strategy for the epic. Confirm the change Development made for the
   ticket is at the head; if the ticket records a revision or page versions, compare them with
   the head and the pages now, and record what changed on the ticket (O-13). Run the tiers the
   ticket touches from the root test script and keep the output as the starting point (G-04).
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
   ticket and a Draft scenario proposed on its feature page, tagged with the ticket, with its id
   cell left empty for G-49 to fill (G-07, G-19); for a documents-folder knowledge base run
   `scripts/aa-sdlc/Add-FeatureId.ps1 -KnowledgeRoot <folder>`. The feature file is never
   edited; the scenario reaches the repository when its owner approves it and the page is pulled
   again (G-18). Propose it only on a page under the project's own knowledge root (G-55). A gap
   is never left as a comment in test code.
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
7. **Stage and present.** Stage the tests, and the page changes where the knowledge base is the
   documents folder, as one change set with a Conventional Commit message naming the ticket
   (G-33, G-39), present the staged diff and the message, and stop. Commit only if the user
   asked for that commit (O-17, G-40).
8. **Update the ticket** with which scenarios now have tests beyond Development's, the questions
   raised and the Draft scenarios proposed, any defect tickets, and what remains, linked both
   ways (G-12, G-26). Then report.

## Artifacts

**Extended test suite** in unit tests with the project; integration and e2e under tests/. Done when:

- Adds tests for boundaries, state transitions, error and recovery paths, concurrency, and realistic interaction sequences where relevant
- Does not duplicate Development's tests

**Gaps as scenarios and questions** in the feature pages in the knowledge base and the anchor ticket. Done when:

- Every behaviour found that the requirement did not specify is a question on the ticket and a Draft scenario proposed on its feature page

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first and pull the feature pages it links to, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/repository-write.md`: What every step that changes files in the repository does: keep artifacts with the code, write Conventional Commit messages, one cohesive change per commit, stage and present rather than commit, and name the purpose of every change.
- `src/aa-sdlc/skills/aa-guidance/sets/test-writing.md`: What every step that writes or extends automated tests does: prove with the actual run, and keep every test deterministic and independent.

*For this step:*

- **G-07** Write business-facing behaviour as Gherkin scenarios in the features folder before the change, and technical behaviour as executable tests alongside it.
- **G-18** Change a requirement on its feature page in the knowledge base, under the ticket that asks for it, then pull the page into the repository. Never edit a feature file by hand; a change found while building is converted to the page format and proposed on the page for its owner to approve.
- **G-19** Tag every Approved scenario on its feature page with the ticket that asked for it, and link the ticket to the page and the scenario ids.
- **G-21** Start from the scenarios pulled from the feature pages, then apply general testing strategies (boundaries, state transitions, error and recovery paths, concurrency, realistic user interaction sequences) to find what the requirement did not say. Record each gap as a question on the ticket and a Draft scenario proposed on its feature page, never in the feature file.
- **G-49** Give every feature a stable id (F-nnn) and every scenario one derived from it (F-nnn-nn), assigned on its feature page once and never renumbered or reused; tag or name every automated test with the ids of the scenarios it proves, so coverage is the set of scenario ids that at least one test names.
- Read Development's tests first and say what they cover. Your job starts where theirs stops.
- Test the seams. The boundaries between components, between tiers, and between the system and its dependencies are where the requirement was vaguest.
- Every test you add runs alone and in any order with the same result. Control time, randomness, state, and dependencies; never lean on another test having run first (O-23).
- A Draft scenario on the feature page is a real scenario awaiting an answer; it reaches the repository only when its owner approves it. Do not leave gaps as comments in test code, and never add them to a feature file (G-18).

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
