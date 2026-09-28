# Target: Claude Code

Claude Code's row in [../targets.yaml](../targets.yaml) is the only one verified in the harness
itself. It reads skills from `.claude/skills/` (project scope) or `~/.claude/skills/` (user
scope), and commands from `.claude/commands/`: a thin file per skill that reads the skill and
passes `$ARGUMENTS`. It supports hooks (`.claude/settings.json`) and subagents
(`.claude/agents/`); the framework ships neither yet (decision records 0014 and 0015).

This repository carries a project-scope install of its own framework commands under
`.claude/commands/`, which read the source skills directly, so they are available when Claude Code
is started in the aa-sdlc repository.
