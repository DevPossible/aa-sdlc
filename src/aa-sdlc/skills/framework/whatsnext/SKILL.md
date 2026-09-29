---
name: whatsnext
description: "Review the working folder, and the ticket system and knowledge base it links to, against the framework's requirements, opinions, and processes in a fixed order of layers, stop at the first major gap, and name the one thing to do next, usually a command with its arguments. Change nothing."
aa:
  discipline: framework
  step: whatsnext
  guidance_sets: [every-step]
  guidance: [G-04]
  requires: [R-01, R-02, R-03, R-07, R-40, R-41, R-43]
---

# /aa-fw-whatsnext

Review the working folder, and the ticket system and knowledge base it links to, against the framework's requirements, opinions, and processes in a fixed order of layers, stop at the first major gap, and name the one thing to do next, usually a command with its arguments. Change nothing.

## Anchor

No ticket anchor. This command runs against the install or the repository, not a unit of work.

## Inputs

- The working folder, whether or not it is a repository yet
- The merged aa.config.yaml, if a project is in scope
- The health report: the requirements that are required and unmet
- The working tree, the current branch, open merge requests, and the recent commits on the default branch
- The decision records, feature files, and tests the recent commits touched
- The knowledge base pages linked to recent tickets and feature files
- The current iteration and the ordered backlog in the ticket system

## Procedure

Work through the layers in this order. Each layer either passes, is not checkable (a system out
of reach; say which and why, then continue), or has a major gap. At the first major gap, stop
and report it; do not look further. A later layer cannot be trusted while an earlier one is
broken: there is no point choosing the next ticket while the last change broke the build.

1. **Foundation.** Is the folder a repository with a remote, an AA-SDLC project config, and a
   linked ticket project that can carry the life cycle (R-41, R-43), and a knowledge base? Take
   this from `/aa-fw-health`: run it, or read its report if one was produced in this session,
   and use its required-and-unmet findings. Do not probe requirements again. On an empty folder
   the gap is the project itself: recommend `aa init`, then `/aa-fw-init` to link the ticket
   project and the knowledge base. On a repository with a gap health names, recommend
   `/aa-fw-init` with the requirement ids.
2. **Work in flight.** Read the working tree, the current branch, and the open merge requests
   (O-02, O-17). Uncommitted changes, or a branch whose work looks complete but is not merged,
   is the gap: recommend `/aa-dev-finish-branch` with the ticket id the branch names. An open
   merge request with no review, or with review comments not answered, is the gap: recommend
   `/aa-dev-review` or the author answering the comments.
3. **Recent changes held to the opinions.** Read the commits on the default branch since the
   last release tag, or the last twenty if there is no tag. For each, check what it touched:
   - A commit that references no ticket breaks O-19: recommend creating the ticket and linking
     it, naming the commits.
   - Code changed with no test changed or added breaks O-07: recommend `/aa-qa-generate-tests`
     with the ticket id, or `/aa-dev-implement` if the change is unfinished.
   - A scenario added or changed with no test naming its id (G-49) leaves it uncovered (R-40):
     recommend `/aa-qa-generate-tests` with the scenario id and the ticket id. Use the coverage
     finding from the health report; do not search again.
   - Behaviour changed with no feature file changed breaks O-01 and T-12: recommend
     `/aa-ba-refine-requirements` with the ticket id.
   - A significant decision (a new dependency, a new component, a changed boundary) with no
     decision record breaks O-18: recommend `/aa-ta-decide`.
   Run the root build and test scripts, time-boxed, and quote the result (G-04, G-15). A failing
   build or test on the default branch is the gap, whatever else is true: recommend
   `/aa-dev-fix-bug` with the failing test named.
4. **Knowledge in step.** Read the knowledge base pages linked from the tickets and feature
   files the recent commits touched (O-04). A page that describes behaviour the recent changes
   altered, or a decision the records have superseded, is the gap: recommend
   `/aa-doc-maintain-docs`, naming the pages. If no knowledge base is reachable, say this layer
   was not checked.
