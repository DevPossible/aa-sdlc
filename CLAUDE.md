# Project: AASDLC SDK

Agent skills and commands implementing the AASDLC methodology. Read `docs/design.md` before
changing anything; it holds the decisions made so far and the open questions.

## Structure

- `src/aasdlc/skills/<name>/SKILL.md` is the unit of delivery. Frontmatter `name` must equal the
  folder name and `description` must be present.
- `src/aasdlc/commands/` are thin, target-neutral, and only name a skill plus arguments.
- `src/aasdlc/workflow/` is the single source of truth for the methodology.
- `src/aasdlc/targets/<target>/` holds only what differs per target.

## Rules for skills

- Describe intent in plain language against whatever ticket, wiki, and source-control tooling the
  agent already has. Never add a skill that wraps an MCP server, connector, or CLI.
- Every phase skill anchors on a ticket ID and degrades gracefully when no ticket system is in
  scope.
- Expectation checks live in the `health` skill only. Steps never block on missing systems.

## Commands

```powershell
./build.ps1        # validate skills, assemble .build/aasdlc
./test-smoke.ps1   # structural validation
./test-full.ps1    # smoke plus Pester tests in tests/
./package.ps1      # version, build, test, zip to .dist/
```
