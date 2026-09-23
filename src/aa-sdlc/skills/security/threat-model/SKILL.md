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

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/repository-write.md`: What every step that changes files in the repository does: keep artifacts with the code, write Conventional Commit messages, one cohesive change per commit, stage and present rather than commit, and name the purpose of every change.

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
