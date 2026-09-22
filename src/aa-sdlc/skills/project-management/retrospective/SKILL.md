---
name: retrospective
description: "Look at what actually happened in an iteration, release, or quarter, using the record rather than recollection, and turn it into a small number of concrete improvements with owners and tickets."
aa:
  discipline: project-management
  step: retrospective
  guidance_sets: [every-step, anchored-step]
  guidance: [G-41]
  requires: [R-03, R-32]
---

# /aa-pm-retrospective

Look at what actually happened in an iteration, release, or quarter, using the record rather than recollection, and turn it into a small number of concrete improvements with owners and tickets.

## Anchor

A ticket is optional here. When one is given, read it, its linked scenarios, and its page first (G-22) and write the outcome back to it; when none is, produce the artifacts locally and say so.

## Inputs

- Ticket system history: cycle times, carry-over, blockers, reopened tickets
- Incident and post-mortem records for the period
- Input from the people involved, where the user provides it

## Procedure

1. **Anchor.** With a ticket (the iteration, release, or a retrospective ticket), read it, its
   linked scenarios, and its page first (G-22) and write the outcome back to it; without one,
   take the period from the user, write the report locally, and say so. Read the previous
   retrospective's report and its improvement tickets.
2. **Check the last retrospective's changes first.** For each improvement ticket it raised, read
   its state and whether its measure of success was met. Any that was not done is the first
   finding of this retrospective, recorded before anything new.
3. **Measure the period from the record.** Compute with a tool, from the ticket system history:
   tickets committed and completed, carry-over, cycle times, reopened tickets, time blocked, and
   the incidents and post-incident reviews in the period (G-02). Quote each figure with the
   query behind it; these are the numbers the discussion starts from.
4. **Then ask.** Take the input from the people involved, where the user provides it, and record
   it after the numbers, marked as what people felt and kept distinct from what the data shows.
   Where the two disagree, the disagreement is itself a finding, not something to reconcile
   silently.
5. **Choose three to keep and three to change.** Name the top three things to keep and the top
   three to change, each with the evidence that put it on the list. Three changes, not thirty;
   anything else worth saying goes in the report as an observation, not an action.
6. **Record each change as a decision record** (O-18, G-41): one screen, numbered next in the
   repository's sequence, dated, with the context, the options considered, the decision, and
   its consequences, linked from the anchor ticket. A change that reverses an earlier record
   supersedes it with a link back; the old record is not edited.
7. **Raise the improvement tickets** in the configured ticket project (G-27), one per change,
   each with an owner, a link to its decision record, and a way to tell whether it worked that
   the next retrospective can check. The owner is whoever will do it, which may be the person
   running this step (T-13).
8. **Write the workflow health report** in the knowledge base: what the data shows, then what
   people felt, the three keeps and three changes, and links to the decision records and the
   tickets, for a reader who was not there (G-24, G-26).
9. **Update the ticket** with the report, the records, and the tickets raised (G-12). If the
   decision records or the report live in the documents folder, stage them and present the
   change set; commit only if the user asked for that commit (O-17, G-40). Then report.

## Artifacts

**Workflow health report** in the knowledge base. Done when:

- States what the data shows before what people felt, and distinguishes the two
- Names the top three things to keep and the top three to change

**Process improvement backlog** in the ticket system. Done when:

- Every "change" is a ticket with an owner and a way to tell whether it worked

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
- Measure first, then ask. Present the numbers before opinions so the discussion is about causes, not impressions.
- Three changes, not thirty. An improvement backlog nobody works is a complaint log.
- Check the last retrospective's changes first. If they were not done, that is the first finding.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
