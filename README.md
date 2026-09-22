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
`/aa-<step>` commands such as `/aa-health`, `/aa-init`, and `/aa-implement`.

## What it will be

- One skill and command per step of the SDLC, from discovery through maintenance, each runnable
  standalone at any time.
- Opinionated for consistency, but not enforcing. The ticket system is the state store, the wiki is
  the memory, source control is the output. The SDK owns no process state.
- Target-agnostic: skills ship as `SKILL.md` folders to Claude Code, Codex, Cursor, Hermes,
  OpenClaw and others. Only commands and hooks are adapted per target.
- Plugins for tech-stack packs and extra processes. Deployable at project, user, team, or
  enterprise scope.
- `/aa-health` checks the install, the environment, and the current project, and reports what
  is missing without blocking anything.

## Layout

```
docs/          design, tenets, opinions, vocabulary, guidance, requirements index
features/      the framework's own requirements as Gherkin (source of truth)
scripts/       build and validation helpers
src/aa-sdlc/    the SDK content: skills, commands, workflow, plugins, targets
tests/         integration tests
build.ps1      validate skills and assemble the package into .build/
test-smoke.ps1 fast structural validation
test-full.ps1  smoke plus tests/
package.ps1    version, build, test, and zip into .dist/
```

There is no `start-*.ps1` because a skills package has nothing to run.

## Related

- Methodology and business case: https://aasdlc.com
