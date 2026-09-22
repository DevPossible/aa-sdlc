# Plan: Discipline Review

**Status:** in progress. Started 2026-09-21.

A structured pass over every discipline, in the order it tends to appear in an SDLC, with three
approval gates each. Nothing is written into workflow data or skills until its gate is approved.

## Gates

| Gate | What is reviewed | Output when approved |
|------|------------------|----------------------|
| 1 Role | the discipline's purpose and bounded responsibilities: what it owns, what it explicitly does not own, and where it hands off to neighbours | the discipline entry in `docs/design.md` 3.1 and a `disciplines/<id>.yaml` in workflow data |
| 2 Commands | the list of steps and their `/aa-<code>-<step>` commands, with one line each on purpose, anchor, and primary artifact | `workflow/steps/<step>.yaml` for each step |
| 3 Guidance | for each command, the best-practice guidance the agent will follow, cited by `G-nn` and with new guidance promoted from inline to an ID | guidance attached in each step's YAML and `docs/guidance.md` |

Each gate is presented in chat, iterated on, and marked approved only when the user says so.

## Order and status

| # | Discipline | Code | Gate 1 Role | Gate 2 Commands | Gate 3 Guidance |
|---|------------|------|-------------|-----------------|-----------------|
| 0 | Framework | `fw` | pending | pending | pending |
| 1 | Product Management | `pd` | pending | pending | pending |
| 2 | Business Analysis | `ba` | pending | pending | pending |
| 3 | UX Design | `ux` | pending | pending | pending |
| 4 | Technical Analysis | `ta` | pending | pending | pending |
| 5 | Security | `sec` | pending | pending | pending |
| 6 | Refinement | `rf` | pending | pending | pending |
| 7 | Project Management | `pm` | pending | pending | pending |
| 8 | Implementation Planning | `ip` | pending | pending | pending |
| 9 | Development | `dev` | pending | pending | pending |
| 10 | Testing | `qa` | pending | pending | pending |
| 11 | Documentation | `doc` | pending | pending | pending |
| 12 | Release Management | `rel` | pending | pending | pending |
| 13 | Operations | `ops` | pending | pending | pending |
| 14 | Support | `sup` | pending | pending | pending |

Ordering notes: the framework comes first because setup and init precede any project work.
Security sits after Technical Analysis because threat modelling follows architecture, even
though its testing and maintenance steps recur later. Project Management sits after Refinement
because coordination starts once there is a backlog. Documentation sits after Testing because
its steps mostly maintain what earlier disciplines produced, though decision records are written
throughout.

## Working rules

- Role descriptions state boundaries explicitly: "owns", "does not own", "hands off to".
- A command list is complete when every step in the design map for that discipline appears,
  plus any the role review surfaced, and none overlap another discipline's command.
- Guidance is one or two sentences, names tool categories only (T-01), cites requirements it
  needs (T-11), and never assumes a team size (T-13).
- When a gate is approved, the plan's status cell is updated and the outputs are committed in
  the same change.
