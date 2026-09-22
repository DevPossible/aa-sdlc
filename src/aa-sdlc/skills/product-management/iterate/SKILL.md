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

*From the `every-step` set:* What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.

- **G-02** Perform any arithmetic, date calculation, counting, or unit conversion by executing code or a tool, and report the executed result, never an estimate.
- **G-03** Read the current contents of a file, ticket, or document immediately before modifying it; never edit from memory of an earlier read.
- **G-06** Never suppress a failing test, warning, or error to make a step pass. Fix the cause, or record the unresolved problem on the anchor ticket.
- **G-15** Report outcomes exactly: failures with their output, skipped steps as skipped, partial work as partial.
- **G-24** Write every artifact for a reader with no context: someone who was not in this session and may never have seen the project. If it needs the conversation to make sense, it is not finished (T-13).

*From the `anchored-step` set:* What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

- **G-12** End every step by updating the anchor ticket with what was done, what was produced, and what remains.
- **G-22** Anchor first. Before doing anything, read the anchor ticket, its linked scenarios, and its knowledge base page. If there is no ticket and the step needs one, create it or ask; never work from the conversation alone.
- **G-25** Produce each artifact in the location the workflow names for it, with the name it gives. Never invent a new location or a variant name; if the named location is wrong for this project, change the project config, not the artifact (T-08).
- **G-26** Link in both directions. Every artifact links to its anchor ticket, and the ticket links back to the artifact; a feature links to its page and the page to the feature.
- **G-27** Create and anchor tickets only in the repository's one configured ticket project. If the work touches a ticket in another project, create or use a ticket in this project and link the two; never anchor a step on a ticket outside the configured project.

*For this step:*

- **G-41** Write every significant decision, technical, product, or process, as a decision record the moment it is made: one screen, numbered next in the repository's sequence, dated, with context, options considered, decision, and consequences, linked from the anchor ticket. Never edit an accepted record; supersede it with a new one that links back.
- Count before you conclude. Compute theme frequencies and metric movements with a tool; do not eyeball a list and call it a trend.
- Separate signal from volume. One report from a critical workflow can outrank twenty from a cosmetic one; say so explicitly when you rank that way.
- Close the loop. Where feedback came from a ticket, comment on it with the decision.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
