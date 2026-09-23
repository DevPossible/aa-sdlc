---
name: discover
description: "Capture what stakeholders need, as they say it and as they mean it. Produces the initial requirements as draft scenarios and a question log of everything not yet answered."
aa:
  discipline: business-analysis
  step: discover
  guidance_sets: [every-step, anchored-step, repository-write]
  guidance: [G-16, G-18, G-19, G-35]
  requires: [R-16, R-29]
---

# /aa-ba-discover

Capture what stakeholders need, as they say it and as they mean it. Produces the initial requirements as draft scenarios and a question log of everything not yet answered.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The anchor epic and its outcome
- Stakeholder input: a conversation, a transcript, a document, or a session with the user
- Existing system documentation and feature files
- Any screenshot or mock-up offered as the request, treated as evidence rather than as the requirement (O-15)

## Procedure

1. **Anchor.** Read the anchor epic and its outcome, its linked scenarios, and its knowledge
   base page (G-22). Read the existing feature files and system documentation for the area, so
   a need already stated is recognised rather than written twice.
2. **Take the input as it arrives.** A conversation, a transcript, a document, or a session with
   the user. If it arrives as a screenshot or mock-up, treat it as a witness, not a
   specification: write the goals and scenarios it implies and log what it does not show as
   questions (G-35, O-15). The mock-up is regenerated from the confirmed scenarios later.
3. **Write it as Gherkin from the first pass.** Capture each stated need as a draft scenario in
   a feature file in the features folder, tagged with the epic, with the business objectives
   and scope boundaries in the feature description and the knowledge base page named there
   (G-19, O-01). A need that is out of scope is recorded as an explicit non-requirement, not
   dropped.
4. **Ask the confirming question, not the leading one.** Where the input is ambiguous, ask
   "What happens when X?" rather than "So when X happens you need Y?", and record the answer as
   a scenario or as a question.
5. **Record what was not said.** Silence on error cases, permissions, and edge conditions is a
   question, not an assumption. Put every question in the question log on the anchor epic with
   its context and an owner (G-16).
6. **Check where the truth lives.** Every stated need is now a scenario or an explicit
   non-requirement in the features folder; nothing lives only in the ticket or the page. A
   requirement found only there is raised as a conflict, never absorbed (G-18).
7. **Update the epic and present the change.** Link the epic to the feature file and the page,
   and the page back (G-26). Update the epic with what was captured, the question log, and what
   remains (G-12). Stage the new and changed feature files and present the summary with a
   Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
   Then report.

## Artifacts

**Initial requirements** in the features folder, as draft scenarios tagged with the epic. Done when:

- Every stated need is a scenario or an explicit non-requirement
- Business objectives and scope boundaries appear in the feature description

**Question log** in the anchor epic, as open questions. Done when:

- Every unanswered question has context and an owner

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/repository-write.md`: What every step that changes files in the repository does: keep artifacts with the code, write Conventional Commit messages, one cohesive change per commit, stage and present rather than commit, and name the purpose of every change.

*For this step:*

- **G-16** State assumptions and unverified claims explicitly, and put unresolved questions on the anchor ticket.
- **G-18** Change a requirement in its feature file first, then let the tooling update the ticket and the knowledge base page. Never edit a requirement in the ticket or the page alone; if you find one edited there, raise it as a conflict.
- **G-19** Tag every scenario with its anchor ticket, and name the feature's knowledge base page in the feature description.
- **G-35** Start every requirement from written goals: the outcome, then the scenarios. When a screenshot or mock-up arrives first, treat it as evidence of what someone wants: write the goals and scenarios it implies, record what it does not show as questions on the ticket, get them confirmed, and only then produce a mock-up from them.
- Write it as Gherkin from the first pass. A requirement captured in prose has to be translated later and loses something each time; a draft scenario can be wrong in a way everyone can see.
- Ask the confirming question, not the leading one. "So when X happens you need Y?" invites agreement; "What happens when X?" invites the truth.
- Record what was not said. Silence on error cases, permissions, and edge conditions is a question, not an assumption.
- A picture is a witness, not a specification. When the request arrives as a screenshot or mock-up, write the goals and scenarios it implies, log what it does not show as questions, and let the mock-up be regenerated from the confirmed scenarios later (O-15).

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
