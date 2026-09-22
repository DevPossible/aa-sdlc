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
- **G-35** Start every requirement from written goals: the outcome, then the scenarios. When a screenshot or mock-up arrives first, treat it as evidence of what someone wants: write the goals and scenarios it implies, record what it does not show as questions on the ticket, get them confirmed, and only then produce a mock-up from them.
- Write it as Gherkin from the first pass. A requirement captured in prose has to be translated later and loses something each time; a draft scenario can be wrong in a way everyone can see.
- Ask the confirming question, not the leading one. "So when X happens you need Y?" invites agreement; "What happens when X?" invites the truth.
- Record what was not said. Silence on error cases, permissions, and edge conditions is a question, not an assumption.
- A picture is a witness, not a specification. When the request arrives as a screenshot or mock-up, write the goals and scenarios it implies, log what it does not show as questions, and let the mock-up be regenerated from the confirmed scenarios later (O-15).

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
