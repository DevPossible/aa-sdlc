# Development Environment

**Status:** current. Last updated 2026-09-22.

What a fresh clone of this repository needs beyond what `./initialize.ps1` installs, which
tools enforce its conventions, and which framework requirements do not apply here and why. This
is the document O-16 and O-21 call the development environment configuration; `/aa-fw-health`
reads it to tell a recorded exception from an unexplained gap.

## What initialize installs

| Tool | For | Installed how |
|------|-----|---------------|
| Pester | the test tiers | PowerShell module, current user |
| powershell-yaml | the structural validators and the review generator | PowerShell module, current user |
| PSScriptAnalyzer | `./build.ps1 -Lint`: formatter check and static analysis of every `*.ps1` | PowerShell module, current user |
| Go toolchain (1.26 or later) | building and testing the `aa` CLI in `src/aa-sdlc-cli/` (decision record 0004) | winget `GoLang.Go` |

Nothing else is required. There is no seed data. `go mod tidy` fetches the module's one
dependency, a YAML library, from the Go module proxy on first build.

## Conventions enforced by tools (O-21)

| Language or format | Formatter | Linter | Runs from |
|--------------------|-----------|--------|-----------|
| PowerShell (`*.ps1`, `*.psd1`) | PSScriptAnalyzer `Invoke-Formatter`, settings in `PSScriptAnalyzerSettings.psd1` | PSScriptAnalyzer `Invoke-ScriptAnalyzer`, same settings | `./build.ps1 -Lint` |
| Go (`src/aa-sdlc-cli/**`) | `gofmt` | `go vet` | `./build.ps1 -Lint` |
| JavaScript (`src/aa-sdlc-cli/npm/aa-sdlc/bin/aa.js`, the one launcher file, decision record 0004) | none adopted for one file | none adopted; `node --check` at pack time | `./pack.ps1` |
| Workflow YAML (`src/aa-sdlc/workflow/**`) | text-convention check in `build.ps1 -Lint`: LF, no tabs, no trailing whitespace, final newline, two-space indent (decision record 0006) | `scripts/Test-WorkflowStructure.ps1` (shape, ids, cross-references) | `./build.ps1`, `./test.ps1 -Tier unit` |
| Gherkin (`features/**`) | text-convention check in `build.ps1 -Lint` (decision record 0006) | `scripts/Test-FeatureStructure.ps1` (one Feature, scenarios with Then and Given or When) | `./build.ps1`, `./test.ps1 -Tier unit` |
| Markdown (`docs/**`, `README.md`, `SKILL.md`) | text-convention check in `build.ps1 -Lint` (decision record 0006); 100-column wrap by convention | `scripts/Test-SkillStructure.ps1` for `SKILL.md` frontmatter; otherwise none | `./build.ps1`, `./test.ps1 -Tier unit` |

Per R-12, health warns that YAML, Gherkin, and Markdown have no linter beyond the structural
validators. That warning is expected and recorded here; it does not block. `.gitattributes`
fixes LF line endings for every text file so the convention check does not fight the checkout.

## Skill authoring aids

| Aid | Where | Use |
|-----|-------|-----|
| `scripts/Sync-SkillGuidance.ps1` | this repository | Regenerates every skill's Guidance section from the workflow data and `docs/guidance.md`. Run after editing guidance, a guidance set, or a step's guidance; `scripts/Test-SkillGuidance.ps1` in the unit tier fails until you do. |
| `semantic-compressor` skill (v2.0.0, vendored) | `.claude/skills/semantic-compressor/`, invoked as `/semantic-compressor` in a Claude Code session on this repository | Fail-closed compression of skill or agent Markdown. For contributed or plugin prose, not the generated core skills, which measured at a 1.01 ratio (decision record 0011). Use `--min-word-ratio 1.1`, list guidance lines under `security_rules` in the inventory, and run `./test.ps1 -Tier unit` after any apply. Never installed for consumers: it sits outside `src/aa-sdlc/`. |

## Secrets (G-38)

None. This repository holds no credentials and needs none to build, test, or pack. The ticket
system and knowledge base are reached through whatever connector the agent already has
(decision record 0002); their credentials live with the connector, never here.

## Deployed environments

None. This repository produces a package (`./pack.ps1` into `.dist/`); it deploys nothing and
runs nothing in an environment. Therefore:

- R-30's configuration-template check does not apply: there are no environments to template.
  The rest of R-30 (migrations, automation, runbooks) applies and is met by the root scripts
  and this document; there are no migrations.
- R-39 (environment settings apart from functional settings) is not applicable.
- R-38 (build once, promote) applies to the package: `pack.ps1` builds the artifact once and
  the release publishes that artifact; there is no per-environment rebuild.

## Connectors in scope (T-05)

| System | Recorded in | Connector at last check | Consequence |
|--------|-------------|-------------------------|-------------|
| Jira project AA | `aa.config.yaml` `conventions.ticket` | Atlassian connector present in the session; devpossible site not granted to it | R-02 and R-22 report unmet until the site is granted; steps produce local artifacts meanwhile |
| Confluence space AS | `aa.config.yaml` `conventions.knowledge` | same connector, same state | R-03 reports unmet until granted; decisions are in `docs/decisions/` regardless |
| GitLab remote | `git remote` | git CLI | R-01 and R-05 met; the pipeline runs here and nowhere else |
| GitHub mirror `DevPossible/aa-sdlc` | GitLab push mirror, protected branches only | none needed; GitLab pushes | private until the licence is chosen; never push to it directly |
| Azure DevOps `OpenSource/aa-sdlc` | GitLab push mirror, every branch | none needed; GitLab pushes | backup only; no pipeline definition may exist there. The mirror authenticates with an Azure DevOps personal access token named `gitlab-mirror-aa-sdlc` (scope: code write) that expires on 2027-09-21; when the mirror reports an authentication error, create a new token with the same scope and update the mirror URL in GitLab (Settings, Repository, Mirroring) |