5. **The next ticket.** Read the current iteration in the ticket system (O-03) and take the
   highest-priority ticket not done. Its life-cycle state (O-26), read through the project config's
   mapping, chooses the command: New is `/aa-rf-refine-ticket`; Refined is
   `/aa-ip-plan-implementation`; Planned is `/aa-dev-implement`; In review with its change merged
   is `/aa-ba-uat`; Accepted is `/aa-rel-prepare-release`. With no current
   iteration, recommend `/aa-pm-plan-iteration`; with an empty backlog, `/aa-pd-prioritise`, or
   `/aa-pd-define-outcome` if there is no outcome to prioritise against.
6. **Nothing found.** If every layer passes, say so, and recommend `/aa-pm-retrospective` if an
   iteration has closed since the last one, or `/aa-pd-iterate` to turn feedback into the next
   work.

Change nothing at any layer: no file, ticket, page, commit, or install, even to make a check
possible (T-03, T-10).

## Artifacts

**Next-step recommendation**, returned to the user; nothing is written. Done when:

- Names exactly one gap, the first major one in the layer order, with the evidence that shows it
- Names the one thing to do about it, as a command with its arguments where a command fits
- Lists the layers checked before it and that each passed, so the user knows what was not found wrong
- Says when a layer could not be checked because a system was out of reach, and moves on to the next layer
- Ends with the remaining planned work: the open tickets in the current iteration counted by state, or says it could not be read

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.

*For this step:*

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- Check the layers in order and stop at the first major gap: foundation (a repository, the project config, the linked ticket project able to carry the life cycle, and the knowledge base), work in flight (uncommitted changes, an unfinished branch, a merge request awaiting review), recent changes held to the opinions (each commit traces to a ticket, code changes carry tests, significant decisions have records, behaviour changes have scenarios), the knowledge base in step with recent changes, then the next ticket. A later layer cannot be trusted while an earlier one has a gap.
- A gap is major when it breaks a required requirement, an opinion on the default branch, or work already started. Anything smaller is not reported; the command answers one question, what to do next, not what could be better.
- Take the foundation layer from /aa-fw-health's required-and-unmet findings rather than probing requirements again; health owns requirement checks, and this step owns choosing among them.
- Recommend the step that closes the gap, named as its command with its arguments, such as /aa-qa-generate-tests with the ticket id. Where no command fits, say plainly what to do.
- Choose the next ticket from the current iteration in priority order, and let its life-cycle state (O-26) choose the command. New is /aa-rf-refine-ticket; Refined is /aa-ip-plan-implementation; Planned is /aa-dev-implement; In review with its change merged is /aa-ba-uat; Accepted is /aa-rel-prepare-release. No iteration is /aa-pm-plan-iteration; an empty backlog is /aa-pd-prioritise.
- Change nothing. Read the folder, the tickets, and the pages; do not create, edit, commit, transition, or install anything, even to make a check possible.
- When a system is out of reach, say which layer could not be checked and why, and continue with the layers that can be; never report a layer as passed that was not checked.

## Report

Lead with the recommendation, then the evidence, then the layers:

```
Next: <command and arguments, or the plain action>
Why:  <the gap, in one sentence> (<the requirement, opinion, or process it breaks>)
Evidence: <what was read or run that shows it, quoted>
Layers: foundation passed | work in flight passed | recent changes <gap> | knowledge not reached | next ticket not reached
Remaining: <n> open in <iteration>: <count> new, <count> refined, <count> planned, <count> in progress, <count> in review
```

Name every layer checked, the one that stopped the review, and the ones not reached. A layer
that could not be checked says why. Whatever layer stopped the review, end with the remaining
planned work, read from the current iteration in the ticket system, so the user sees what is
left as well as what is next; if the ticket system is out of reach, say so. Quote the output of
anything run (G-15).
