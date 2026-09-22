# Skills

Core skills grouped by discipline: `<discipline>/<step>/SKILL.md`. A skill folder contains
`SKILL.md` (frontmatter `name` and `description`, then instructions) and optionally `references/`
and `templates/`. One skill implements one step. The installer flattens the tree on install, so
step names must be unique across disciplines.

Disciplines and codes: `business-analysis` (ba), `product-management` (pd), `ux-design` (ux),
`technical-analysis` (ta), `refinement` (rf), `implementation-planning` (ip), `development`
(dev), `testing` (qa), `security` (sec), `documentation` (doc), `release-management` (rel),
`operations` (ops), `support` (sup), `project-management` (pm). A step's command is
`/aa-<code>-<step>`; the framework skills `health`, `init`, and `extend` live under `fw/` and
are `/aa-fw-health`, `/aa-fw-init`, `/aa-fw-extend`.

Guidance for a step lives inside its skill. The `aa-sdlc` meta skill that routes between steps
lives at the top level of this folder. See `docs/vocabulary.md` and `docs/design.md`.
