---
name: plan-work
description: "Turn an epic and the scenarios on its feature pages into stories and tasks in the ticket system, each small enough to finish in one iteration, each linked to the page and the scenarios it delivers."
aa:
  discipline: refinement
  step: plan-work
  guidance_sets: [every-step, anchored-step]
  guidance: [G-18, G-19, G-28, G-52]
  requires: [R-16, R-23, R-41, R-43]
---

# /aa-rf-plan-work

Turn an epic and the scenarios on its feature pages into stories and tasks in the ticket system, each small enough to finish in one iteration, each linked to the page and the scenarios it delivers.

## Anchor

Anchor first (G-22). Read the anchor ticket and its knowledge base page, and pull the feature pages it links to into the features folder (G-54), before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The anchor epic, its outcome, and its feature pages in the knowledge base
- The architecture and technical constraints
- Priority from Product Management

## Procedure

1. **Anchor.** Read the epic, its outcome, and the feature pages it links to (G-22), then pull
   those pages (G-54): their Approved scenarios into the features folder as feature files with
   their provenance header, and the page versions recorded on the epic. With a documents-folder
   knowledge base run `scripts/aa-sdlc/Sync-FeatureFiles.ps1 -KnowledgeRoot <folder>
   -FeaturesRoot <features>`; with a knowledge base, read each page and convert it with
   `ConvertFrom-FeaturePage` from `scripts/aa-sdlc/AaFeatures.psm1`. Then read the architecture,
   the technical constraints, and the priority Product Management recorded. Work only in the
   configured ticket project, through its ticket filter, and change only pages under the
   project's knowledge root (G-55); a dependency on a ticket elsewhere is linked, never anchored
   on (G-27).
2. **List every Approved scenario on the epic's feature pages,** read from the pages rather than
   from the epic's summary of them. This list is the whole of the work: a story that delivers no
   scenario on it, and a scenario that reaches no story, are both defects to fix before the step
   finishes. A Draft scenario is not yet agreed; it is a question on the epic for Business
   Analysis, not a story.
3. **Split by scenario, not by layer.** Group scenarios into stories so that each story delivers
   one or more scenarios end to end and can be tested on its own; a "backend story" and a
   "frontend story" cannot be until both are done. Each story can be finished in one iteration
   by one person or agent; one that cannot is split again along scenario lines.
4. **Do not invent requirements while splitting.** A scenario that is missing, ambiguous, or
   contradicted by the architecture is a question on the epic for Business Analysis, not a
   guess in a story (G-16). A requirement changes on its feature page first, never in a ticket
   or a feature file alone; one found edited only there is raised as a conflict (G-18).
5. **Create the stories** from the scenarios on the pages, as children of the epic, in priority
   order. Each carries the epic's outcome in its description, links to the feature page it
   delivers from, and names exactly the scenario ids it delivers; each of those scenarios gets
   its story's ticket tag on its page (G-19, G-26). A story that cannot say which outcome it
   serves is mis-filed or unnecessary.
6. **Record dependencies as links.** Where one story needs another first, record it as a link
   between the tickets, not as prose in a description, so the order can be read by the tooling
   and by whoever plans the iteration.
7. **Size only from thinking.** Where a story is sized, first write on it what changes, what is
   unknown, and what could go wrong, and cite that reasoning from the size (G-28, O-10). A
   number wanted before that thinking exists is a labelled range, not a recorded size.
8. **Update the epic and present the change.** Record on the epic the stories created, which
   scenarios each covers, the questions raised, and what remains (G-12). Pull the pages again so
   the feature files carry the new ticket tags (G-54); never add a tag to a feature file by hand
   (G-18). Stage the feature files the pull changed, and the changed pages where they are in the
   documents folder, with a Conventional Commit message naming the epic (G-33), present the
   staged diff and the message, and stop; commit only if the user asked for that commit (O-17,
   G-40).

## Artifacts

**Stories and tasks** in the ticket system, as children of the epic. Done when:

- Every Approved scenario on the epic's feature pages is linked to exactly one story, which links to its page and names the scenario ids
- Every such scenario carries its story's ticket tag on its feature page (G-19)
- Every story can be finished in one iteration by one person or agent
- Dependencies between stories are recorded as links, not prose

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first and pull the feature pages it links to, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.

*For this step:*

- **G-18** Change a requirement on its feature page in the knowledge base, under the ticket that asks for it, then pull the page into the repository. Never edit a feature file by hand; a change found while building is converted to the page format and proposed on the page for its owner to approve.
- **G-19** Tag every Approved scenario on its feature page with the ticket that asked for it, and link the ticket to the page and the scenario ids.
- **G-28** Before recording a size, write on the ticket how the work will be built (what changes, what is unknown, what could go wrong) at a depth that matches the stakes, and cite that reasoning from the size. If a number is needed before that thinking exists, give a range labelled as a guess, do not record it as the size, and never commit an iteration on it.
- **G-52** Create every ticket as one of the five kinds, in the ticket system's name for it from the project config: an epic for an outcome, a story for one behaviour a user can observe with its scenarios, a task for a buildable piece of a story's plan, a bug for behaviour that contradicts a scenario, a spike for a time-boxed question; link each to its parent (task to story, story to epic).
- Split by scenario, not by layer. A story that delivers one scenario end to end can be tested; a "backend story" and a "frontend story" cannot until both are done.
- Keep the epic's outcome on every story. A story that cannot say which outcome it serves is either mis-filed or unnecessary.
- Do not invent requirements while splitting. A gap found here goes back to Business Analysis as a question, not forward as a guess.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
