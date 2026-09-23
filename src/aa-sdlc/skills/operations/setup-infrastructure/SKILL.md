---
name: setup-infrastructure
description: "Define the environments the system runs in as code, with runbooks for the operations that are not automated, meeting the constraints from architecture and the controls from security."
aa:
  discipline: operations
  step: setup-infrastructure
  guidance_sets: [every-step, anchored-step, code-change]
  guidance: [G-13, G-38, G-41, G-48]
  requires: [R-06, R-32, R-39]
---

# /aa-ops-setup-infrastructure

Define the environments the system runs in as code, with runbooks for the operations that are not automated, meeting the constraints from architecture and the controls from security.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The architecture, technical constraints, and security requirements
- The organisation's platform standards from the enterprise scope
- The project's infrastructure tooling category

## Procedure

1. **Anchor and read the constraints.** Read the ticket, its linked scenarios, and its page
   (G-22); then the architecture, the technical constraints, the security requirements and the
   threat model, the organisation's platform standards from the enterprise scope, and the
   infrastructure tooling category the project config names. Use the tooling the project has
   chosen; where none is named, list what is in scope and let the user choose (T-01).
2. **List the environments and what differs between them.** From the architecture, name every
   environment the system runs in and, for each, the settings that differ: endpoints, resource
   names, connection strings, credentials. Everything else belongs in the application
   configuration, not here (O-25, G-48). Put the list on the ticket before writing any code.
3. **Write the infrastructure as code** in the source folder as its own project, on a branch
   that references the ticket (G-09). Every resource, role, credential, and network path is the
   narrowest that works; where one must be wider, write a decision record and link it from the
   ticket (G-41, O-18). Nothing is created by hand: an environment changed by hand is an
   environment nobody can rebuild (O-16).
4. **Write one configuration template per environment,** naming every key with a placeholder
   for each secret and holding no secret value (G-38). Record where each secret comes from and
   how a fresh clone obtains it. Confirm no key appears in both a template and the application
   configuration (O-25).
5. **Implement or ticket every security control.** Walk the controls the threat model names;
   each is implemented in the code or has a ticket linked from this one with the reason it is
   not yet done. None is dropped silently.
6. **Ask before anything that costs money or is hard to delete** (G-13). Present what would be
   created, in which environment, and what it costs; apply the code only with the user's
   consent. Then prove the environment is reproducible from the code alone: apply it, quote
   the output (G-04), and destroy and recreate whatever can safely be destroyed.
7. **Write the deployment runbooks** in the documents folder, one per manual operation, each
   with preconditions, steps, verification, and rollback. A manual step is a candidate for
   automation until proven otherwise; each runbook says why its operation is manual.
8. **Stage and present.** Format the changed files (G-01) and stage the infrastructure project,
   the templates, the runbooks, and any decision records as one change set with a Conventional
   Commit message; commit only if the user asked (O-17, G-40). Update the ticket with what was
   produced, what was applied, and what remains (G-12).

## Artifacts

**Infrastructure code** in the source folder, as its own project, on a branch linked to the ticket. Done when:

- Every environment is reproducible from the code with no manual steps beyond the runbook
- A configuration template exists for every environment, with every key named and no secret values (O-16), holding only the settings that differ between environments (O-25)
- Security controls from the threat model are implemented or ticketed

**Deployment runbooks** in the documents folder. Done when:

- Every manual operation has a runbook with preconditions, steps, verification, and rollback

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/code-change.md`: What every step that changes code, configuration, or infrastructure does, on top of repository-write: format changed files, prove with the build and tests, plan before a multi-step change, reference the ticket, commit everything needed to build and operate, let the tools decide style, change dependencies through the package manager.

*For this step:*

- **G-13** Stop and ask before any irreversible action (deploy, delete, external message, merge to a protected branch) unless the user granted it in advance.
- **G-38** Never commit a secret value. Commit a configuration template that names every key with a placeholder for each secret, and record in the development environment configuration where each secret comes from and how a fresh clone obtains it.
- **G-41** Write every significant decision, technical, product, or process, as a decision record the moment it is made: one screen, numbered next in the repository's sequence, dated, with context, options considered, decision, and consequences, linked from the anchor ticket. Never edit an accepted record; supersede it with a new one that links back.
- **G-48** Split configuration by what varies: settings that differ between environments (endpoints, connection strings, resource names, credentials) go in an environment file or the platform's equivalent, one per environment with a committed template, supplied at deploy time; settings that are the same everywhere (timeouts, limits, behaviour) go in the application configuration committed once with the code. Never put a key in both; when adding a setting, ask which kind it is and put it in that one place, and if a functional setting must differ for one environment, record why in a decision record rather than copying the configuration.
- Everything as code, reviewed and tested like code. An environment changed by hand is an environment nobody can rebuild (O-16).
- Least privilege by default. Every credential, role, and network path is the narrowest that works, and widening one is a decision record.
- Ask before creating anything that costs money or is hard to delete.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
