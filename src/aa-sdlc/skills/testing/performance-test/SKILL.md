---
name: performance-test
description: "Establish how the system behaves under expected and peak load against stated targets, record the baseline, and raise tickets where targets are missed."
aa:
  discipline: testing
  step: performance-test
  guidance_sets: [every-step, anchored-step, repository-write, test-writing]
  guidance: [G-30]
  requires: [R-03, R-25]
---

# /aa-qa-performance-test

Establish how the system behaves under expected and peak load against stated targets, record the baseline, and raise tickets where targets are missed.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- Performance targets from the technical constraints and scenarios
- A production-like environment and the project's load testing tool category

## Procedure

1. **Anchor and check the targets.** Read the ticket, its scenarios, the technical constraints,
   and its knowledge base page. Write down every performance target as a number with its
   condition: the load, the data volume, and the percentile it applies to. A target with no
   number is a question to the ticket owner on the ticket, and nothing is run against it until
   it has one; "fast" is not a target. If the ticket records a revision, compare it with the
   head for the linked feature files and record what changed (O-13).
2. **Stand up the environment and record it before measuring.** Start the system and its
   dependencies from the repository's container definitions where the stack allows, otherwise
   in the production-like environment the ticket names (O-12, G-30). Record the machine class,
   the configuration, the revision under test, and the data volume. Load the data from a seeded,
   repeatable source so a later run starts from the same state (O-23).
3. **Write the load profiles as a suite in the repository,** on a branch that references the
   ticket (G-39), under the end-to-end folder or the location the project config names for
   performance tests (G-25). One profile per target condition, expected and peak, with the
   environment, data volume, and load profile recorded beside it so the run is reproducible.
   Each profile owns its data and cleans up after itself (G-46).
4. **Run each profile with the load testing tool and keep the distribution.** Report the
   percentiles, the error rate, and the throughput, never the average alone; the slowest five
   percent is what users complain about. Run long enough for the numbers to settle and repeat
   the run to show they hold (T-07). Keep the raw output.
5. **Compare each measurement with its target by computing it** (G-02). Record pass or fail per
   target with the measured gap and the method that produced it.
6. **Write the baseline report in the knowledge base,** linked from the ticket and linking back
   (G-25, G-26), for a reader who was not there (G-24): every target with its measured value,
   the method, the environment, and pass or fail.
7. **Raise a ticket for every miss** in the configured ticket project (G-27), carrying the
   measured gap, the profile that produced it, and a link to the report, and link it from the
   anchor ticket.
8. **Stage, present, and update the ticket.** Stage the suite and its recorded profiles as one
   change set with a Conventional Commit message naming the ticket (G-33), present the staged
   diff and the message, and stop; commit only if the user asked for that commit (O-17, G-40).
   Update the anchor ticket with the report, the tickets raised, and what remains (G-12). Then
   report.

## Artifacts

**Performance test suite** in tests/e2e or the location the project config names for performance tests. Done when:

- Reproducible: environment, data volume, and load profile are recorded with the suite

**Performance baseline report** in the knowledge base, linked from the ticket. Done when:

- Reports each target with the measured value, the method, and pass or fail
- Every miss is a ticket with the measured gap

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

- **G-30** Run the end-to-end tier against the system and its dependencies started in containers from definitions committed to the repository, so it runs the same way on any machine and in the pipeline. Reach a shared environment only for a dependency that cannot be containerised, and record which tests depend on it.
- No target, no test. If the requirement has no number, get one from the ticket owner before running anything; "fast" is not a target.
- Measure with a tool and report the distribution, not the average. The slowest 5 percent is what users complain about.
- Record the environment with the result. A number without the machine, data volume, and load profile cannot be compared to anything later.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
