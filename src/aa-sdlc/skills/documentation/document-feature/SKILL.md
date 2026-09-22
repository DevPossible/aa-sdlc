---
name: document-feature
description: "Write or update the user-facing and developer-facing documentation for a ticket, from its scenarios and its implementation, in the places the project keeps each kind."
aa:
  discipline: documentation
  step: document-feature
  guidance_sets: [every-step, anchored-step, repository-write]
  guidance: [G-37]
  requires: [R-03, R-06, R-16, R-30]
---

# /aa-doc-document-feature

Write or update the user-facing and developer-facing documentation for a ticket, from its scenarios and its implementation, in the places the project keeps each kind.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The ticket, its scenarios, and the merged change
- The project's documentation locations from the config or knowledge base

## Procedure

1. **Anchor and check currency.** Read the ticket, its scenarios, its knowledge base page, and
   the merged change. Confirm the change is at the head; if the ticket records a revision,
   compare it with the head for the linked feature files (O-13). If a scenario changed after
   the change merged, document what the feature file says now and put the difference on the
   ticket as a question (T-12).
2. **Find where each kind of documentation lives.** Take the locations from the project config
   or the knowledge base: developer documentation in the documents folder, user documentation
   in the knowledge base or the project's user documentation location (G-25). Read what already
   exists there for this feature before writing (G-03). If a location is not configured, ask or
   change the config; never invent one.
3. **Run the feature before describing it.** Start the software, from the repository's container
   definitions where possible, and walk each scenario as the user would. Where the software and
   the scenario disagree, put a question on the ticket; the documentation describes what the
   scenarios say and never papers over the gap (T-12).
4. **Write the user documentation from the scenarios,** for a reader with no context (G-24):
   what the user can now do, how, and what happens when it goes wrong, because that is when
   documentation is read. Link to or embed each scenario; never restate one in prose, since two
   copies drift.
5. **Write the developer documentation** in the documents folder: where the feature lives, the
   configuration keys and environment templates it reads, any migration it needs, how it is
   tested at each tier, and how to run those tests from the root test script. Anything a fresh
   clone needs to build and run the feature that is not in the repository is a gap to fix or
   ticket (O-16, G-37).
6. **Link both ways.** Every page and document links to the ticket and the feature's knowledge
   base page, and the ticket and the page link back (G-26).
7. **Stage and present, then update the ticket.** Stage the documentation changes as one change
   set on a branch that references the ticket, with a docs-typed Conventional Commit message
   (G-33, G-39), present the staged diff and the message, and stop; commit only if the user
   asked for that commit (O-17, G-40). Update the ticket with what was written, where, and what
   remains (G-12). Then report.

## Artifacts

**Feature documentation** in the documents folder for developer docs; the knowledge base or the project's user documentation location for user docs. Done when:

- A user can do what the scenarios describe by following the user documentation
- A developer can find where the feature lives and how it is tested from the developer documentation
- Linked from the ticket and the feature's knowledge base page

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

- **G-37** Commit everything needed to build, deploy, and operate the software with the change that needs it: configuration templates, migrations, scripts, pipeline, infrastructure, container, and alert definitions, runbooks, and the development environment configuration. If a fresh clone plus the documented secrets could not build, deploy, and run the system after your change, something is missing from the repository; find it and commit it.
- Write from the scenarios, verify against the software. The scenarios say what should happen; run the feature to confirm the documentation is describing what does.
- Document the unhappy path. Users read documentation when something went wrong.
- Never duplicate a scenario in prose. Link to it, or embed it; two copies drift.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
