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

Anchor first (G-22). Read the ticket, linked scenarios and knowledge page; check requirement currency under G-54. Pull instructions below apply only when the snapshot changed or currency is unknown. If no ticket system is reachable, record the anchor and artifacts locally, say so, and continue (T-05, T-10).

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
   the ticket (G-33), present the staged diffs and messages; honor existing explicit task commit authorization (O-17, G-40).

## Artifacts

**Security patch log** in the knowledge base, with each patch as a ticket. Done when:

- Every known vulnerability above the agreed threshold is patched, accepted with a reason, or ticketed with a date

**Compliance audit evidence** in the knowledge base. Done when:

- Every control has current evidence or an open ticket

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context, and touch only what is this project's in systems shared with others.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first and check requirement currency, update the ticket at meaningful checkpoints, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/code-change.md`: What every step that changes code, configuration, or infrastructure does, on top of repository-write: format changed files, prove with the build and tests, plan before a multi-step change, reference the ticket, commit everything needed to build and operate, let the tools decide style, change dependencies through the package manager, and never let a hand-edited feature file through.

*For this step:*

- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-38** Never commit a secret value. Commit a configuration template that names every key with a placeholder for each secret, and record in the development environment configuration where each secret comes from and how a fresh clone obtains it.
- Patch in small, tested steps. A dependency update is a change like any other: branch, test, review, merge (G-08). Make it with the package manager so the lock file and transitive graph move together; never edit a version by hand (O-22).
- Never commit, log, or paste a secret, including in the report of having found one. Reference where it was, not what it was.
- Treat "no findings" as a finding to verify. Confirm the scanner ran against the current code before reporting clean.

## Report

State what was produced and where, link actual run output and summarize its scope and results, name failures/skips and what remains (G-15). Update the anchor at the meaningful milestone (G-12), referencing one proportionate evidence record instead of repacking unchanged proof. Stage only task-owned changes; honor existing explicit task commit authorization, otherwise present the diff and Conventional Commit message without committing (G-40).
