---
name: test-strategy
description: "For an epic or release, decide what will be tested at which tier, what will be automated, what needs exploratory or manual attention, what environments and data are needed, and what will not be tested and why."
aa:
  discipline: testing
  step: test-strategy
  guidance_sets: [every-step, anchored-step]
  guidance: [G-16, G-21]
  requires: [R-03, R-16]
---

# /aa-qa-test-strategy

For an epic or release, decide what will be tested at which tier, what will be automated, what needs exploratory or manual attention, what environments and data are needed, and what will not be tested and why.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The feature files and architecture for the scope
- The risk view from Security and Technical Analysis
- Existing suites and their coverage

## Procedure

1. **Anchor.** Read the epic or release ticket, every feature file in its scope, its knowledge
   base page, and the architecture it will run on. Read the risk view from Security and
   Technical Analysis and the existing suites. Note the head revision the strategy is written
   against so a later run can tell what changed.
2. **Inventory what is already proven.** For every scenario in scope, list the tests that exist
   for it and the tier each lives in; these are what Development owes for the requirement
   (O-08). Write the table down. The strategy starts where those tests stop (G-21).
3. **Assign every scenario a tier and an approach.** Prove each one at the lowest tier that can
   observe it; the end-to-end tier is for what only end-to-end can see. Say whether it is
   automated, exploratory, or manual, and why. No scenario is left without a row.
4. **Name and rank the risks.** Start from the risk view, then add the ones the requirement does
   not mention: concurrency, data volume, partial failure, and permissions. Rank them; the
   highest get the most tests and the most attention, and each names the scenarios or tests
   that address it or is recorded as a gap.
5. **Decide the environments and data each tier needs.** The end-to-end tier runs against the
   system and its dependencies in containers from the repository's definitions where the stack
   allows (O-12); a dependency that cannot be containerised is named with the tests that will
   depend on it. Every test owns its data and controls time, randomness, and state, so no tier
   relies on a shared environment being in a known condition (O-23).
6. **State what will not be tested, and what is not yet known.** List every out-of-scope item
   with its reason. State every assumption the strategy rests on, and put each question the
   scenarios do not answer on the ticket (G-16, G-21).
7. **Write the strategy in the knowledge base,** linked from the epic and linking back (G-25,
   G-26), for a reader who was not in this session (G-24). Check it against the acceptance:
   every scenario has a tier and an approach, the risks are ranked, the exclusions are reasoned.
8. **Update the ticket** with where the strategy is, the questions raised, and what remains
   (G-12). If the knowledge base is the documents folder, stage the page and present it with a
   Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).

## Artifacts

**Test strategy** in the knowledge base, linked from the epic. Done when:

- Every scenario is assigned a tier and an approach
- Risks are ranked and the highest have the most attention
- Out-of-scope items are listed with the reason

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-21** Start from the feature files, then apply general testing strategies (boundaries, state transitions, error and recovery paths, concurrency, realistic user interaction sequences) to find what the requirement did not say. Record each gap as a question on the ticket and a new scenario in the feature file.
- Push tests down. Prove it at the lowest tier that can observe it; end-to-end tests are for what only end-to-end can see.
- Name the risks the requirement does not mention. Concurrency, data volume, partial failure, and permissions rarely appear in scenarios and usually appear in incidents.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
