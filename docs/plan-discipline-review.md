# Plan: Discipline Review

**Status:** drafted, awaiting review. Started 2026-09-21.

Every discipline has been defined as workflow data with three parts, in the order it tends to
appear in an SDLC. The user reviews the generated document and adjusts; nothing is approved
until they say so.

## Where to review

Read [discipline-review.md](discipline-review.md). It is generated from
`src/aa-sdlc/workflow/` by `scripts/Build-DisciplineReview.ps1`, so adjustments go into the
YAML (`disciplines/<id>.yaml` for roles, `steps/<step>.yaml` for commands and guidance,
`docs/guidance.md` for shared guidance) and the document is regenerated. The unit test tier
validates every cross-reference.

## Gates

| Gate | What is reviewed | Where it lives |
|------|------------------|----------------|
| 1 Role | purpose, owns, does not own, hands off to | `disciplines/<id>.yaml` |
| 2 Commands | the step list and each `/aa-<code>-<step>` with anchor and artifacts | `disciplines/<id>.yaml` steps list; `steps/<step>.yaml` |
| 3 Guidance | shared guidance cited by id plus step-specific inline guidance | `steps/<step>.yaml` guidance and guidance_inline; `docs/guidance.md` |

## Order and status

| # | Discipline | Code | Commands | Gate 1 Role | Gate 2 Commands | Gate 3 Guidance |
|---|------------|------|----------|-------------|-----------------|-----------------|
| 0 | Framework | `fw` | 3 | drafted | drafted | drafted |
| 1 | Product Management | `pd` | 3 | drafted | drafted | drafted |
| 2 | Business Analysis | `ba` | 3 | drafted | drafted | drafted |
| 3 | UX Design | `ux` | 2 | drafted | drafted | drafted |
| 4 | Technical Analysis | `ta` | 3 | drafted | drafted | drafted |
| 5 | Security | `sec` | 3 | drafted | drafted | drafted |
| 6 | Refinement | `rf` | 2 | drafted | drafted | drafted |
| 7 | Project Management | `pm` | 3 | drafted | drafted | drafted |
| 8 | Implementation Planning | `ip` | 2 | drafted | drafted | drafted |
| 9 | Development | `dev` | 6 | drafted | drafted | drafted |
| 10 | Testing | `qa` | 5 | drafted | drafted | drafted |
| 11 | Documentation | `doc` | 2 | drafted | drafted | drafted |
| 12 | Release Management | `rel` | 3 | drafted | drafted | drafted |
| 13 | Operations | `ops` | 4 | drafted | drafted | drafted |
| 14 | Support | `sup` | 3 | drafted | drafted | drafted |

47 commands in total. Status values: pending, drafted, approved.

## Choices made while drafting, for the reviewer's attention

- **Steps added beyond the methodology map:** `define-outcome`, `prioritise` (Product
  Management); `decide`, `spike` (Technical Analysis); `refine-ticket` (Refinement);
  `plan-iteration`, `status` (Project Management); `breakdown-tasks` (Implementation
  Planning); `fix-bug` (Development); `test-strategy`, `explore` (Testing);
  `document-feature` (Documentation); `postmortem` (Support).
- **Anchor is `optional`** for steps that can legitimately run without a ticket: Product
  Management's three, `plan-iteration`, `status`, `retrospective`, `triage`, and `extend`.
  Everything else is `required`. Framework `health` and `init` are `none`.
- **Shared guidance added:** G-22 anchor first, G-23 time box, G-24 write for the next reader,
  G-25 named location, G-26 bidirectional links. Everything else step-specific is inline.
- **Security testing sits in the Testing process** even though the step belongs to the
  Security discipline, because it runs in that phase.
- **`validate-production` is Operations, `uat` is Business Analysis**, per decision 32.

## Working rules

- Role descriptions state boundaries explicitly: "owns", "does not own", "hands off to".
- A command list is complete when every step in the design map for that discipline appears,
  plus any the role review surfaced, and none overlap another discipline's command.
- Guidance is one or two sentences, names tool categories only (T-01), cites requirements it
  needs (T-11), and never assumes a team size (T-13).
- When a gate is approved, the status cell is updated in the same change as the edit.