## Test tiers (O-07)

| Tier | Home | Today |
|------|------|-------|
| unit | `scripts/Test-*.ps1` via `./test.ps1 -Tier unit`, plus the Go tests in `src/aa-sdlc-cli/` | structural and schema validators; the website currency check against the committed HEAD of `website-aasdlc-com` when it is checked out beside this repository (decision records 0007 and 0010), skipped with a warning otherwise; Go tests for config merging, `aa init`, `aa update`, and `aa plugin` |
| integration | `tests/integration/`: godog executes `features/cli/*.feature` (`@cli`) against the built binary | 26 scenarios: 25 pass, 1 pending (a second target does not exist yet) |
| e2e | `tests/e2e/`: Pester installs the packed npm tarballs into a temporary prefix and runs `aa setup` and `aa init`; also checks the health baseline names every requirement | 5 tests |

R-17 (a feature-file executor) is met for the `@cli` subset by godog (decision record 0005).
`@health` scenarios are verified through the health baseline below; `@agent` scenarios are
contracts and are reviewed, not executed.

## Health baseline, 2026-09-22

The first run of `/aa-fw-health` against this repository, performed by following the skill by
hand (plan task C4). Install: target Claude Code, project scope, package at commit bd4b2c2,
7 skills of 52 steps (framework 7 of 8; every other discipline 0), 7 commands, no plugins.
Every unmet item below is addressed by a plan task or accepted here with a reason.

### Required and unmet

| Id | Status | How probed | Addressed by |
|----|--------|------------|--------------|
| R-02 | unmet | Atlassian connector present in the session; the devpossible site is not granted to it, so no ticket could be read | user authorises the connector for the site (decision 0002) |
| R-22 | unmet | config names project AA; no connector could confirm the project exists, and no branch or commit references a ticket yet | same connector authorisation; first ticket-anchored work |
| R-28 | unmet | 14 of the last 15 commits parse against the configured pattern; fea5773 does not | accepted: history is not rewritten; every commit since conforms |
| R-31 | unmet | 17 commits before 2026-09-22 carry an agent attribution trailer; fea5773 bundles nine concerns | accepted: history is not rewritten; the rule has held since O-17 |
| R-33 | unmet | no commit on the default branch references a ticket | first ticket-anchored work after the connector is authorised |

### Everything else

| Id | Status | How probed |
|----|--------|------------|
| R-09 | met | PowerShell and Go by their formatters; YAML, Gherkin, Markdown, and JSON by the text-convention check in `build.ps1 -Lint` (decision record 0006) |
| R-01 | met | `git ls-remote` read main on the GitLab remote |
| R-03 | unmet (recommended) | same connector state as R-02; Confluence space AS recorded |
| R-04 | met | PowerShell 7.6.6 shell |
| R-25 | met | `docker --version` reported Docker 29.7.2 |
| R-05, R-06, R-07, R-08, R-16, R-18 | met | remote present; `docs/`, `features/`, `scripts/`, `src/`, `tests/` exist; `aa.config.yaml` parses; ticket pattern `AA-\d+` |
| R-10, R-11, R-19, R-20 | met | `build.ps1`, `test.ps1 -Tier unit`, `initialize.ps1 -SkipTools`, and `pack.ps1 -SkipTests` each ran to completion |
| R-21 | met | unit runs from `test.ps1`; `tests/integration/` and `tests/e2e/` exist and are empty, which O-07 allows |
| R-32 | met | `docs/decisions/` holds 0001 to 0003, contiguous, dated, four sections, no edits after acceptance |
| R-35 | met | `build.ps1 -Lint` passed on 8 scripts and failed on a seeded alias violation |
| R-12 | unmet (recommended) | no linter beyond the structural validators for YAML, Gherkin, Markdown; recorded above |
| R-17 | met for the `@cli` subset | godog runs `features/cli/*.feature` in the integration tier (decision record 0005); `@agent` scenarios have no executor by design |
| R-13 | unmet (recommended) | PowerShell has a skill in the user's scope; YAML, Gherkin, and Markdown have none dedicated |
| R-14, R-15 | present | Claude Code supports commands and hooks; guidance G-01, G-14, G-33, G-40 are enforceable here once hooks are installed (plan task D4) |
| R-23, R-27 | not applicable | no tickets are reachable to sample |
| R-24, R-38 | met | `.gitlab-ci.yml` calls only the root scripts (`build.ps1 -Lint`, `test.ps1`, `pack.ps1`) and `pack.ps1` builds the artifact once; pipeline 8488 on the remote passed both stages (verify 1m08s, pack 1m24s) at commit 59ce81c on 2026-09-22 |
| R-26, R-39 | not applicable | recorded above: no deployed system, no environments |
| R-29 | not applicable | no user interface |
| R-30 | met where applicable | root scripts and this document; no environments to template, no migrations, no manual operations |
| R-34 | not applicable | no architecture document; `architect` has not run |
| R-36 | not applicable | the only ecosystem is PowerShell modules, which have no manifest or lock file here |
| R-37 | not applicable | no automated tests exist yet to run twice |
