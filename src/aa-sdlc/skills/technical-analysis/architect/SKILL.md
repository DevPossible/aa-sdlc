---
name: architect
description: "Decide the shape of the system for an epic or initiative: components, boundaries, integrations, data, and the technology stack, each with the reason. Produces the architecture and the decision records that back it."
aa:
  discipline: technical-analysis
  step: architect
  guidance_sets: [every-step, anchored-step, repository-write]
  guidance: [G-16, G-23, G-41, G-43]
  requires: [R-03, R-06, R-32, R-34]
---

# /aa-ta-architect

Decide the shape of the system for an epic or initiative: components, boundaries, integrations, data, and the technology stack, each with the reason. Produces the architecture and the decision records that back it.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The feature files and technical constraints document
- The existing architecture and decision records
- Organisational standards from the enterprise or team scope

## Procedure

1. **Anchor.** Read the epic, its feature files, the technical constraints document, the existing
   architecture and decision records, and any organisational standards in scope (G-22). Where
   the feature files are thin or contradict each other, write the questions on the epic (G-16)
   rather than architecting around a guess.
2. **Trace the scenarios.** List every scenario and what it needs: the data it creates or reads,
   the boundaries it crosses, the integrations it touches. This list is what the architecture
   must satisfy, and nothing more (O-20).
3. **State a time box for anything unknown** before investigating it (G-23). An unknown that
   survives the box goes to a spike on its own ticket; the architecture records the assumption
   it makes meanwhile, labelled as such (G-16).
4. **Decide the fewest things that let work start.** Components and their responsibilities,
   every integration boundary, the data each component owns, and the technology stack. Each
   component, boundary, and extension point names the scenario that requires it or the
   decision record that justifies it; anything that names neither comes out (O-20, G-43).
   Constrain, do not prescribe: say what a component must guarantee, not how its code must
   look; the how belongs to Implementation Planning and the stack.
5. **Write a decision record for each significant choice** (G-41). Numbered next in the
   repository sequence, dated, one screen, with context, the options considered including the
   ones rejected, the decision, and its consequences. A choice that changes an accepted record
   is a new record that supersedes it and links back; the old one is never edited (O-18).
6. **Write the system architecture** in the documents folder: components, responsibilities,
   integration boundaries, and the scenario-to-component trace from step 2, for a reader who
   was not in this session (G-24). Link it from the knowledge base page and the epic, and link
   back from it (G-26).
7. **Write the technology stack document** in the knowledge base. Every technology choice cites
   its decision record, and the constraints the stack imposes on Development and Operations are
   listed explicitly so later steps can check against them rather than infer them.
8. **Update the epic and present the change.** Record on the epic what was produced, where, and
   what remains open (G-12). Stage the architecture and any decision records that live in the
   repository, write a Conventional Commit message naming the epic (G-33), present the staged
   diff and the message, and stop; commit only if the user asked for that commit (O-17, G-40).

## Artifacts

**System architecture** in the documents folder, linked from the knowledge base page and the epic. Done when:

- Shows components, their responsibilities, and every integration boundary
- Every scenario can be traced to the components that satisfy it
- Every component, boundary, and extension point names the scenario that requires it or the decision record that justifies it (O-20)

**Technology stack document** in the knowledge base. Done when:

- Every technology choice has a decision record
- Constraints imposed on Development and Operations are explicit

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/repository-write.md`: What every step that changes files in the repository does: keep artifacts with the code, write Conventional Commit messages, one cohesive change per commit, stage and present rather than commit, and name the purpose of every change.

*For this step:*

- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-23** State a time box for any open-ended investigation before starting it, stop when it is reached, and report what was found either way.
- **G-41** Write every significant decision, technical, product, or process, as a decision record the moment it is made: one screen, numbered next in the repository's sequence, dated, with context, options considered, decision, and consequences, linked from the anchor ticket. Never edit an accepted record; supersede it with a new one that links back.
- **G-43** Design for the scenarios that exist, not the ones you expect: choose the simplest structure that satisfies them, and add an abstraction, extension point, configuration option, or feature only when a scenario requires it or a decision record justifies it, naming which. In review, code or structure that serves no scenario is a finding, and so is a fourth copy of the same code where one named thing would do.
- Decide the fewest things that let work start. Every decision made before it is needed is a decision made with the least information.
- Name the alternatives you rejected. An architecture without rejected options is a preference, not a decision (G-41).
- Constrain, do not prescribe. Say what a component must guarantee, not how its code must look; the how belongs to Implementation Planning and the stack.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
