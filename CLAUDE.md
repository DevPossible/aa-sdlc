# Project: AASDLC SDK

Agent skills and commands implementing the AASDLC methodology. Read `docs/design.md`,
`docs/tenets.md`, and `docs/vocabulary.md` before changing anything. Use the vocabulary exactly:
Tenet, Discipline, Process, Step, Guidance, Skill, Command, Artifact, Anchor ticket.

## Structure

- `src/aasdlc/skills/<discipline>/<step>/SKILL.md` is the unit of delivery. Frontmatter `name`
  must equal the step folder name and `description` must be present. Step names are unique across
  disciplines.
- `src/aasdlc/commands/` are thin, target-neutral, and only name a skill plus arguments.
- `src/aasdlc/workflow/` is the single source of truth for the methodology.
- `src/aasdlc/targets/<target>/` holds only what differs per target.

## Rules for skills

- Describe the process, never the tool (T-01). Name tool categories only when guidance cannot be
  followed without one.
- Describe intent in plain language against whatever ticket, wiki, and source-control tooling the
  agent already has. Never add a skill that wraps an MCP server, connector, or CLI (T-05).
- Every step anchors on a ticket ID and degrades gracefully when no ticket system is in scope.
- Guidance lives inside the skill for its step and is cited by ID from `docs/guidance.md`.
- Expectation checks live in the `health` skill only. Steps never block on missing systems.

## Commands

```powershell
./build.ps1        # validate skills, assemble .build/aasdlc
./test-smoke.ps1   # structural validation
./test-full.ps1    # smoke plus Pester tests in tests/
./package.ps1      # version, build, test, zip to .dist/
```
