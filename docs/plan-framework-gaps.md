# Plan: Close the Framework Gaps

**Status:** drafted, awaiting review. Started 2026-09-21.

The framework review of 2026-09-21 found that the specification is coherent and validated but
that nothing executes it yet, and that the specification has outgrown the framing written for
it. This plan closes ten of those gaps in six phases. Each phase leaves the unit tier green and
is made of tasks small enough to be one commit each (O-17, G-39). Where a task needs a choice
the framework has not made, the task is to write the decision record (O-18) first.

## Scope

| # | Gap | Phase |
|---|-----|-------|
| 1 | Nothing runs: 47 steps have no skill, no CLI, no schemas, no target adapter | D, F |
| 2 | Health is the linchpin and does not exist | C |
| 3 | The framework's own tests are structural only; the scenarios have no executor | E |
| 4 | "Opinions are few" is no longer true; README and design framing have not kept up | A |
| 5 | Overlapping guidance, requirements, and opinions | A |
| 6 | Steps carry more guidance than a skill can hold | A |
| 7 | Stale framing text in guidance.md; vocabulary lacks terms the opinions depend on | A |
| 8 | Four requirements are cited by no step | A |
| 9 | Decision log row 39 was edited in place, against O-18 | A |
| 10 | The framework repository does not meet its own opinions (R-07, R-32, R-35, R-39) | B |

Out of scope here: the website (design section 10) and the commit hygiene of past sessions.
Both are noted in the review and can be planned separately.

## Working agreements while executing this plan

- One task, one commit. The agent stages and presents; the user commits (O-17, G-40).
- Every task ends with `./test.ps1 -Tier unit` green and, where workflow data changed,
  `./scripts/Build-DisciplineReview.ps1` run.
- Ids are never reused or renumbered. An item that is folded into another is marked
  *superseded by* and keeps its row.
- A task marked **decide** produces a decision record in `docs/decisions/` before any code.
- Sizes below are relative (S, M, L) and grounded in the tasks listed (O-10); they are not
  dates.

## Phase A: framing and consolidation

Documents and workflow data only. Do this first, because every skill written later will cite
these ids and every reader meets the framing before anything else.

| Task | What | Files | Acceptance | Size |
|------|------|-------|------------|------|
| A1 Group the opinions | Add group headings to `opinions.md` and keep the entries as they are: **the three systems** (O-02, O-03, O-04, O-09), **the shape of a repository** (O-05, O-06, O-07, O-16), **requirements** (O-01, O-15, O-20), **the delivery path** (O-11, O-12, O-24, O-25), **commits and history** (O-14, O-17, O-19, O-22), **tickets** (O-10, O-13), **practice** (O-08, O-18, O-21, O-23). Replace "Opinions are few" with a sentence about groups. Rewrite the README list as one line per group with the ids, linking to the document. Rewrite the design section 2 paragraph as one sentence per group. Fold the closing summary paragraph into the group headings. | `docs/opinions.md`, `README.md`, `docs/design.md` | README opinions block under 30 lines; design paragraph under 120 words; every O id still appears in all three documents; `Test-WorkflowStructure` still finds every id | M |
| A2 Consolidate overlapping ids | G-08 keeps "write the plan and get it confirmed before a multi-step change" and hands "one concern per commit, one ticket per branch" to G-39. G-10 is marked superseded by G-41; its citations move. R-08 is reworded as the ticket-reference pattern that R-28's footer uses, so the two do not both define the message. O-02 gains one sentence pointing to O-16 (what goes in) and O-17 (who commits). | `docs/guidance.md`, `docs/requirements.md`, `docs/opinions.md`, every step YAML citing G-08 or G-10 | Each guidance id has one job stated in one or two sentences; superseded rows say so; no step cites a superseded id; unit tier green | M |
| A3 Guidance sets | Add `src/aa-sdlc/workflow/guidance-sets/<set>.yaml`, each a named list of guidance and requirement ids with a one-line purpose: `anchored-step` (G-03, G-12, G-15, G-22, G-24, G-25, G-26; R-02), `repository-change` (G-01, G-06, G-08, G-09, G-11, G-33, G-37, G-39, G-40, G-42, G-44, G-45; R-01, R-05, R-09, R-28, R-31, R-33, R-35, R-36), `test-writing` (G-04, G-05, G-07, G-20, G-46; R-11, R-21, R-37). Steps gain `guidance_sets:` and keep only their extras in `guidance:` and `requires:`. The validator expands sets and checks set ids; the review generator prints the expanded lists; the skill validator compares against the expanded lists. | new `guidance-sets/`, every step YAML, `scripts/Test-WorkflowStructure.ps1`, `scripts/Build-DisciplineReview.ps1`, five `skills/fw/*/SKILL.md` | No step's explicit `guidance:` exceeds 10 ids; expanded citations are identical to today's (diff the regenerated review before and after: only presentation changes); unit tier green | L |
| A4 Stale text and vocabulary | Rewrite the guidance.md introduction as "the registry of shared guidance, cited by id from the steps that apply it". Add vocabulary entries: **Decision record**, **Environment file**, **Artifact identity**, **Definition of ready**, **Currency check**, **Guidance set**. Update the vocabulary list in `CLAUDE.md`. | `docs/guidance.md`, `docs/vocabulary.md`, `CLAUDE.md` | No "backlog" wording remains; each new term is used with that meaning in at least one opinion or step | S |
| A5 Cite every requirement | R-13 from `setup-environment` and `implement`; R-17 from `generate-tests`, `e2e-tests`, `uat`; R-14 and R-15 from `health` and `init`. Add a validator check: every R and G id is cited by at least one step or process, or its row is marked informational or superseded. | six step YAML files, `scripts/Test-WorkflowStructure.ps1` | Validator reports zero uncited ids; unit tier green | S |
| A6 Restore decision row 39 | Restore row 39 to its text at commit ee9041e and add a new row that records the O-10 reframing and supersedes 39. Add one sentence above the decision log: rows are immutable and are superseded, never edited (O-18). | `docs/design.md` | Row 39 matches `git show ee9041e:docs/design.md`; the new row cites 39 | S |

