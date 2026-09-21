# AASDLC SDK

Agent skills and commands that implement the Agent Assisted Software Development Life Cycle
(AASDLC) methodology. The methodology says what a well-run agent-assisted project produces at
each step and why; this SDK gives an agent the how.

**Status:** early design. Nothing is installable yet. See [docs/design.md](docs/design.md).

## What it will be

- One skill and command per step of the SDLC, from discovery through maintenance, each runnable
  standalone at any time.
- Opinionated for consistency, but not enforcing. The ticket system is the state store, the wiki is
  the memory, source control is the output. The SDK owns no process state.
- Target-agnostic: skills ship as `SKILL.md` folders to Claude Code, Codex, Cursor, Hermes,
  OpenClaw and others. Only commands and hooks are adapted per target.
- Plugins for tech-stack packs and extra processes. Deployable at project, user, team, or
  enterprise scope.
- `aasdlc-health` checks the install, the environment, and the current project, and reports what
  is missing without blocking anything.

## Layout

```
docs/          design and specs
scripts/       build and validation helpers
src/aasdlc/    the SDK content: skills, commands, workflow, plugins, targets
tests/         integration tests
build.ps1      validate skills and assemble the package into .build/
test-smoke.ps1 fast structural validation
test-full.ps1  smoke plus tests/
package.ps1    version, build, test, and zip into .dist/
```

There is no `start-*.ps1` because a skills package has nothing to run.

## Related

- Methodology and business case: https://aasdlc.com
