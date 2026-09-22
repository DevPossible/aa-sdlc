---
name: prepare-release
description: "Assemble a release: decide the version, generate release notes from the tickets and commits since the last release, write the change record, and run the go/no-go checklist. Produces everything needed to say \"ready\" or \"not yet\"."
aa:
  discipline: release-management
  step: prepare-release
  guidance_sets: [every-step, anchored-step]
  guidance: [G-04, G-11, G-13, G-34, G-47]
  requires: [R-01, R-03, R-05, R-11, R-20, R-28, R-33, R-38]
---

# /aa-rel-prepare-release

Assemble a release: decide the version, generate release notes from the tickets and commits since the last release, write the change record, and run the go/no-go checklist. Produces everything needed to say "ready" or "not yet".

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- Merged changes and their tickets since the last release tag
- Test results across all tiers, security test results, and UAT results
- The project's versioning and release conventions

## Procedure

1. **Anchor and find the range.** Read the release ticket, its page, and the project's
   versioning and release conventions (G-22). Find the last release tag and list every commit
   and merged change since it, with the ticket each references.
2. **Trace every commit to a ticket** (O-19). A commit since the last tag that names no ticket,
   or that does not parse as a Conventional Commit, is a finding on the release ticket, not
   something to work around (G-34); the release is not ready until each has a ticket or a
   recorded reason.
3. **Derive the version** from the commit types since the last tag, breaking change, feature,
   or fix, by the project's scheme (O-14, G-34). Compute it with a tool (G-02) and list the
   commits that drove the bump.
4. **Name the artifact that was tested.** Find the immutable identity the pipeline produced for
   the release commit and confirm it is the identity that ran every test tier, the security
   tests, and UAT (O-24, G-47). A release that names a rebuilt or unidentified artifact is not
   ready.
5. **Generate the notes from the record, then edit for the reader.** Group commits by type and
   ticket, check that every included ticket appears and nothing appears that is not included,
   then rewrite for the audience the project names: users, operators, or both. Write the notes
   file in the location the conventions name.
6. **Run the go/no-go checklist on the release ticket.** For each item, link the evidence: the
   test run for each tier, the security test results, the UAT record, the scan (G-04). Nothing
   is marked done on someone's word; an item that does not apply says why. Record the decision
   and who made it.
7. **Record the release** in the ticket system and the knowledge base: the version, the
   artifact identity, and the notes, each linked from the release ticket and back (G-26).
8. **Stage and present; do not cut the tag.** Stage the notes file with a Conventional Commit
   message and present it (G-11, O-17, G-40). State the tag name and the commit it will point
   at, and create or push the tag only when the user asks (G-13). Update the ticket with ready
   or not yet, and why (G-12).

## Artifacts

**Version and release notes** in source control as a tag and notes file; the ticket system as the release; the knowledge base. Done when:

- Version follows the project's scheme and the bump is derived from the commit types since the last tag (O-14); the release names the artifact identity that was tested (O-24)
- Every included ticket appears in the notes; nothing appears that is not included
- Written for the audience the project names: users, operators, or both

**Change record and go/no-go checklist** in the release ticket. Done when:

- Every checklist item has evidence linked or is marked not applicable with a reason
- The decision and who made it are recorded

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

*For this step:*

- **G-04** Before marking a step done, run the project's build and tests and quote their actual output. "It should work" is not evidence.
- **G-11** Every artifact that belongs with the code goes into the same change set as the code, staged for the commit the user makes (G-40). Nothing that matters is left only on a local disk or in a conversation.
- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-34** Derive the release from the history: the version bump from the commit types since the last tag (breaking change, feature, fix) and the release notes by grouping commits by type and ticket, then edit the notes for the reader. A commit that does not parse is a finding on the release ticket, not something to work around.
- **G-47** Build the release artifact once, from one commit, give it an immutable identity, and promote that same identity through every environment; supply environment configuration at deploy time from the committed templates (O-16), never by rebuilding. Record the identity on the release, roll back to a previous identity rather than a rebuilt tag, and verify in each environment that the running identity is the one deployed.
- Generate the notes from the record, then edit for the reader. Group commits by type and ticket (O-14); tickets and commits say what changed, a person says what it means.
- Never mark a checklist item done on someone's word. Link the test run, the approval, the scan.
- A release with an unexplained change in it is not ready. Every commit since the last tag traces to a ticket or gets one.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
