# Target: Claude Code

How AA-SDLC installs into Claude Code. Until the `aa` CLI exists, this repository carries a
manual project-scope install of its own framework commands under `.claude/commands/`.

| AA-SDLC | Claude Code |
|---------|-------------|
| skill `skills/<discipline>/<step>/SKILL.md` | `.claude/skills/aa-<code>-<step>/SKILL.md` (project scope) or `~/.claude/skills/...` (user scope) |
| command `/aa-<code>-<step>` | `.claude/commands/aa-<code>-<step>.md`: a thin file that reads the skill and passes `$ARGUMENTS` |
| hooks | `.claude/settings.json` hooks; supported (R-15 met) |
| subagents | `.claude/agents/`; supported |

A command file contains only a description and one line pointing at the skill, so behaviour
lives in the skill and the command is target-specific glue. Claude Code discovers
`.claude/commands/` from the folder it is opened in, so these commands are available when
Claude Code is started in the aa-sdlc repository.
