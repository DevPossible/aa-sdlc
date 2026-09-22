---
name: threat-model
description: "Work through what could go wrong with the architecture from an attacker's view, decide which threats matter, and turn each mitigation into a security requirement as a scenario and a ticket."
aa:
  discipline: security
  step: threat-model
  guidance_sets: [every-step, anchored-step, repository-write]
  guidance: [G-16, G-18, G-19, G-41]
  requires: [R-03, R-16, R-32]
---

# /aa-sec-threat-model

Work through what could go wrong with the architecture from an attacker's view, decide which threats matter, and turn each mitigation into a security requirement as a scenario and a ticket.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The system architecture and technology stack document
- The feature files, for data flows and trust boundaries
- Organisational security standards from the enterprise scope, if any

## Procedure

1. **Anchor.** Read the epic and its knowledge base page, the system architecture, the technology
   stack document, and the feature files (G-22), and note any organisational security standards
   in scope. Where the architecture does not show a boundary or a data flow that the scenarios
   imply, record the gap as a question on the epic (G-16) and model what is known.
2. **Follow the data.** List the assets worth protecting, starting from what is valuable, and
   trace how each moves through the architecture: every trust boundary it crosses, every store
   it rests in, every integration it passes through. This list is what the model must cover; a
   boundary not on it is a boundary not considered.
3. **Enumerate the threats at each boundary.** For every boundary and flow, work through what an
   attacker could do: impersonate, tamper, disclose, deny service, escalate, repudiate. Record
   each threat against the boundary it applies to, in language a reader outside this session
   can follow (G-24).
4. **Rate and decide.** Every threat gets a rating from impact and likelihood and one decision:
   mitigate, accept, or transfer, with the reason. An accepted risk names its owner; an
   unmentioned risk is a surprise. Each decision that sets the system's security posture is a
   decision record, numbered next in the sequence and dated (O-18, G-41).
5. **Write the threat model** in the knowledge base: assets, boundaries and flows, threats with
   their rating and decision, and the decision records it cites. Link it from the epic and link
   back (G-26).
6. **Turn every mitigation into a scenario.** Write each as a testable scenario in the features
   folder: a given, a hostile action, and an observable outcome such as a rejected request and a
   logged event. "Validate input" is not a requirement. Tag each scenario with its ticket and
   name the knowledge base page in the feature description (G-19); the feature file changes
   first and the tooling carries it to the ticket and the page (G-18).
7. **Raise a ticket for each mitigation** in the configured ticket project, as a child of the
   epic, linked to its scenario (G-27, G-26). Each is something a person or an agent can build
   and a test can verify.
8. **Update the epic and present the change.** Record on the epic what was produced, the tickets
   raised, the risks accepted, and what remains (G-12). Stage the new feature files and any
   decision records that live in the repository, write a Conventional Commit message naming the
   epic (G-33), present the staged diff and the message, and stop; commit only if the user asked
   for that commit (O-17, G-40).

## Artifacts

**Threat model** in the knowledge base, linked from the epic. Done when:

- Every trust boundary and data flow in the architecture is considered
- Every threat is rated and has a decision: mitigate, accept, or transfer, with a reason

**Security requirements** in the features folder as scenarios, and the backlog as tickets. Done when:

- Every mitigation is a scenario a test can verify and a ticket someone can build

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
- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-19** Tag every scenario with its anchor ticket, and name the feature's knowledge base page in the feature description.
- **G-41** Write every significant decision, technical, product, or process, as a decision record the moment it is made: one screen, numbered next in the repository's sequence, dated, with context, options considered, decision, and consequences, linked from the anchor ticket. Never edit an accepted record; supersede it with a new one that links back.
- Follow the data. Start from what is valuable and trace how it moves; threats appear at every boundary it crosses.
- Accept explicitly. An accepted risk with a named owner and a reason is a decision; an unmentioned risk is a surprise.
- Make mitigations testable. "Validate input" is not a requirement; "Given a payload over the size limit, then the request is rejected with a logged event" is.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
