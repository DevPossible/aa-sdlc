# AA-SDLC SDK

Agent skills and commands that implement the Agent Assisted Software Development Life Cycle
(AA-SDLC) methodology. The methodology says what a well-run agent-assisted project produces at
each step and why; this SDK gives an agent the how.

**Status:** first complete cut, unproven in the field. All 52 steps have a skill, a command,
and a feature file; the `aa` CLI (`setup`, `init`) is a Go binary packed for six platforms;
the unit, integration, and e2e tiers run. Nothing is published to npm yet, and the skills have
not been exercised against a real project. See [docs/design.md](docs/design.md) and
[docs/plan-framework-gaps.md](docs/plan-framework-gaps.md).

## We are opinionated, and here are the opinions

Read these before anything else. If you disagree, the framework is probably not for you, and we
would rather you know now. The opinions are grouped by what they govern; each line below is a
group's short form. Full statements, with what each rejects and what would change our mind, are
in [docs/opinions.md](docs/opinions.md).

- **The three systems** (O-02, O-03, O-04, O-09): source control, a ticket system, and a
  knowledge repository hold the state; the framework owns none; one repository, one ticket project.
- **The shape of a repository** (O-05, O-06, O-07, O-16): one folder layout, four root scripts,
  three test tiers, and everything needed to build and operate the software, versioned.
- **Requirements** (O-01, O-15, O-20): Gherkin in the repository is the source of truth; goals
  before mock-ups; the simplest design that meets the scenarios.
- **Tickets** (O-10, O-13): a size is grounded in implementation thinking; a waiting ticket is
  checked against the repository before work starts.
- **Commits and history** (O-14, O-17, O-19, O-22): Conventional Commits, small and cohesive,
  made by the user, traceable to their purpose; dependencies change through the package manager.
- **The delivery path** (O-11, O-12, O-24, O-25): every pipeline step runs locally; end-to-end
  tests run against containers; build once and promote; environment settings live apart from
  functional settings.
- **Practice** (O-08, O-18, O-21, O-23): Development proves the requirement and Testing goes
  beyond it; decisions are records; conventions are enforced by tools; tests are deterministic.

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
docs/          design, tenets, opinions, vocabulary, guidance, requirements index, generated discipline review
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

## Licence and trademark

Licensed under the Functional Source License, version 1.1, with Apache 2.0 as the future
licence (`FSL-1.1-ALv2`): see [LICENSE.md](LICENSE.md). In short, use it for anything,
including commercial work and client projects, modify it, and contribute back; the one thing
you may not do is offer it, or a derivative of it, as a competing product. Each version becomes
Apache 2.0 two years after its release.

AA-SDLC is a trademark of DevPossible LLC. The licence grants no right to the name: a fork or
derivative may not present itself as AA-SDLC (decision record
[0009](docs/decisions/0009-functional-source-license.md)).

## Related

- Methodology and business case: https://aasdlc.com
- Source on GitHub (mirror of the GitLab origin): https://github.com/DevPossible/aa-sdlc
