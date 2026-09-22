---
name: triage
description: "Take an incoming incident, defect report, or request and turn it into a ticket with the right type, severity, priority, and owner, or link it to the existing ticket it duplicates."
aa:
  discipline: support
  step: triage
  guidance_sets: [every-step, anchored-step]
  guidance: [G-16]
---

# /aa-sup-triage

Take an incoming incident, defect report, or request and turn it into a ticket with the right type, severity, priority, and owner, or link it to the existing ticket it duplicates.

## Anchor

A ticket is optional here. When one is given, read it, its linked scenarios, and its page first (G-22) and write the outcome back to it; when none is, produce the artifacts locally and say so.

## Inputs

- The incoming report from whatever channel the project uses
- Existing open tickets and known issues
- The project's severity and priority definitions

## Procedure

1. **Anchor.** With a ticket (a report already raised), read it, its linked scenarios, and its
   page first (G-22) and write the triage back to it; without one, read the incoming report from
   whatever channel the project uses, and the ticket this step creates in the configured ticket
   project is the anchor (G-27). If no ticket system is in scope, write the triaged record
   locally and say so. Read the project's severity and priority definitions before judging
   either.
2. **Search for duplicates by symptom**, not by the reporter's title: the error text, the
   affected component, the environment, the behaviour, across open tickets and known issues.
   Record which searches were run and what they returned. If the report duplicates an existing
   ticket, link it there, add anything new the report says, and stop; no second ticket is
   created.
3. **Check it has enough to act on**: environment, steps to reproduce, expected, actual, and
   impact. Whatever is missing is asked for once, precisely, as questions on the ticket returned
   to the reporter (G-16); the ticket is not marked triaged while a question that blocks
   reproduction is open.
4. **Set the type** per the project's definitions: incident, defect, or request. The type says
   which step picks it up next: respond-incident, fix-bug, or refine-ticket.
5. **Set severity from impact**, per the project's definitions: which scenario is broken, for
   whom, whether there is a workaround, with the evidence written beside it. A loud reporter
   does not set it; where the impact cannot be verified, the severity is recorded as an
   assumption (G-16).
6. **Set priority as order** relative to the other open tickets, per the project's definitions,
   with one sentence saying why. Priority is not severity restated; a low-severity defect in the
   scenario being released this week may outrank a high-severity one nobody can reach.
7. **Assign an owner** who will act next, which may be the person running this step (T-13), and
   link the ticket to the scenario it violates, the incident it belongs to, or the release it
   arrived with, where those exist (G-26). If the report belongs to a ticket in another project,
   create or use one in this project and link the two (G-27, O-09).
8. **Update the ticket** with the type, severity, priority, owner, the duplicate search and its
   result, and any open questions (G-12). If the record was written locally because no ticket
   system was in scope, stage it and present it; commit only if the user asked for that commit
   (O-17, G-40). Then report.

## Artifacts

**Triaged ticket** in the ticket system. Done when:

- Has a type, severity, priority, and owner, each per the project's definitions
- Has enough to act on: environment, steps, expected, actual, impact
- Duplicates are linked, not created

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

- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- Severity is impact, priority is order. Do not let a loud reporter set either.
- Ask for what is missing once, precisely. A ticket that cannot be reproduced from its content goes back with the exact questions.
- Check for duplicates before creating. Search by symptom, not by the reporter's title.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
