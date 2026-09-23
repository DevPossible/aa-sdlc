---
name: prototype
description: "Make the requirement visible before it is built. Produces mockups and, where the interaction matters, an interactive prototype that stakeholders can react to, and feeds what they say back into the scenarios."
aa:
  discipline: ux-design
  step: prototype
  guidance_sets: [every-step, anchored-step, repository-write]
  guidance: [G-13, G-18, G-35, G-36]
  requires: [R-16, R-29]
---

# /aa-ux-prototype

Make the requirement visible before it is built. Produces mockups and, where the interaction matters, an interactive prototype that stakeholders can react to, and feeds what they say back into the scenarios.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The confirmed scenarios for the ticket or epic; a mock-up is made from them, never before them (O-15)
- Existing design system or conventions in the project, if any
- The technical constraints document

## Procedure

1. **Anchor and check currency.** Read the anchor ticket, its linked scenarios, and its page
   (G-22). Compare the feature files at head with the revision the ticket records the scenarios
   were confirmed against (O-13); a scenario that changed since is noted on the ticket and the
   mock-up is made from the head. Read the project's design system or conventions where they
   exist, and the technical constraints document.
2. **Scenarios first, always.** If there are no confirmed scenarios behind the request, write or
   request them and stop here. If the request arrived as a screenshot or mock-up, write the
   goals and scenarios it implies, log what it does not show as questions on the ticket, and
   wait for confirmation before drawing (G-35, O-15).
3. **Mock up every scenario with a user interface.** For each, produce at least one mockup
   showing its When and its Then, in the documents folder or the design tool the project uses,
   and name on the mockup the scenarios it renders (G-36). Show the unhappy path: error and
   empty states get their own mockups rather than being invented at implementation time.
4. **Label the variations.** Where two designs answer a question, label each with the question
   it answers, so a stakeholder chooses between answers rather than between pictures.
5. **Prototype the flow where the interaction matters.** Build an interactive prototype that
   covers the primary flow end to end, unpolished, so a stakeholder can complete the scenario's
   When without help. Polish hides the question the prototype exists to ask.
6. **Check the mock-ups against the scenarios.** Behaviour a mockup shows that no scenario
   states is a question on the ticket, not a requirement (G-36). Where a stakeholder's reaction
   changes what the user needs, change the scenario in the feature file first, then the
   prototype (G-18, T-12).
7. **Link and present.** Link every mockup and the prototype from the ticket and the page, and
   back (G-26). Stop and ask before sending anything to an audience outside the project (G-13).
   Update the ticket with what was produced, the questions raised, and what remains (G-12).
   Stage the files added to the repository and present the summary with a Conventional Commit
   message; commit only if the user asked for that commit (O-17, G-40). Then report.

## Artifacts

**Mockups** in the documents folder or the design tool the project uses, linked from the ticket and page. Done when:

- Every scenario with a user interface has at least one mockup showing its When and Then
- Every mockup names the scenarios it renders (O-15)
- Variations are labelled with what question each answers

**Interactive prototype** in linked from the ticket. Done when:

- Covers the primary flow end to end; a stakeholder can complete the scenario's When without help

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/repository-write.md`: What every step that changes files in the repository does: keep artifacts with the code, write Conventional Commit messages, one cohesive change per commit, stage and present rather than commit, and name the purpose of every change.

*For this step:*

- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-35** Start every requirement from written goals: the outcome, then the scenarios. When a screenshot or mock-up arrives first, treat it as evidence of what someone wants: write the goals and scenarios it implies, record what it does not show as questions on the ticket, get them confirmed, and only then produce a mock-up from them.
- **G-36** Generate every mock-up from confirmed scenarios and name on it the scenarios it renders. Behaviour a mock-up shows that no scenario states is a question on the ticket, not a requirement; change the scenario first, then the mock-up (T-12).
- Prototype the flow, not the pixels. The question a prototype answers is "is this the right interaction", and polish hides that question.
- Scenarios first, always. If asked for a mock-up with no confirmed scenarios behind it, write or request them first; a mock-up that shows behaviour no scenario states is a question on the ticket, not a requirement (O-15).
- Show the unhappy path. A mockup that only shows success leaves the error states to be invented at implementation time.
- Feed changes back through the feature file. If the prototype review changes what the user needs, change the scenario, then the prototype (T-12).

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
