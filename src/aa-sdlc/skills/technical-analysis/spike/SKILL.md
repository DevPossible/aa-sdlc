---
name: spike
description: "Resolve a technical unknown with a time-boxed investigation that produces an answer, not a product. Throwaway code is expected; the finding is the artifact."
aa:
  discipline: technical-analysis
  step: spike
  guidance_sets: [every-step, anchored-step, repository-write]
  guidance: [G-04, G-23, G-41]
  requires: [R-32]
---

# /aa-ta-spike

Resolve a technical unknown with a time-boxed investigation that produces an answer, not a product. Throwaway code is expected; the finding is the artifact.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The question the spike must answer, stated on the ticket
- The time box

## Procedure

1. **Anchor.** Read the ticket, its linked scenarios, and its knowledge base page (G-22). Confirm
   the question the spike must answer is on the ticket in one sentence, with what a yes and a
   no would each change; if it is not, write it and get it confirmed before any code. Confirm
   the time box is on the ticket too, and state it before starting (G-23).
2. **Say how you will know.** Write on the ticket what evidence would answer the question: a
   measurement, a working call, a case that fails. A spike that cannot say what it is looking
   for cannot stop.
3. **Investigate on a throwaway branch.** Spike code lives on a branch named for the ticket and
   marked as spike code in the branch name and at the top of each file, and it is never merged
   to the main branch. Write only what the question needs; skip the tests, style, and structure
   the answer does not depend on.
4. **Stop at the time box.** When it is reached, stop whatever the state and report what you
   have. An unanswered question with evidence is more useful than a late answer.
5. **Record the finding on the ticket.** The answer, or why it could not be answered and what
   would answer it; what was tried, what was learned, the evidence with the actual output quoted
   rather than described (G-04, T-07); and what to do next. Written for a reader who was not
   there (G-24).
6. **Record a decision if the finding made one** (G-41). A spike that settles a choice produces
   a decision record, numbered next in the sequence, dated, with the options the spike
   compared, linked from the ticket (O-18). If the spike code looks good enough to keep, that
   is a decision to record and a ticket to implement it properly; it never becomes the
   implementation by accident.
7. **Update the ticket and present the branch.** Record on the ticket what was done, the
   finding, the decision record if any, and what remains (G-12). Stage the spike code on its
   branch with a Conventional Commit message that names the ticket and says it is spike code
   (G-33), present the staged diff and the message, and stop; commit only if the user asked for
   that commit (O-17, G-40).

## Artifacts

**Spike finding** in the anchor ticket, with a decision record if the finding decides something. Done when:

- Answers the stated question, or states why it could not and what would
- Names what was tried, what was learned, and what to do next
- Spike code is clearly marked as not for production and is not merged to the main branch

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

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-23** State a time box for any open-ended investigation before starting it, stop when it is reached, and report what was found either way.
- **G-41** Write every significant decision, technical, product, or process, as a decision record the moment it is made: one screen, numbered next in the repository's sequence, dated, with context, options considered, decision, and consequences, linked from the anchor ticket. Never edit an accepted record; supersede it with a new one that links back.
- Write the question before the code. A spike without a question becomes a prototype without a purpose.
- Stop at the time box. Report what you have; an unanswered question with evidence is more useful than a late answer.
- Never let spike code become the implementation by accident. If it is good enough to keep, that is a decision to record and a ticket to implement properly.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
