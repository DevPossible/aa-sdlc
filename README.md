# AA-SDLC SDK

Agent skills and commands that implement the Agent Assisted Software Development Life Cycle
(AA-SDLC) methodology. The methodology says what a well-run agent-assisted project produces at
each step and why; this SDK gives an agent the how.

**Status:** early design. Nothing is installable yet. See [docs/design.md](docs/design.md).

## We are opinionated, and here are the opinions

Read these before anything else. If you disagree, the framework is probably not for you, and we
would rather you know now. Full statements, with what each rejects and what would change our
mind, are in [docs/opinions.md](docs/opinions.md).

1. **Requirements are written in Gherkin**, kept in the repository, and are the source of truth
   for what the software must do. The tooling keeps them linked to tickets and wiki pages.
2. **All good development uses source control.** Work that is not committed did not happen.
3. **All good projects use a ticket manager.** Every unit of work anchors on a ticket, and the
   ticket system is the state store.
4. **All projects need a knowledge repository.** Tickets say what happened; the wiki says why.
5. **All repositories share one folder structure**, whatever they contain.
6. **Every repository has root scripts** for initialize, build, test, and pack, with general
   parameters for filtering and switches.
7. **Every repository has unit, integration, and end-to-end tests**, each selectable by tier.
8. **Development proves the requirement; Testing goes beyond it.** Developers write the tests
   that show a ticket is met. Testers make the suite as comprehensive as is reasonable and turn
   every gap they find into a scenario.

The framework's own requirements follow opinion 1: they are feature files under
[features/](features/).

## Install (planned)

```
npm install -g aa-sdlc
aa setup                          # once per machine
cd c:\dev\myproject
aa init                           # once per repository
```

or, without changing directory: `aa init -path c:\dev\myproject`

The `aa` CLI bootstraps and maintains the install: `setup` for the machine, `init` for a
repository, plus `update` and `plugin`. The work itself happens inside your agent through
`/aa-<code>-<step>` commands, where the code is the discipline: `/aa-dev-implement`,
`/aa-qa-generate-tests`, `/aa-rel-release`. The framework's own code is `fw`: `/aa-fw-health`,
`/aa-fw-init`, and `/aa-fw-extend`, which walks you through building an extension when the
framework needs to know about your stack, your process, or your agent.

## What it will be

- One skill and command per step of the SDLC, from discovery through maintenance, each runnable
  standalone at any time.
- Opinionated for consistency, but not enforcing. The ticket system is the state store, the wiki is
  the memory, source control is the output. The SDK owns no process state.
- Target-agnostic: skills ship as `SKILL.md` folders to Claude Code, Codex, Cursor, Hermes,
  OpenClaw and others. Only commands and hooks are adapted per target.
- Plugins for tech-stack packs and extra processes. Deployable at project, user, team, or
  enterprise scope.
- `/aa-fw-health` checks the install, the environment, and the current project, and reports what
  is missing without blocking anything.

## Layout

```
docs/          design, tenets, opinions, vocabulary, guidance, requirements index
features/      the framework's own requirements as Gherkin (source of truth)
scripts/       build and validation helpers
src/aa-sdlc/    the SDK content: skills, commands, workflow, plugins, targets
tests/         integration/ and e2e/ tiers (unit tests live with each project in src/)
initialize.ps1 bootstrap a fresh clone: tools and folders
build.ps1      validate skills and feature files, assemble the package into .build/
test.ps1       run tests by tier: -Tier unit|integration|e2e|all, -Filter
pack.ps1       version, build, test, and zip into .dist/
```

This is opinions 5, 6, and 7 applied to the framework's own repository.

## Related

- Methodology and business case: https://aasdlc.com
