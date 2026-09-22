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

*From the `code-change` set:* What every step that changes code, configuration, or infrastructure does, on top of repository-write: format changed files, prove with the build and tests, plan before a multi-step change, reference the ticket, commit everything needed to build and operate, let the tools decide style, change dependencies through the package manager.

- **G-01** Always format the code for the changed files before committing, but do not format files that were not changed.
- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-08** Before any multi-step change, write the plan and get it confirmed; one concern per commit and one ticket per branch is G-39.
- **G-09** Reference the anchor ticket in the branch name and every commit message.
- **G-11** Every artifact that belongs with the code goes into the same change set as the code, staged for the commit the user makes (G-40). Nothing that matters is left only on a local disk or in a conversation.
- **G-33** Write every commit message in Conventional Commits form: a type from the project's list, an optional scope, an imperative subject, a body that says why, and a footer carrying the ticket reference and any breaking change. One concern per commit (G-39); if you cannot name the type, split the commit.
- **G-37** Commit everything needed to build, deploy, and operate the software with the change that needs it: configuration templates, migrations, scripts, pipeline, infrastructure, container, and alert definitions, runbooks, and the development environment configuration. If a fresh clone plus the documented secrets could not build, deploy, and run the system after your change, something is missing from the repository; find it and commit it.
- **G-39** Make each commit one understandable change: one concern per commit, one ticket per branch, a subject that says what and a body that says why, small enough to review in one sitting. If the subject needs "and" or the diff needs a tour, split it.
- **G-40** Never commit unless the user asked for that commit. Stage the change, write the message, present the staged diff summary and the message, and stop; a request to implement, fix, finish, or run a step is not a request to commit, and the commit is made under the user's identity with no agent attribution.
- **G-42** Before making a change, name what it is for: the ticket, the scenario it satisfies, or the decision record or page that explains it, and put that reference where the change lives: the branch, the commit footer, the merge request, and the artifact. A change that cannot name its purpose is a ticket to create first or work not to do; in review, a hunk that traces to nothing is a finding.
- **G-44** Let the tools decide style: conventions live as formatter and linter configuration in the repository, the formatter runs on changed files and the linter runs from the root build before a change is presented, and every finding is fixed or suppressed with a reason beside it. Never argue style in review; where a language has no known linter, record that once in the development environment configuration and expect the health warning.
- **G-45** Change dependencies only through the ecosystem's package manager: add, update, and remove with its commands so it resolves conflicts, surfaces warnings, and updates transitive dependencies and the lock file together, and stage the manifest and lock file changes as their own commit (G-39). Never edit a version in a manifest or lock file by hand; if the tool refuses, record the refusal on the ticket and resolve it, never bypass it.

*For this step:*

- Alert on what users feel, not on what machines do. Latency and error rate at the edge before CPU in the middle.
- Every alert has a runbook or it is noise. Write the runbook before enabling the alert.
- Observability is a requirement on the code. If a scenario cannot be observed in production, raise a ticket for the signal.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
