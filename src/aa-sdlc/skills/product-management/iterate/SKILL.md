---
name: iterate
description: "Turn what users, support, and production are saying into decisions: what to enhance, what to fix, what to stop. Produces a feedback analysis and a roadmap update, with new tickets where the answer is \"build\"."
aa:
  discipline: product-management
  step: iterate
  guidance_sets: [every-step, anchored-step]
  guidance: [G-41]
  requires: [R-03, R-32]
---

# /aa-pd-iterate

Turn what users, support, and production are saying into decisions: what to enhance, what to fix, what to stop. Produces a feedback analysis and a roadmap update, with new tickets where the answer is "build".

## Anchor

A ticket is optional here. When one is given, read it, its linked scenarios, and its page first (G-22) and write the outcome back to it; when none is, produce the artifacts locally and say so.

## Inputs

- User feedback, support tickets, incident post-mortems, and production metrics
- Current roadmap and outcomes

## Procedure

1. **Anchor.** Read the current roadmap and outcomes and, when an anchor ticket is given, the
   ticket, its scenarios, and its page first (G-22). Gather the feedback: user feedback,
   support tickets, incident post-mortems, and production metrics, noting the source and the
   period of each.
2. **Group by theme.** Sort every item into a theme by what the user was trying to do, not by
   who said it. Compute theme counts and metric movements with a tool and quote the result
   (G-02); do not eyeball a list and call it a trend.
3. **Separate signal from volume.** Rank the themes by their effect on the outcome, not by count
   alone. One report from a critical workflow can outrank twenty from a cosmetic one; say so
   explicitly on the analysis when you rank that way.
4. **Decide each theme.** Record one decision per theme: enhance, fix, stop, or wait, with a
   reason that names the outcome or metric it serves. A significant product decision, a stop or
   a change of roadmap direction in particular, is a decision record numbered next in the
   repository's sequence (G-41, O-18).
5. **Write the analysis.** Produce the product feedback analysis in the knowledge base, linked
   from the roadmap epic: themes with counts and sources, the decision and reason for each, and
   the metric movements as computed, written for a reader who was not in the session (G-24).
6. **Update the roadmap.** Create a ticket for every enhance and fix; close the ticket for every
   stop with the reason on it; record every wait with what would change it. Update the roadmap
   in the ticket system and the knowledge base to match.
7. **Close the loop.** Where feedback came from a ticket, comment on it with the decision and a
   link to the analysis. Update the anchor ticket with what was decided, the tickets created or
   closed, and what remains (G-12, G-26). Where a decision record was written into the
   repository, stage it and present the summary with a Conventional Commit message; commit only
   if the user asked for that commit (O-17, G-40). Then report.

## Artifacts

**Product feedback analysis** in the knowledge base, linked from the roadmap epic. Done when:

- Feedback is grouped by theme with counts and sources, not by who said it loudest
- Each theme has a decision: enhance, fix, stop, or wait, with a reason

**Roadmap update** in the ticket system and the knowledge base. Done when:

- Every "enhance" or "fix" decision has a ticket; every "stop" has a closed ticket with the reason

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-41** Write every significant decision, technical, product, or process, as a decision record the moment it is made: one screen, numbered next in the repository's sequence, dated, with context, options considered, decision, and consequences, linked from the anchor ticket. Never edit an accepted record; supersede it with a new one that links back.
- Count before you conclude. Compute theme frequencies and metric movements with a tool; do not eyeball a list and call it a trend.
- Separate signal from volume. One report from a critical workflow can outrank twenty from a cosmetic one; say so explicitly when you rank that way.
- Close the loop. Where feedback came from a ticket, comment on it with the decision.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
