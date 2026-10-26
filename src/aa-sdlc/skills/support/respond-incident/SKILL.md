---
name: respond-incident
description: "Coordinate an active incident: keep a timeline, contain the impact, pull in Operations, Development, or Release Management as needed, communicate status, and close the incident when service is restored."
aa:
  discipline: support
  step: respond-incident
  guidance_sets: [every-step, anchored-step]
  guidance: [G-04, G-13, G-42]
  requires: [R-33]
---

# /aa-sup-respond-incident

Coordinate an active incident: keep a timeline, contain the impact, pull in Operations, Development, or Release Management as needed, communicate status, and close the incident when service is restored.

## Anchor

Anchor first (G-22). Read the ticket, linked scenarios and knowledge page; check requirement currency under G-54. Pull instructions below apply only when the snapshot changed or currency is unknown. If no ticket system is reachable, record the anchor and artifacts locally, say so, and continue (T-05, T-10).

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
   (G-12). Any change staged during the incident is presented with its message; honor existing explicit task commit authorization (O-17, G-40). Then report.

## Artifacts

**Incident timeline** in the incident ticket. Done when:

- Every action and observation is timestamped as it happens
- Communications sent are recorded with their audience

**Mitigation** in the incident ticket, with links to any rollback or change. Done when:

- Service is restored, verified with evidence, and the ticket says how
- A post-incident review is scheduled

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first and check requirement currency, update the ticket at meaningful checkpoints, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-04** During development run focused checks; before review run the affected build, lint and relevant test tiers, retaining actual output and declaring the scope. At actual branch finish run full build, lint, provenance and every test tier; at release satisfy the release checks. Instruction-only changes use the framework's applicable structural validation rather than claiming product behavior.
- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-42** Before making a change, name what it is for: the ticket, the scenario it satisfies, or the decision record or page that explains it, and put that reference where the change lives: the branch, the commit footer, the merge request, and the artifact. A change that cannot name its purpose is a ticket to create first or work not to do; in review, a hunk that traces to nothing is a finding.
- Contain first, diagnose second. Rollback, feature flag, or scale before root cause.
- Write the timeline as you go. A timeline reconstructed afterwards is fiction with timestamps.
- Say what you know and what you do not, at a stated cadence. Silence during an incident is the worst status update.

## Report

State what was produced and where, link actual run output and summarize its scope and results, name failures/skips and what remains (G-15). Update the anchor at the meaningful milestone (G-12), referencing one proportionate evidence record instead of repacking unchanged proof. Stage only task-owned changes; honor existing explicit task commit authorization, otherwise present the diff and Conventional Commit message without committing (G-40).
