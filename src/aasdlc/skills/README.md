# Skills

Core skills grouped by discipline: `<discipline>/<step>/SKILL.md`. A skill folder contains
`SKILL.md` (frontmatter `name` and `description`, then instructions) and optionally `references/`
and `templates/`. One skill implements one step. The installer flattens the tree on install, so
step names must be unique across disciplines.

Disciplines: `business-analysis`, `technical-analysis`, `refinement`, `implementation-planning`,
`development`, `testing`, `documentation`, `project-management`, `operations` (proposed).

Guidance for a step lives inside its skill. The `aasdlc` meta skill that routes between steps
lives at the top level of this folder. See `docs/vocabulary.md` and `docs/design.md`.
