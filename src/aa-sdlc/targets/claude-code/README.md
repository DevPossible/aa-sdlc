# Target: Claude Code

Claude Code's row in [../targets.yaml](../targets.yaml) is the only one verified in the harness
itself. It reads skills from `.claude/skills/` (project scope) or `~/.claude/skills/` (user
scope), and offers each skill as a command under its frontmatter `name`, so the CLI sets that to
the installed folder name (`aa-fw-health`) and writes no command files. It supports hooks (`.claude/settings.json`) and subagents
(`.claude/agents/`); the framework ships neither yet (decision records 0014 and 0015).

This repository carries a project-scope install of its own framework commands under
`.claude/commands/`, which read the source skills directly, so they are available when Claude Code
is started in the aa-sdlc repository.
