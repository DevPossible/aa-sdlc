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

*From the `repository-write` set:* What every step that changes files in the repository does: keep artifacts with the code, write Conventional Commit messages, one cohesive change per commit, stage and present rather than commit, and name the purpose of every change.

- **G-11** Every artifact that belongs with the code goes into the same change set as the code, staged for the commit the user makes (G-40). Nothing that matters is left only on a local disk or in a conversation.
- **G-33** Write every commit message in Conventional Commits form: a type from the project's list, an optional scope, an imperative subject, a body that says why, and a footer carrying the ticket reference and any breaking change. One concern per commit (G-39); if you cannot name the type, split the commit.
- **G-39** Make each commit one understandable change: one concern per commit, one ticket per branch, a subject that says what and a body that says why, small enough to review in one sitting. If the subject needs "and" or the diff needs a tour, split it.
- **G-40** Never commit unless the user asked for that commit. Stage the change, write the message, present the staged diff summary and the message, and stop; a request to implement, fix, finish, or run a step is not a request to commit, and the commit is made under the user's identity with no agent attribution.
- **G-42** Before making a change, name what it is for: the ticket, the scenario it satisfies, or the decision record or page that explains it, and put that reference where the change lives: the branch, the commit footer, the merge request, and the artifact. A change that cannot name its purpose is a ticket to create first or work not to do; in review, a hunk that traces to nothing is a finding.

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
