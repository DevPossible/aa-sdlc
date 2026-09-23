# 0011: The semantic compressor is an authoring aid for this repository; the skills stay as generated

**Date:** 2026-09-23 | **Status:** accepted | **Ticket:** none

## Context

The user asked to fold [claude-world/skills-optimizer](https://github.com/claude-world/skills-optimizer)
(the `semantic-compressor` skill, v2.0.0) into our own workflow for optimising skills, for us
only and not as a facility for consumers, with a pilot and a hand comparison before any wider
run. The tool drafts a shorter Markdown candidate, binds a preservation inventory to the
source hash, gates the candidate deterministically (frontmatter, literals, ratio), requires an
independent semantic review, and applies atomically with a hash-bound backup. Its published
results (about 6:1) come from verbose community skills.

Measured before the pilot: the 52 skills hold 71,474 words, of which 36,531 (51 percent) are
the Guidance sections, canonical text copied verbatim from `docs/guidance.md` so a skill reads
whole to someone with no context (G-24, T-13). That text may not be paraphrased.

## Options

- **A. Vendor the tool at project scope, keep the guidance text literal by a new unit check, pilot
  one skill, and roll out only if the comparison earns it.** Chosen.
- **B. Do not adopt.** Loses a fail-closed way to review any future verbose contribution.
- **C. Ship the tool inside the package or as a framework step.** The user excluded this.

## Decision

Option A, with these facts from the pilot on `development/setup-environment`:

| Measure | Source | Aggressive candidate |
|---------|--------|----------------------|
| Whole file, words | 2,240 | 2,212 (ratio 1.013) |
| Procedure section only, words | 445 | 417 |
| Deterministic gate | | PASS at a 1.01 floor |

The candidate removed conjunctions and a few restatements and nothing else; the procedure was
already terse and every sentence carried a rule or a citation. The semantic review and apply
steps were not run because the candidate was not worth applying. The skills are not compressed
and no wider run is scheduled: the generated skills are already dense, and the only large
saving available, dropping the Guidance sections, is forbidden by design.

What is kept:

- The tool lives at `.claude/skills/semantic-compressor/`, byte-identical to upstream v2.0.0
  (commit `f8082b57`), outside `src/aa-sdlc/`, so `build.ps1`, the embedded content, and the npm
  packages never carry it. Its run state (`.claude/semantic-compressor-work/`,
  `.claude/backups/`) is ignored by git. The text-convention lint excludes the vendored folder.
- `scripts/Test-SkillGuidance.ps1` runs in the unit tier and fails when any skill's guidance
  line differs from `docs/guidance.md`; `scripts/Sync-SkillGuidance.ps1` regenerates the
  section for every skill from the workflow data. The seven hand-written framework skills gained
  their Guidance sections from that sync; the other 45 were already byte-identical.
- The compressor is for prose we did not generate: a contributed skill, a plugin, an agent
  definition. Run it with a ratio floor near 1.1, list every guidance line under the inventory's
  `security_rules` so the gate holds them literal, and run `./test.ps1 -Tier unit` after apply.

## Consequences

- Editing `docs/guidance.md`, a guidance set, or a step's guidance now fails the unit tier until
  `Sync-SkillGuidance.ps1` has been run and the skills committed with the change.
- If the guidance text is ever to be shared rather than copied, that is a design change to the
  skill format (a supporting file per skill), not a compression, and needs its own record.
- Updating the tool is a copy of the upstream folder over the vendored one and a change to the
  commit named here.
