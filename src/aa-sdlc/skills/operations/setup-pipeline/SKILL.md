---
name: setup-pipeline
description: "Build the pipeline that takes a merged change to production: build, every test tier, security checks, packaging, deployment per environment, and the deployment strategy that makes a release safe to ship and to roll back."
aa:
  discipline: operations
  step: setup-pipeline
  guidance_sets: [every-step, anchored-step, code-change]
  guidance: [G-14, G-29, G-38, G-47, G-48]
  requires: [R-11, R-20, R-24, R-38, R-39]
---

# /aa-ops-setup-pipeline

Build the pipeline that takes a merged change to production: build, every test tier, security checks, packaging, deployment per environment, and the deployment strategy that makes a release safe to ship and to roll back.

## Anchor

Anchor first (G-22). Read the anchor ticket, its linked scenarios, and its knowledge base page before doing anything. If there is no ticket, create one or ask; if no ticket system is in scope, produce every artifact locally, say so, and continue (T-05, T-10).

## Inputs

- The root scripts (build, test, pack) and the infrastructure code
- The release and deployment conventions
- The project's pipeline tooling category

## Procedure

1. **Anchor and read what the pipeline will call.** The ticket, its linked scenarios, and its
   page (G-22); the root scripts and the switches they accept; the infrastructure code and its
   environment templates; the release and deployment conventions; the pipeline tooling category
   from the project config. A root script that is missing or does not run on a fresh clone is a
   ticket for setup-environment, not logic to put in the pipeline (O-06).
2. **Run every stage locally first.** Before writing any pipeline configuration, run initialize,
   build with the lint switch, test for each tier, and pack on your machine and quote the
   output (G-04). What you ran, with those arguments, is exactly what each stage will call
   (O-11, G-29).
3. **Write the pipeline configuration** in the location the pipeline tool expects: a lint stage
   that runs the root build with the lint switch (O-21), a build stage, one stage per test tier
   that fails on any failure, the security checks, and a pack stage. Each stage is one call to
   a script or command in the repository with the same arguments; no logic lives in the
   configuration (O-11). A stage that must be skipped carries the reason beside it.
4. **Build once, deploy that identity everywhere.** The pack stage runs once per commit and
   gives the artifact an immutable identity, a digest or a version the pipeline never reuses.
   Each deploy stage takes that identity and the committed template for its environment,
   supplying the environment settings at deploy time (O-25, G-48); no deploy stage builds
   (O-24, G-47). Secrets come from the pipeline's secret store, named by the template and
   never committed (G-38).
5. **Choose the deployment strategy and write it down** in the documents folder: staged,
   canary, blue-green, or whatever fits the architecture; how each environment is promoted to;
   and how rollback returns to a previous artifact identity rather than a rebuilt tag (G-47).
6. **Protect the branches the pipeline deploys from.** Configure the protection the source
   control tool offers so a deploy cannot start from an unreviewed change, and never use a
   bypass on it (G-14). Record in the strategy document any protection the tool cannot express.
7. **Prove it with a run.** Trigger the pipeline on the branch, or its nearest local equivalent,
   and quote the result of every stage (G-04). A failing stage is reproduced locally with the
   same script before anything is changed (G-29); nothing is suppressed to reach green (G-06).
8. **Stage and present.** Stage the pipeline configuration, the strategy document, and any
   script changes as one change set with a Conventional Commit message; commit only if the user
   asked (O-17, G-40). Update the ticket with what was produced, the run that proved it, and
   what remains (G-12).

## Artifacts

**Deployment pipeline configuration** in the repository, in the location the pipeline tool expects. Done when:

- Calls the root scripts rather than duplicating their logic (O-06)
- Runs every test tier and fails on any failure; no skipped stages without a recorded reason
- Runs the root build with the lint switch as its lint stage (O-21)
- Deploys to each environment the same artifact, built once and identified immutably; no deploy stage builds (O-24)
- Every stage calls a script or command in the repository that runs locally with the same arguments (O-11)

**Deployment strategy documentation** in the documents folder. Done when:

- States the strategy (for example staged, canary, blue-green) and how rollback works for it

## Guidance

Read these guidance sets before starting; each is one file, installed beside this skill:

- `src/aa-sdlc/skills/aa-guidance/sets/every-step.md`: What every step does regardless of discipline: compute rather than estimate, read before writing, never suppress a failure, report exactly, write for a reader with no context.
- `src/aa-sdlc/skills/aa-guidance/sets/anchored-step.md`: What every step that anchors on a ticket does: anchor first, end by updating the ticket, put artifacts where the workflow says, link both ways, stay inside the one configured ticket project.
- `src/aa-sdlc/skills/aa-guidance/sets/code-change.md`: What every step that changes code, configuration, or infrastructure does, on top of repository-write: format changed files, prove with the build and tests, plan before a multi-step change, reference the ticket, commit everything needed to build and operate, let the tools decide style, change dependencies through the package manager.

*For this step:*

- **G-14** Never use a bypass flag on a hook, check, or protected branch. If a gate blocks, fix the cause or tell the user.
- **G-29** Put every pipeline step's logic in a root script or a command committed to the repository and call it from the pipeline with the same arguments; when a pipeline step fails, reproduce it locally with that same script before changing anything. A step that can only run in the pipeline is a defect: ticket it and move the logic out.
- **G-38** Never commit a secret value. Commit a configuration template that names every key with a placeholder for each secret, and record in the development environment configuration where each secret comes from and how a fresh clone obtains it.
- **G-47** Build the release artifact once, from one commit, give it an immutable identity, and promote that same identity through every environment; supply environment configuration at deploy time from the committed templates (O-16), never by rebuilding. Record the identity on the release, roll back to a previous identity rather than a rebuilt tag, and verify in each environment that the running identity is the one deployed.
- **G-48** Split configuration by what varies: settings that differ between environments (endpoints, connection strings, resource names, credentials) go in an environment file or the platform's equivalent, one per environment with a committed template, supplied at deploy time; settings that are the same everywhere (timeouts, limits, behaviour) go in the application configuration committed once with the code. Never put a key in both; when adding a setting, ask which kind it is and put it in that one place, and if a functional setting must differ for one environment, record why in a decision record rather than copying the configuration.
- The pipeline calls the scripts; the scripts do the work. Logic in pipeline configuration cannot be run locally and will drift (O-11).
- One artifact, promoted. Build once, give it an immutable identity, deploy that identity everywhere; never rebuild for a later environment (O-24).
- A pipeline that can be bypassed is not a pipeline. Protect the branches it deploys from.

## Report

State what was produced and where, quote the output of anything that was run, list what was skipped or could not be done and why, and name what remains (G-15). Update the anchor ticket with the same (G-12). Stage every changed file as one change set and present the summary with a Conventional Commit message; commit only if the user asked for that commit (O-17, G-40).