## Phase B: the framework repository meets its own opinions

Small, and best done while Phase A is fresh, because health (Phase C) will be run against
this repository first.

| Task | What | Files | Acceptance | Size |
|------|------|-------|------------|------|
| B1 Decision records | Create `docs/decisions/` with `TEMPLATE.md` (context, options, decision, consequences) and `0001-adopt-aa-sdlc.md`. Move nothing from the design decision log; it stays as the design's own history and the new folder starts at 0001. | `docs/decisions/` | Folder exists with template and record 0001; R-32 met for this repository | S |
| B2 Project config | Run the `/aa-fw-init` conversation for this repository by hand, as the skill in C5 will do it: ask the user which ticket project this repository maps to (O-09, R-22) and where its knowledge base is (O-04, R-03). When the user names a system and pastes a URL, look for a skill, MCP server, or CLI for that system already in the agent's scope (T-05), use it to confirm the project exists, and record the mapping. If the connector is absent or unauthorised, say so, record the mapping anyway, and expect health to report R-02 or R-03 unmet until it is authorised. Then write `aa.config.yaml` at the root per `formats.md`, including commit types (O-14) and the decisions folder (O-18). | `aa.config.yaml`, `docs/development-environment.md` | Config parses; R-07 met; R-22 met or recorded as degraded with the reason; the connector found or not found is recorded | S |
| B3 Lint switch | Add `-Lint` to `build.ps1`: run the PowerShell formatter in check mode and the PowerShell static analyser on `*.ps1`, and treat the three structural validators as the linters for YAML, feature, and markdown content. `initialize.ps1` installs the analyser. Write `docs/development-environment.md` recording which languages have a linter and that Gherkin and Markdown rely on the structural validators (R-12 warning expected). | `build.ps1`, `initialize.ps1`, `docs/development-environment.md` | `./build.ps1 -Lint` runs and exits non-zero on a seeded violation; R-35 met | M |
| B4 Environment settings | Record in `docs/development-environment.md` that this repository deploys nothing and has no environment files, so R-30's template check and R-39 are not applicable. | `docs/development-environment.md` | Health (Phase C) reports R-30 partially met and R-39 not applicable with that reason | S |

## Phase C: the health skill

Health is where the thirty-nine requirements stop being promises. Build it before any
discipline skill, because writing the probes will show which requirements are unrealistic.

