---
name: status
description: "Produce a status report for an iteration, epic, or release from the ticket system and source control, not from memory or opinion: done, in progress, blocked, at risk, and why."
aa:
  discipline: project-management
  step: status
  guidance_sets: [every-step, anchored-step]
  guidance: [G-04, G-62]
  requires: [R-01]
---

# /aa-pm-status

Produce a status report for an iteration, epic, or release from the ticket system and source control, not from memory or opinion: done, in progress, blocked, at risk, and why.

## Anchor

A ticket is optional here. When one is given, read it and its page and pull the feature pages it links to first (G-22, G-54) and write the outcome back to it; when none is, produce the artifacts locally and say so.

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
   Name the demonstrated user operation, next missing real join, owner and age of the current
   integration failure. Ticket and test counts alone do not establish delivery (G-62).
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
   written as a file in the repository, stage it and present it; honor existing explicit task commit authorization (O-17, G-40). Then report.

## Artifacts

**Status report** in returned to the user; posted to the knowledge base or the iteration ticket if asked. Done when:

- Every claim traces to a ticket or a merge request
- Blocked and at-risk items name the blocker and who owns unblocking it
- Says what changed since the last report
- Names demonstrated user operations, the next missing real join, its owner and the age of an unresolved integration failure

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first and check requirement currency, update the ticket at meaningful checkpoints, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-04** During development run focused checks; before review run the affected build, lint and relevant test tiers, retaining actual output and declaring the scope. At actual branch finish run full build, lint, provenance and every test tier; at release satisfy the release checks. Instruction-only changes use the framework's applicable structural validation rather than claiming product behavior.
- **G-62** Protect a continuous integration lane for the current runnable outcome; supporting work names the blocker it removes, and complete an active bounded checkpoint before redirecting noncritical work. Report first working behavior, first real join, setup-invalidated runs, next executable user operation and the age of the current integration failure; ticket, component and test counts alone are not delivery.
- Count with a tool and quote the count. "Most tickets are done" is not status; "14 of 19 committed tickets are done, 3 in review, 2 blocked" is.
- Report the blocked item before the finished ones. The reader can act on a blocker; they cannot act on praise.
- Say what you could not see. If a system was unreachable, the report says so rather than silently omitting it.

## Report

State what was produced and where, link actual run output and summarize its scope and results, name failures/skips and what remains (G-15). Update the anchor at the meaningful milestone (G-12), referencing one proportionate evidence record instead of repacking unchanged proof. Stage only task-owned changes; honor existing explicit task commit authorization, otherwise present the diff and Conventional Commit message without committing (G-40).
