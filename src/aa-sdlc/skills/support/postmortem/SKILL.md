---
name: postmortem
description: "After an incident is closed, review what happened using the timeline and the evidence, find the contributing causes without blame, and raise the tickets that will prevent recurrence or shorten the next response."
aa:
  discipline: support
  step: postmortem
  guidance_sets: [every-step, anchored-step]
  guidance: [G-41]
  requires: [R-03, R-32]
---

# /aa-sup-postmortem

After an incident is closed, review what happened using the timeline and the evidence, find the contributing causes without blame, and raise the tickets that will prevent recurrence or shorten the next response.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The incident timeline and mitigation record
- Related tickets, releases, and changes

## Procedure

1. **Anchor.** Read the incident ticket, its timeline, and its mitigation record, then its linked
   scenarios and page (G-22). Read the related tickets, releases, and changes the incident
   links to. If the timeline has gaps, the review says so and works from what was recorded; no
   entry is reconstructed.
2. **Compute the times from the timeline** with a tool: time to detect, time to respond, time to
   restore, and the duration of impact, quoting the timestamps each was calculated from (G-02).
   State the impact in the terms the timeline supports: which scenarios failed, for whom, for
   how long. Where a timestamp is missing, the review says the figure could not be computed
   rather than estimating it.
3. **Walk the timeline decision by decision** and ask of each "what made this reasonable at the
   time". Record what was known then, what was not, and what would have made a better choice
   available sooner. Blame finds a person; this finds a cause.
4. **List the contributing causes**, naming systems, changes, and decisions, never people: the
   release that introduced it, the alert that did not fire, the runbook that was out of date,
   the check that did not exist. Each cause cites the timeline entry or the change that
   evidences it (T-07).
5. **Choose the actions.** For each cause, say whether it is removed, detected sooner, or
   accepted, and why; prefer one action that removes the cause over five that add checks around
   it. Each such choice is a decision record (O-18, G-41): one screen, numbered next in the
   repository's sequence, dated, with context, options considered, decision, and consequences,
   linked from the incident.
6. **Raise the prevention tickets** in the configured ticket project (G-27), one per action,
   each with an owner and a link to its decision record. An action without a ticket is a wish;
   the owner may be the person running this step (T-13).
7. **Write the post-incident review** in the knowledge base, linked from the incident: the
   impact, the computed times, the timeline in summary, the contributing causes, the decision
   records, and the prevention tickets, for a reader who was not there (G-24, G-26).
8. **Update the incident ticket** with the link to the review, the records, and the tickets
   raised (G-12). If the review or the decision records live in the documents folder, stage
   them and present the change set; commit only if the user asked for that commit (O-17,
   G-40). Then report.

## Artifacts

**Post-incident review** in the knowledge base, linked from the incident. Done when:

- States impact, detection time, response time, and time to restore, computed from the timeline
- Lists contributing causes; names systems and decisions, not people

**Prevention tickets** in the ticket system. Done when:

- Every action item is a ticket with an owner; the review links them

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-41** Write every significant decision, technical, product, or process, as a decision record the moment it is made: one screen, numbered next in the repository's sequence, dated, with context, options considered, decision, and consequences, linked from the anchor ticket. Never edit an accepted record; supersede it with a new one that links back.
- Compute the times from the timeline with a tool; do not estimate them.
- Ask "what made this reasonable at the time" for every decision in the timeline. Blame finds a person; this finds a cause.
- Prefer one action that removes the cause over five that add checks around it.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
