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

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/repository-write.md`: What every step that changes files in the repository does: keep artifacts with the code, write Conventional Commit messages, one cohesive change per commit, stage and present rather than commit, and name the purpose of every change.
- `src/aa-sdlc/skills/aa-guidance/sets/test-writing.md`: What every step that writes or extends automated tests does: prove with the actual run, and keep every test deterministic and independent.

*For this step:*

- **G-30** Run the end-to-end tier against the system and its dependencies started in containers from definitions committed to the repository, so it runs the same way on any machine and in the pipeline. Reach a shared environment only for a dependency that cannot be containerised, and record which tests depend on it.
- No target, no test. If the requirement has no number, get one from the ticket owner before running anything; "fast" is not a target.
- Measure with a tool and report the distribution, not the average. The slowest 5 percent is what users complain about.
- Record the environment with the result. A number without the machine, data volume, and load profile cannot be compared to anything later.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
