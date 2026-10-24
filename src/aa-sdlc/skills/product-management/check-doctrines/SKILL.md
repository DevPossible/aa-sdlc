---
name: check-doctrines
description: "Read the doctrines and report which open tickets, approved scenarios, and decision records conflict with which doctrine or non-goal, and which doctrines nothing cites. Change nothing."
aa:
  discipline: product-management
  step: check-doctrines
  guidance_sets: [every-step]
  guidance: [G-57]
  requires: [R-02, R-03, R-48]
---

# /aa-pd-check-doctrines

Read the doctrines and report which open tickets, approved scenarios, and decision records conflict with which doctrine or non-goal, and which doctrines nothing cites. Change nothing.

## Anchor

No ticket anchor. This command runs against the install or the repository, not a unit of work.

## Inputs

- The doctrines page
- The open tickets in the ticket project, through the project's ticket filter
- The approved scenarios on the feature pages under the project's knowledge root
- The decision records

## Procedure

1. **Read the doctrines.** Read the doctrines page in the Overview section under the project's
   knowledge root. If there is none, report that alone and recommend
   `/aa-pd-discover-doctrines` for a project with anything to read, or
   `/aa-pd-define-doctrines` for a new one, and stop.
2. **Read the work in scope.** The open tickets through the project's ticket filter, the
   approved scenarios on the feature pages under the project's knowledge root, and the decision
   records (T-14). A source that cannot be reached is recorded as not read, with why.
3. **Check each item against each doctrine and non-goal** (G-57). A conflict is a pair: the
   item and the doctrine or non-goal, with the sentence in each that disagrees. A vague tension
   is not a finding.
4. **Find what nothing cites.** List the doctrines and non-goals no ticket, scenario, or
   decision record cites, and the open epics that cite no doctrine.
5. **Recommend one command per conflict.** `/aa-pd-amend-doctrines` where the doctrine is
   what should change, or `/aa-ba-refine-requirements`, `/aa-ta-decide`, or
   `/aa-pd-prioritise` with the ticket id where the work should.
6. **Change nothing.** Return the report. Do not edit, comment on, transition, or amend
   anything, even to record a finding.

## Artifacts

**Doctrine conflict report** in returned to the user; nothing is written. Done when:

- Lists every conflict as a pair: the item (ticket, scenario, or decision record) and the doctrine or non-goal it conflicts with, with the sentence in each that disagrees
- Lists the doctrines and non-goals nothing cites, and the open epics that cite no doctrine
- Recommends one next command per conflict, such as /aa-pd-amend-doctrines, or /aa-ba-refine-requirements with the ticket id
- Says which sources could not be read and why, and never reports an unread source as clean

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.

*For this step:*

- **G-57** Before writing or approving an outcome, a scenario, an architecture, a decision record, an order of the backlog, or a merge request, read the product's doctrines and check the work against each doctrine and non-goal, and cite the doctrine it serves or is bounded by (`D-nn`). When the work conflicts with one, name the doctrine and the conflict and do not go on with that part until the user decides: change the work, or propose an amendment (G-58). Never absorb a conflict silently. Where there are no doctrines, say the check was made against nothing.
- Change nothing. Read the doctrines, tickets, pages, and records; do not edit, comment, transition, or amend anything, even to record a finding.
- Read only what is this project's (T-14). Take its tickets through the ticket filter in the project config and its pages from under its knowledge root.
- A conflict is specific. Name the doctrine, the item, and the sentence in each that disagree; a vague tension is not a finding.
- Where there are no doctrines, report that alone and recommend /aa-pd-discover-doctrines for a project with anything to read, or /aa-pd-define-doctrines for a new one.

## Report

Return the conflict report: each conflict with its recommended command, then what nothing cites, then the sources that could not be read and why (G-15). Nothing is written, staged, or committed.
