# 0015: Disciplines become generated subagents; every skill still works without them

**Date:** 2026-09-27 | **Status:** accepted | **Ticket:** none

## Context

Several steps are worth more when a separate mind does them: a review by someone who did not
write the change, tests by someone who did not see the implementation's reasoning (O-08), a
security pass with its own context. Most harnesses surveyed for decision record 0014 support
subagents (Claude Code, Codex, Gemini CLI, OpenCode, Cursor, Copilot, Qwen, Kiro, Junie,
Factory, Auggie, Cline); some do not (Pi, Windsurf, Roo, Crush, and others unconfirmed). A
hand-written subagent per harness would drift from the guidance the skills carry, which the
unit tier already keeps verbatim (decision record 0012).

## Options

- **A. One subagent per discipline, generated from the discipline's workflow data and its
  guidance sets, rendered per harness; each skill names the part it hands to the subagent and
  does that part itself where no subagent is available.** Chosen.
- **B. Hand-written subagents per harness.** Drifts from the guidance on the first edit, and
  multiplies by the number of harnesses.
- **C. One subagent per step.** Fifty-three agents whose prompts repeat their skills; the
  independence worth having is between disciplines, not steps.
- **D. No subagents.** Loses the independent review and testing that O-08 asks for, on the
  harnesses that could give it.

## Decision

Option A.

- The source is the workflow data: each discipline's purpose, what it owns and does not own,
  and the guidance sets its steps cite. `scripts/Sync-SkillGuidance.ps1`, or a sibling script,
  renders `aa-<code>` agent definitions from it; nothing about an agent is typed by hand, and
  the unit tier fails when a rendered agent differs from its source.
- The CLI writes each agent in the format and folder the target table (0014) names for it, and
  writes none for a target without subagents.
- A skill hands off by intent, for example "give the review to the Development reviewer
  subagent if one is available; otherwise review it yourself, reading the change as if you had
  not written it", so the steps are complete on every harness and only the independence is lost
  without subagents.
- First handoffs: `review` to Development, `generate-tests` and `explore` to Testing,
  `security-test` and `threat-model` to Security.

## Consequences

- The target table gains subagent formats and folders; the build gains a renderer and a check.
- The first handoffs change five skills' procedures and need scenarios before the skills change
  (T-12).
- Health reports which disciplines have an agent installed for each target.
