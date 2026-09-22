---
name: respond-incident
description: "Coordinate an active incident: keep a timeline, contain the impact, pull in Operations, Development, or Release Management as needed, communicate status, and close the incident when service is restored."
aa:
  discipline: support
  step: respond-incident
  guidance_sets: [every-step, anchored-step]
  guidance: [G-04, G-13, G-42]
  requires: [R-03, R-33]
---

# /aa-sup-respond-incident

Coordinate an active incident: keep a timeline, contain the impact, pull in Operations, Development, or Release Management as needed, communicate status, and close the incident when service is restored.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The incident ticket with severity and current impact
- Dashboards and alerts from observability
- Runbooks and the rollback option

## Procedure

1. **Anchor.** Read the incident ticket: severity, current impact, what is already known, and
   any timeline started; then its linked scenarios and page (G-22). If there is no incident
   ticket, create one in the configured project before anything else (G-27); the timeline has
   to live somewhere from the first minute. Open the dashboards and alerts for the affected
   system, and the runbooks and rollback option for the last release.
2. **Start the timeline now, on the ticket.** Record the time of detection, the first
   observation, and every action and observation after it as it happens, with a timestamp read
   from a clock, not from memory; a timeline reconstructed afterwards is fiction with
   timestamps. Every communication sent is recorded with its audience.
3. **Contain first, diagnose second.** Choose the fastest reversible containment the runbooks
   and rollback option allow: roll back the last release, turn the feature off, scale, or
   reroute, before looking for the cause. A rollback, a change to production, or an external
   message is an irreversible action: stop and ask before doing it unless the user granted it
   in advance (G-13), and record the ask and the answer on the timeline.
4. **Communicate at a stated cadence.** Post the first status as soon as the incident is
   confirmed and say when the next one will come; each update says what is known, what is not,
   what is being done, and who is affected. Silence is the worst status update; "no change"
   sent on time is still a status.
5. **Run the steps the incident needs, anchored on this ticket:** Operations for infrastructure
   and observability, Development for a fix, Release Management for a rollback or a hotfix
   release. Every change made during the incident names the incident ticket where the change
   lives: the branch, the commit footer, the merge request (G-42, O-19); nothing is changed
   without saying what for.
6. **Verify service is restored with evidence.** Confirm it from the dashboards, the alerts
   clearing, and where possible the broken scenario now passing, and quote what was seen (G-04,
   T-07); "it looks fine" is not restoration. Record the time of restoration on the timeline
   and compute the elapsed time from detection with a tool (G-02).
7. **Close the incident** on the ticket: the mitigation applied, linked to any rollback or
   change, the evidence of restoration, and a post-incident review scheduled with a date or a
   ticket and linked from the incident. Anything still degraded or worked around becomes a
   ticket, not a footnote.
8. **Update the ticket** with the completed timeline, the communications sent, and what remains
   (G-12). Any change staged during the incident is presented with its message; commit only if
   the user asked for that commit (O-17, G-40). Then report.

## Artifacts

**Incident timeline** in the incident ticket. Done when:

- Every action and observation is timestamped as it happens
- Communications sent are recorded with their audience

**Mitigation** in the incident ticket, with links to any rollback or change. Done when:

- Service is restored, verified with evidence, and the ticket says how
- A post-incident review is scheduled

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

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-42** Before making a change, name what it is for: the ticket, the scenario it satisfies, or the decision record or page that explains it, and put that reference where the change lives: the branch, the commit footer, the merge request, and the artifact. A change that cannot name its purpose is a ticket to create first or work not to do; in review, a hunk that traces to nothing is a finding.
- Contain first, diagnose second. Rollback, feature flag, or scale before root cause.
- Write the timeline as you go. A timeline reconstructed afterwards is fiction with timestamps.
- Say what you know and what you do not, at a stated cadence. Silence during an incident is the worst status update.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
