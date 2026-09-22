---
name: maintain-security
description: "Keep the system safe after release: patch dependencies, rotate and remove secrets, review access, and keep the compliance evidence current. Recurring; each run anchors on a maintenance ticket."
aa:
  discipline: security
  step: maintain-security
  guidance_sets: [every-step, anchored-step, code-change]
  guidance: [G-13, G-38]
  requires: [R-11]
---

# /aa-sec-maintain-security

Keep the system safe after release: patch dependencies, rotate and remove secrets, review access, and keep the compliance evidence current. Recurring; each run anchors on a maintenance ticket.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- Dependency and vulnerability reports from the project's tooling
- The compliance report and the controls it must evidence
- Secrets and access inventories where the project keeps them

## Procedure

1. **Anchor.** Read the maintenance ticket and its knowledge base page (G-22), then the
   compliance report and the controls it must evidence, and the secrets and access inventories
   where the project keeps them. Run the dependency and vulnerability scanners against the
   current head before reading their reports; a report older than the code is not evidence.
2. **Triage every vulnerability above the agreed threshold.** Each gets one of three outcomes:
   patched now, accepted with a written reason and an owner, or ticketed with a date. Nothing is
   left unmentioned. Treat "no findings" as a finding to verify: confirm the scanner ran against
   the current code before reporting clean (T-07).
3. **Patch in small, tested steps.** Each dependency update is a change like any other (G-08):
   a branch that names the ticket (G-09), one dependency or one cohesive group per commit
   (G-39). Make the change with the package manager so the manifest, the lock file, and the
   transitive graph move together; never edit a version by hand, and if the tool refuses, the
   refusal goes on the ticket and is resolved, not bypassed (O-22, G-45). Run the root build and
   tests after each and quote the output (G-04).
4. **Rotate and remove secrets.** Check every secret in the inventory against its rotation date,
   and every committed configuration template for keys named and no values (O-16, G-38). A
   secret found in the repository, a log, or a page is reported by where it was, never by what
   it was; it is rotated and the exposure becomes a ticket. Ask before any rotation that would
   interrupt a running system (G-13).
5. **Review access.** Compare who and what can reach each system with who and what should,
   remove what is no longer needed, and record each change. An access change that cannot be
   undone is confirmed with the user first (G-13).
6. **Update the security patch log** in the knowledge base with each patch, acceptance, or
   deferral and its ticket, and update the compliance audit evidence so that every control has
   current evidence or an open ticket. A control with neither gets a ticket now.
7. **Update the ticket and present the change.** Record on the maintenance ticket what was
   patched, accepted, deferred, rotated, and revoked, and what remains (G-12). Stage each
   dependency change as its own commit on its branch with a Conventional Commit message naming
   the ticket (G-33), present the staged diffs and messages, and stop; commit only if the user
   asked for that commit (O-17, G-40).

## Artifacts

**Security patch log** in the knowledge base, with each patch as a ticket. Done when:

- Every known vulnerability above the agreed threshold is patched, accepted with a reason, or ticketed with a date

**Compliance audit evidence** in the knowledge base. Done when:

- Every control has current evidence or an open ticket

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

*From the `code-change` set:* What every step that changes code, configuration, or infrastructure does, on top of repository-write: format changed files, prove with the build and tests, plan before a multi-step change, reference the ticket, commit everything needed to build and operate, let the tools decide style, change dependencies through the package manager.

- **G-01** Always format the code for the changed files before committing, but do not format files that were not changed.
- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-08** Before any multi-step change, write the plan and get it confirmed; one concern per commit and one ticket per branch is G-39.
- **G-09** Reference the anchor ticket in the branch name and every commit message.
- **G-11** Every artifact that belongs with the code goes into the same change set as the code, staged for the commit the user makes (G-40). Nothing that matters is left only on a local disk or in a conversation.
- **G-33** Write every commit message in Conventional Commits form: a type from the project's list, an optional scope, an imperative subject, a body that says why, and a footer carrying the ticket reference and any breaking change. One concern per commit (G-39); if you cannot name the type, split the commit.
- **G-37** Commit everything needed to build, deploy, and operate the software with the change that needs it: configuration templates, migrations, scripts, pipeline, infrastructure, container, and alert definitions, runbooks, and the development environment configuration. If a fresh clone plus the documented secrets could not build, deploy, and run the system after your change, something is missing from the repository; find it and commit it.
- **G-39** Make each commit one understandable change: one concern per commit, one ticket per branch, a subject that says what and a body that says why, small enough to review in one sitting. If the subject needs "and" or the diff needs a tour, split it.
- **G-40** Never commit unless the user asked for that commit. Stage the change, write the message, present the staged diff summary and the message, and stop; a request to implement, fix, finish, or run a step is not a request to commit, and the commit is made under the user's identity with no agent attribution.
- **G-42** Before making a change, name what it is for: the ticket, the scenario it satisfies, or the decision record or page that explains it, and put that reference where the change lives: the branch, the commit footer, the merge request, and the artifact. A change that cannot name its purpose is a ticket to create first or work not to do; in review, a hunk that traces to nothing is a finding.
- **G-44** Let the tools decide style: conventions live as formatter and linter configuration in the repository, the formatter runs on changed files and the linter runs from the root build before a change is presented, and every finding is fixed or suppressed with a reason beside it. Never argue style in review; where a language has no known linter, record that once in the development environment configuration and expect the health warning.
- **G-45** Change dependencies only through the ecosystem's package manager: add, update, and remove with its commands so it resolves conflicts, surfaces warnings, and updates transitive dependencies and the lock file together, and stage the manifest and lock file changes as their own commit (G-39). Never edit a version in a manifest or lock file by hand; if the tool refuses, record the refusal on the ticket and resolve it, never bypass it.

*For this step:*

- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-38** Never commit a secret value. Commit a configuration template that names every key with a placeholder for each secret, and record in the development environment configuration where each secret comes from and how a fresh clone obtains it.
- Patch in small, tested steps. A dependency update is a change like any other: branch, test, review, merge (G-08). Make it with the package manager so the lock file and transitive graph move together; never edit a version by hand (O-22).
- Never commit, log, or paste a secret, including in the report of having found one. Reference where it was, not what it was.
- Treat "no findings" as a finding to verify. Confirm the scanner ran against the current code before reporting clean.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