| Task | What | Files | Acceptance | Size |
|------|------|-------|------------|------|
| C1 **decide** where health reads requirements from | The probes live in `features/requirements/*.feature` (decision 20, 31), which are not in the content package. Options: copy `features/requirements/` into the package at build; generate a `requirements.yaml` index from the feature files; or have the skill read the registry table. Record the choice. | `docs/decisions/0003-*.md`, possibly `build.ps1` | Decision record accepted; the package built by `build.ps1` contains what health reads | S |
| C2 Write the skill | `skills/fw/health/SKILL.md` with frontmatter matching `steps/health.yaml`. Procedure: aggregate requirement ids from every installed skill's `aa.requires` plus the registry; for each, perform the Detect in plain language; classify met, unmet, or not applicable; report grouped by kind with what depends on each; report the install (scope, version, target, skills present). Never change anything (T-10). Include the report format as a template. | `src/aa-sdlc/skills/fw/health/SKILL.md`, `.claude/commands/aa-fw-health.md` | `Test-SkillStructure` passes; running `/aa-fw-health` in this repository produces a report with a status for all 39 requirements | L |
| C3 Health feature file | `features/cli/health.feature` or `features/framework/health.feature`: aggregation, the three statuses, not-applicable reasons, never blocks, reports the install. | one feature file | At least five scenarios; `Test-FeatureStructure` passes | S |
| C4 Baseline this repository | Run health here and record the report in `docs/decisions/` or the development environment configuration as the baseline. Every unmet item must be explained by Phase B or by a task in this plan. | `docs/development-environment.md` | The baseline lists no unmet requirement that this plan does not address | S |
| C5 Write the `/aa-fw-init` skill | `skills/fw/init/SKILL.md` with frontmatter matching `steps/init.yaml`. Procedure per design 3.6: run health, propose each fixable unmet requirement, act on consent, list the rest with remedies, run health again. The ticket project and knowledge base are a conversation, not a lookup: ask the user; when they name a system and paste a URL, search the agent's scope for a skill, MCP server, or CLI for that system (T-05), confirm the project or space exists through it, and record the mapping in the project config; if nothing is in scope, or the connector is present but unauthorised, say exactly that, record the mapping anyway, and leave R-02 or R-03 for health to report. Never name a system the user did not name (T-01). Add the scenarios to `features/cli/init.feature` or a new `features/framework/fw-init.feature`: asked and answered with a URL, connector found, connector present but unauthorised, nothing in scope. | `src/aa-sdlc/skills/fw/init/SKILL.md`, `.claude/commands/aa-fw-init.md`, `steps/init.yaml` inline guidance, one feature file | `Test-SkillStructure` passes; running `/aa-fw-init` in this repository performs B2's conversation and writes the config; the four scenarios exist | M |

## Phase D: `aa init` and the CLI skeleton

The CLI is the delivery vehicle (decision 16). Most requirement remedies point at `aa init`,
so it is the first verb.

| Task | What | Files | Acceptance | Size |
|------|------|-------|------------|------|
| D1 **decide** the CLI language | A compiled native binary in Go, Rust, or .NET with native AOT; no Node or TypeScript anywhere in the repository. Criteria: a single static binary per platform, cross-compilation for the six common targets (Windows, macOS, Linux on x64 and arm64), startup time, and who will maintain it. Delivery stays npm per decision 16: the `aa-sdlc` package carries a per-platform optional dependency holding the binary, so `npm install -g aa-sdlc` works without any JavaScript of ours; winget, scoop, and brew can follow. Record the choice and the layout: `src/aa-sdlc-cli/` as its own project (O-05), content package copied in at pack time. | `docs/decisions/0004-*.md`, `docs/design.md` section 7.1 and 9 | Decision record accepted; design 7.1 says the npm package carries a native binary | S |
| D2 Schemas | JSON Schema for `aa.config.yaml`, `steps/<step>.yaml`, `disciplines/<id>.yaml`, `processes/<process>.yaml`, and `guidance-sets/<set>.yaml`. `Test-WorkflowStructure` validates against them in addition to its cross-reference checks. | `src/aa-sdlc/schemas/`, `scripts/Test-WorkflowStructure.ps1` | Every existing YAML file validates; a seeded bad key fails | M |
| D3 `aa init` | Implement every scenario in `features/cli/init.feature`: merged config, conventional folders, root script stubs with a lint switch, commit pattern and types, the one ticket project, the decision record folder with 0001, re-run safety, and the pointer to `/aa-fw-init` and `/aa-fw-health`. | `src/aa-sdlc-cli/` | Each init.feature scenario is executable in Phase E and passes | L |
| D4 `aa setup` for one target | Detect Claude Code, copy skills to user scope, render `.claude/commands/` from `steps/*.yaml`, write the user config. Other targets remain open. | `src/aa-sdlc-cli/`, `src/aa-sdlc/targets/claude-code/` | After `aa setup`, `/aa-fw-health` is available in a fresh Claude Code session | L |
| D5 Pack and install | `pack.ps1` cross-compiles the binary for each platform target, builds one npm package per platform holding its binary, and builds the `aa-sdlc` package that lists them as optional dependencies and carries the content package. No postinstall download. | `pack.ps1`, `src/aa-sdlc-cli/`, per-platform package manifests | A fresh machine on any of the six targets can `npm install -g` from the `.dist/` output and run `aa init`; the installed tree contains no JavaScript written in this repository beyond a package manifest | M |

