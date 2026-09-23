---
name: status
description: "Produce a status report for an iteration, epic, or release from the ticket system and source control, not from memory or opinion: done, in progress, blocked, at risk, and why."
aa:
  discipline: project-management
  step: status
  guidance_sets: [every-step, anchored-step]
  guidance: [G-04]
  requires: [R-01]
---

# /aa-pm-status

Produce a status report for an iteration, epic, or release from the ticket system and source control, not from memory or opinion: done, in progress, blocked, at risk, and why.

## Anchor

A ticket is optional here. When one is given, read it, its linked scenarios, and its page first (G-22) and write the outcome back to it; when none is, produce the artifacts locally and say so.

## Inputs

- The ticket system state for the scope requested
- Source control activity: branches, merge requests, and their state
- The previous status report, for what changed

## Procedure

1. **Anchor.** With a ticket (the iteration, epic, or release ticket), read it, its linked
   scenarios, and its page first (G-22) and post the report to it if asked; without one, take
   the scope from the user, return the report to them, and say so. Read the previous status
   report, if there is one, so this one can say what changed.
2. **Count from the ticket system, with a tool.** Query the scope and count committed, done, in
   progress, in review, blocked, and at risk, and quote the counts with the query that produced
   them (G-02). The ticket system is the truth for what is happening (O-03); "most tickets are
   done" is not status, "14 of 19 committed tickets are done, 3 in review, 2 blocked" is.
3. **Read source control for the same scope.** List the branches and merge requests that
   reference those tickets, their state, and the result of the latest build and test run on
   each (G-04). A ticket marked done with an unmerged branch, or a merge request whose latest
   run failed, is at risk whatever the ticket says (T-07).
4. **Name the blockers first.** For each blocked or at-risk item, record the blocker, the ticket
   or merge request that evidences it, and who owns unblocking it; if nobody does, say so and
   propose an owner. The reader can act on a blocker; they cannot act on praise.
5. **State what changed** since the previous report: items that moved state, blockers raised or
   cleared, scope added or removed, computed by comparing the two reports (G-02). With no
   previous report, say this is the first.
6. **Say what you could not see.** If the ticket system, source control, or a dashboard was
   unreachable or a query failed, the report names it and what it would have covered rather
   than omitting it silently (G-15).
7. **Assemble the report** in that order: blocked and at risk, then in progress, then done, every
   claim linked to its ticket or merge request, written for a reader who was not in this
   session (G-24). Return it to the user; post it to the knowledge base or the iteration ticket
   only if asked.
8. **Update the ticket** with the report or a link to it and its date (G-12). If the report was
   written as a file in the repository, stage it and present it; commit only if the user asked
   for that commit (O-17, G-40). Then report.

## Artifacts

**Status report** in returned to the user; posted to the knowledge base or the iteration ticket if asked. Done when:

- Every claim traces to a ticket or a merge request
- Blocked and at-risk items name the blocker and who owns unblocking it
- Says what changed since the last report

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- Count with a tool and quote the count. "Most tickets are done" is not status; "14 of 19 committed tickets are done, 3 in review, 2 blocked" is.
- Report the blocked item before the finished ones. The reader can act on a blocker; they cannot act on praise.
- Say what you could not see. If a system was unreachable, the report says so rather than silently omitting it.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
