---
name: plan-work
description: "Turn an epic and its feature files into stories and tasks in the ticket system, each small enough to finish in one iteration, each linked to the scenarios it delivers."
aa:
  discipline: refinement
  step: plan-work
  guidance_sets: [every-step, anchored-step]
  guidance: [G-18, G-19, G-28]
  requires: [R-16, R-23]
---

# /aa-rf-plan-work

Turn an epic and its feature files into stories and tasks in the ticket system, each small enough to finish in one iteration, each linked to the scenarios it delivers.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The anchor epic, its outcome, and its feature files
- The architecture and technical constraints
- Priority from Product Management

## Procedure

1. **Anchor.** Read the epic, its outcome, its feature files, and its knowledge base page (G-22),
   then the architecture, the technical constraints, and the priority Product Management
   recorded. Work only in the configured ticket project; a dependency on a ticket elsewhere is
   linked, never anchored on (G-27).
2. **List every scenario in the epic's feature files,** read from the repository rather than
   from the epic's summary of them. This list is the whole of the work: a story that delivers no
   scenario on it, and a scenario that reaches no story, are both defects to fix before the step
   finishes.
3. **Split by scenario, not by layer.** Group scenarios into stories so that each story delivers
   one or more scenarios end to end and can be tested on its own; a "backend story" and a
   "frontend story" cannot be until both are done. Each story can be finished in one iteration
   by one person or agent; one that cannot is split again along scenario lines.
4. **Do not invent requirements while splitting.** A scenario that is missing, ambiguous, or
   contradicted by the architecture is a question on the epic for Business Analysis, not a
   guess in a story (G-16). A requirement changes in its feature file first, never in a ticket
   alone; one found edited only there is raised as a conflict (G-18).
5. **Create the stories** as children of the epic, in priority order. Each carries the epic's
   outcome in its description and links to exactly the scenarios it delivers, and each scenario
   is tagged with its story's ticket (G-19, G-26). A story that cannot say which outcome it
   serves is mis-filed or unnecessary.
6. **Record dependencies as links.** Where one story needs another first, record it as a link
   between the tickets, not as prose in a description, so the order can be read by the tooling
   and by whoever plans the iteration.
7. **Size only from thinking.** Where a story is sized, first write on it what changes, what is
   unknown, and what could go wrong, and cite that reasoning from the size (G-28, O-10). A
   number wanted before that thinking exists is a labelled range, not a recorded size.
8. **Update the epic and present the change.** Record on the epic the stories created, which
   scenarios each covers, the questions raised, and what remains (G-12). If feature files gained
   ticket tags, stage them with a Conventional Commit message naming the epic (G-33), present
   the staged diff and the message, and stop; commit only if the user asked for that commit
   (O-17, G-40).

## Artifacts

**Stories and tasks** in the ticket system, as children of the epic. Done when:

- Every scenario in the epic's feature files is linked to exactly one story
- Every story can be finished in one iteration by one person or agent
- Dependencies between stories are recorded as links, not prose

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

- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-19** Tag every scenario with its anchor ticket, and name the feature's knowledge base page in the feature description.
- **G-28** Before recording a size, write on the ticket how the work will be built (what changes, what is unknown, what could go wrong) at a depth that matches the stakes, and cite that reasoning from the size. If a number is needed before that thinking exists, give a range labelled as a guess, do not record it as the size, and never commit an iteration on it.
- Split by scenario, not by layer. A story that delivers one scenario end to end can be tested; a "backend story" and a "frontend story" cannot until both are done.
- Keep the epic's outcome on every story. A story that cannot say which outcome it serves is either mis-filed or unnecessary.
- Do not invent requirements while splitting. A gap found here goes back to Business Analysis as a question, not forward as a guess.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
