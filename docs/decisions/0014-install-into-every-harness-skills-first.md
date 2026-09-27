# 0014: Install into every harness the user picks, skills first, from one target table

**Date:** 2026-09-27 | **Status:** accepted | **Ticket:** none

## Context

The CLI installs into Claude Code only. A survey of 24 coding-agent harnesses from their official
documentation (2026-09-27) found that most now load `SKILL.md` skill folders: about two thirds
read `~/.agents/skills` and `.agents/skills`, nine also read `.claude/skills`, and many turn each
skill into its own `/name` command, so separate command files are becoming redundant. Gemini CLI
(TOML), OpenCode, Pi, Factory, and Qwen still take command files. Aider has no skills or
commands. A user may work in several harnesses on one machine and one repository. Several
harnesses read two skill folders, so writing every folder shows them the same skill twice.

## Options

- **A. One table of targets as data; install the skills into the fewest folders that reach
  every chosen target; commands only where a target has no skill command; a marked block in the
  project's instruction file; harness hooks opt-in.** Chosen.
- **B. A Go adapter per harness.** Twenty adapters that differ mostly in paths; each harness
  change is a code change.
- **C. Write every folder every harness reads.** Simplest, and every dual-reading harness lists
  each skill twice.
- **D. Claude Code only, and document manual copying for the rest.** Leaves most users with a
  manual step the CLI can do (O-06).

## Decision

Option A.

- `src/aa-sdlc/targets/targets.yaml` lists each target: id, name, status (`supported` or
  `planned`), how it is detected (a home folder or a command on the PATH), the skill folders it
  reads at user and project scope in its order of preference, its command format and folder if
  it needs command files, and the instruction file it reads.
- The user chooses targets as a checklist: `aa setup` pre-selects every target it detects,
  `-targets` names them explicitly, and the config records the list.
- Skills are written once per chosen folder, not once per target. The planner starts with the
  folders a chosen target can only read one way (`.claude/skills` for Claude Code), then covers
  each remaining target with the shared `.agents/skills` where it reads it, and its own folder
  otherwise. A target that still sees two chosen folders is named in the output.
- Command files are written only in the formats a target needs: Claude Markdown with
  `$ARGUMENTS`, Gemini TOML with `{{args}}`, Markdown with `{{args}}` for Qwen.
- `aa init` writes a block between `<!-- aa-sdlc:begin -->` and `<!-- aa-sdlc:end -->` in the
  project's instruction file for each chosen target (`AGENTS.md`, or `CLAUDE.md` or
  `GEMINI.md` where the target reads that instead), naming the ticket project and knowledge
  base and pointing at `/aa-fw-whatsnext`. It replaces only its own block.
- Enforcement stays in git hooks, which work under every harness. Harness hooks are offered per
  target, never installed silently.

## Consequences

- Adding a harness is a row in the table and, at most, a command format.
- The guidance path each skill cites is rewritten for every folder the skills are written to.
- Update and stale-file removal track every folder the install wrote, not only `.claude`.
- A harness whose documentation is wrong about a folder is fixed in the table, and health
  reports which targets were installed where.