## Phase E: executable framework tests

Until this phase, the three hundred and twenty-six scenarios are a readable contract. This
makes the CLI subset run, and says honestly which subset stays agent-only.

| Task | What | Files | Acceptance | Size |
|------|------|-------|------------|------|
| E1 **decide** the executor and the split | Options: a Node feature-file runner driving the `aa` CLI for `features/cli/`; Pester-based step definitions; or no executor. Tag scenarios `@cli` (executable against the CLI), `@health` (executable inside an agent, verified by recorded transcript), `@agent` (contract only). Record the choice and the tagging. | `docs/decisions/0005-*.md`, every feature file's tags | Decision record accepted; every scenario carries exactly one of the three tags | M |
| E2 Wire the tiers | Integration tier runs the `@cli` scenarios against the built CLI in a temporary folder; e2e tier runs `aa setup` then `aa init` on a fresh clone of a sample repository and checks the result. `test.ps1` reports executed, pending, and contract-only counts. | `test.ps1`, `tests/integration/`, `tests/e2e/`, step definitions | `./test.ps1 -Tier integration` executes every `@cli` scenario; R-17 met for the CLI subset; O-07 tiers non-empty | L |
| E3 Transcript checks for `@health` | A recorded run of `/aa-fw-health` in this repository is stored under `tests/e2e/` and compared for shape (all requirement ids present, each with a status). | `tests/e2e/` | The check fails when a requirement id is missing from the report | M |

## Phase F: discipline skills

Forty-seven skills, generated from the workflow data so they cannot drift from it, then
completed by hand. Order follows the development loop first, because it is what every other
discipline hands off to.

| Task | What | Files | Acceptance | Size |
|------|------|-------|------------|------|
| F1 Scaffold generator | `scripts/New-SkillScaffold.ps1 -Step <id>` writes `skills/<discipline>/<step>/SKILL.md` with frontmatter from the step YAML, sections for precondition and anchor, inputs, procedure, artifacts with acceptance, guidance expanded from sets, and report. The five framework skills are regenerated through it to prove the shape. | `scripts/New-SkillScaffold.ps1`, five existing skills | Regenerated framework skills differ from today's only in generated sections; `Test-SkillStructure` passes | M |
| F2 Development loop | `plan-implementation`, `implement`, `review`, `finish-branch`, `fix-bug`, `refine-ticket`, `setup-environment`: scaffold, then write the procedure by hand against the step's guidance. One skill per commit. | seven skills, seven command wrappers | Each skill runs in this repository against a sample ticket and produces the artifact its step names | L |
| F3 Feature files for discipline steps | One `features/<discipline>/<step>.feature` per step written in F2, three scenarios minimum, tagged `@agent` per E1. Extend as skills are written. | `features/<discipline>/` | `Test-FeatureStructure` passes; each step has a feature file before its skill is marked done | M |
| F4 Remaining disciplines | In discipline order from `plan-discipline-review.md`: Product Management, Business Analysis, UX Design, Technical Analysis, Security, Refinement, Project Management, Implementation Planning, Testing, Documentation, Release Management, Operations, Support, then `init` and `extend`. Scaffold, write, feature file, one skill per commit. | 40 skills | 52 skills exist; `docs/discipline-review.md` regenerated; every step has a feature file | L |

## Dependencies and order

```
A ──┬──> C ──> D ──> E
    │             └──> F (needs A3 for guidance sets and C for the pattern)
    └──> B (small; do alongside A, before C4)
```

Phase A first, because it is cheap and everything later cites what it settles. B alongside A.
C before D so the requirements are honest before a CLI writes remedies for them. D before E
because E executes D. F last, and after A3, so that no skill is written against a guidance
list that is about to be restructured.

## Progress

| Phase | Task | Status |
|-------|------|--------|
| A | A1 to A6 | done 2026-09-22 (commits cee232d to 04fd5a5) |
| B | B1 to B4 | done 2026-09-22 (0a9a6bf, 6aae2c5, bd4b2c2; B4 folded into B3's document) |
| C | C1 to C5 | not started |
| D | D1 to D5 | not started |
| E | E1 to E3 | not started |
| F | F1 to F4 | not started |
