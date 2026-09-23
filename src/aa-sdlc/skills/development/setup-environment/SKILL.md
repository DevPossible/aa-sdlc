---
name: setup-environment
description: "Make a fresh clone buildable and testable: fill in the root scripts, configure the tools the stack needs, and record anything a new developer must do by hand."
aa:
  discipline: development
  step: setup-environment
  guidance_sets: [every-step, anchored-step, code-change]
  guidance: [G-29, G-30, G-38, G-48]
  requires: [R-11, R-18, R-19, R-20, R-21, R-24, R-25, R-26, R-39, R-13]
---

# /aa-dev-setup-environment

Make a fresh clone buildable and testable: fill in the root scripts, configure the tools the stack needs, and record anything a new developer must do by hand.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The technology stack document and constraints
- The stub root scripts from aa init, or the existing scripts
- Tech-stack plugins in scope

## Procedure

1. **Anchor and read what exists.** The ticket, the technology stack document and its
   constraints, the tech-stack plugins in scope, and the scripts and configuration the
   repository already has. Where the repository has an equivalent of a conventional folder or
   script under another name, map it in the project config rather than adding a second (O-05).
2. **Fill in the root scripts** (O-06). `initialize` installs the tools the stack needs through
   their package managers, never by hand, and is safe to run twice. `build` builds every
   project and accepts a lint switch that runs the formatter in check mode and every configured
   linter (O-21). `test` accepts a tier and runs even with zero tests (O-07). `pack` produces
   the artifacts once with an immutable identity (O-24). Whatever the pipeline will run is a
   script here first; a step that only works on the pipeline runner is a defect (O-11).
3. **Conventions by tool.** For each language, configure the formatter the project or a plugin
   names (R-09) and the linter where one is known (R-12). Do not choose a tool the project has
   not chosen; list what is available and let the user choose (T-01). Record a language with
   no known linter in the development environment configuration so health's warning is
   expected (G-44).
4. **Split the configuration.** Environment-specific settings go in one environment template
   per environment with placeholders for secrets; functional settings go in the application
   configuration once; no key in both (O-25). Write where every secret comes from and how a
   fresh clone obtains it; commit no secret value (G-38).
5. **The end-to-end environment.** Where the stack allows, container definitions in the
   repository that the test script starts for the e2e tier (O-12); record any dependency that
   cannot be containerised and how it is reached.
6. **Coverage.** Detect the stack and say which technologies have a skill or plugin in scope
   and which do not (R-13); the user chooses what to add.
7. **Prove it on a clean clone.** Clone to a temporary folder and run initialize, build with the
   lint switch, test, and pack there. Quote the output (G-04). If a step needed a file from your
   machine or a value from your head, commit the template and document the source (O-16).
8. **Write the development environment configuration** in the documents folder: tools per
   language, anything not automated by initialize with its reason, exceptions health should
   expect, and secret sources. Automate before documenting; a manual step is a bug in
   initialize until proven impossible to automate.
9. **Stage and present** every changed file as one change set with a Conventional Commit
   message; commit only if the user asked (O-17). Update the ticket (G-12) and report.

## Artifacts

**Repository structure** in the repository root. Done when:

- Follows the conventional structure or maps to it in the project config (O-05)

**Working root scripts** in the repository root. Done when:

- initialize, build, test, and pack each run to completion on a fresh clone (O-06)
- test accepts a tier parameter and each tier has a home (O-07)
- build accepts a lint switch that runs the formatter check and every configured linter; languages with no known linter are recorded in the development environment configuration (O-21)
- The e2e tier starts the system and its dependencies in containers from definitions in the repository, where the stack allows (O-12)

**Development environment configuration** in the documents folder. Done when:

- Anything not automated by initialize is written down as a step with a reason
- Names where every secret comes from and how a fresh clone obtains it; no secret value is committed (O-16)
- Environment-specific settings are in one environment template per environment; functional settings are in the application configuration once; no key is in both (O-25)

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/code-change.md`: What every step that changes code, configuration, or infrastructure does, on top of repository-write: format changed files, prove with the build and tests, plan before a multi-step change, reference the ticket, commit everything needed to build and operate, let the tools decide style, change dependencies through the package manager.

*For this step:*

- **G-29** Put every pipeline step's logic in a root script or a command committed to the repository and call it from the pipeline with the same arguments; when a pipeline step fails, reproduce it locally with that same script before changing anything. A step that can only run in the pipeline is a defect: ticket it and move the logic out.
- **G-30** Run the end-to-end tier against the system and its dependencies started in containers from definitions committed to the repository, so it runs the same way on any machine and in the pipeline. Reach a shared environment only for a dependency that cannot be containerised, and record which tests depend on it.
- **G-38** Never commit a secret value. Commit a configuration template that names every key with a placeholder for each secret, and record in the development environment configuration where each secret comes from and how a fresh clone obtains it.
- **G-48** Split configuration by what varies: settings that differ between environments (endpoints, connection strings, resource names, credentials) go in an environment file or the platform's equivalent, one per environment with a committed template, supplied at deploy time; settings that are the same everywhere (timeouts, limits, behaviour) go in the application configuration committed once with the code. Never put a key in both; when adding a setting, ask which kind it is and put it in that one place, and if a functional setting must differ for one environment, record why in a decision record rather than copying the configuration.
- Prove it on a clean clone. Clone to a temporary folder and run initialize, build, test, and pack there before calling it done.
- Automate before documenting. A manual step in the documentation is a bug in initialize until it is proven to be impossible to automate.
- Do not choose tools the project has not chosen. Use what the stack document, plugins, and existing config name; where nothing does, ask.
- Whatever the pipeline will run, make it a script here first. A step that only works on the pipeline runner is a defect (O-11).
- The fresh clone is the test. If it needs a file from your machine, a page from the wiki, or a value from your head, commit the template and document the source (O-16).

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
