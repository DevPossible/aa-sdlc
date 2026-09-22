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
