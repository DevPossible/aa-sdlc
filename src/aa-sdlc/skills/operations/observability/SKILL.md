---
name: observability
description: "Make the running system visible: the dashboards, alerts, logs, and traces that show whether the scenarios are being met in production, and the requirements on the code to emit them."
aa:
  discipline: operations
  step: observability
  guidance_sets: [every-step, anchored-step, code-change]
  requires: [R-03]
---

# /aa-ops-observability

Make the running system visible: the dashboards, alerts, logs, and traces that show whether the scenarios are being met in production, and the requirements on the code to emit them.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The scenarios, for what "working" means
- The architecture, for where signals come from
- The project's observability tooling category

## Procedure

1. **Anchor and read what "working" means.** The ticket, its linked scenarios, and its page
   (G-22); the outcome metrics from define-outcome on the anchor epic; the architecture, for
   which component emits which signal; and the observability tooling category from the project
   config. Use the tool the project has chosen (T-01).
2. **Map every scenario to a signal.** For each scenario, write down how production would show
   it being met or missed: a metric, a log event, or a trace, and the component that emits it.
   Prefer what users feel, latency and error rate at the edge, over what machines do. Put the
   map on the ticket.
3. **Ticket the signals the code does not emit.** Where a scenario has no signal, raise a ticket
   for the code change that emits it, linked from this ticket (G-26). Observability is a
   requirement on the code, not something arranged around it; define no alert on a signal that
   does not exist yet.
4. **Build the dashboards** in the observability tool: the outcome metrics from define-outcome
   first, then the health of each component. Link each dashboard from the knowledge base page
   and the page from the dashboard (G-26).
5. **Write the runbook before enabling the alert.** For every alert, a runbook in the documents
   folder saying what the alert means, what to check, and what to do; an alert without one is
   noise and is not enabled.
6. **Define the alerts as code** in the repository where the tool allows; otherwise document
   each in the documents folder (O-16, G-37). Each alert has a runbook, an owner, and a
   threshold with the reason for that number. An alert nobody would act on is removed or not
   added, with the reason on the ticket.
7. **Prove the signals arrive.** Exercise the system or replay a known event, watch the
   dashboard show it and the expected alert fire, and quote what was observed (G-04). A signal
   that does not arrive is a finding on the ticket, not a threshold to loosen (G-06).
8. **Stage and present.** Stage the alert definitions, the runbooks, and any code changes as
   one change set with a Conventional Commit message; commit only if the user asked
   (O-17, G-40). Update the ticket with the dashboards, the alerts, the tickets raised, and
   what remains (G-12).

## Artifacts

**Monitoring dashboards** in the observability tool, linked from the knowledge base. Done when:

- Show the outcome metrics from define-outcome and the health of each component

**Alert configuration** in as code in the repository where the tool allows; otherwise documented in the documents folder (O-16). Done when:

- Every alert has a runbook, an owner, and a threshold with a reason
- No alert fires that nobody acts on

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/code-change.md`: What every step that changes code, configuration, or infrastructure does, on top of repository-write: format changed files, prove with the build and tests, plan before a multi-step change, reference the ticket, commit everything needed to build and operate, let the tools decide style, change dependencies through the package manager.

*For this step:*

- Alert on what users feel, not on what machines do. Latency and error rate at the edge before CPU in the middle.
- Every alert has a runbook or it is noise. Write the runbook before enabling the alert.
- Observability is a requirement on the code. If a scenario cannot be observed in production, raise a ticket for the signal.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
