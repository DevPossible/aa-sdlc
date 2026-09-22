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

The Go toolchain for the `aa` CLI will be added here when the CLI project lands (decision
record 0004, plan task D3). Nothing else is required. There is no seed data.

## Conventions enforced by tools (O-21)

| Language or format | Formatter | Linter | Runs from |
|--------------------|-----------|--------|-----------|
| PowerShell (`*.ps1`, `*.psd1`) | PSScriptAnalyzer `Invoke-Formatter`, settings in `PSScriptAnalyzerSettings.psd1` | PSScriptAnalyzer `Invoke-ScriptAnalyzer`, same settings | `./build.ps1 -Lint` |
| Workflow YAML (`src/aa-sdlc/workflow/**`) | none known; hand-formatted, two-space indent, flow lists for ids | `scripts/Test-WorkflowStructure.ps1` (shape, ids, cross-references) | `./build.ps1`, `./test.ps1 -Tier unit` |
| Gherkin (`features/**`) | none known | `scripts/Test-FeatureStructure.ps1` (one Feature, scenarios with Then and Given or When) | `./build.ps1`, `./test.ps1 -Tier unit` |
| Markdown (`docs/**`, `README.md`, `SKILL.md`) | none known; 100-column wrap by convention | `scripts/Test-SkillStructure.ps1` for `SKILL.md` frontmatter; otherwise none | `./build.ps1`, `./test.ps1 -Tier unit` |

Per R-12, health warns that YAML, Gherkin, and Markdown have no linter beyond the structural
validators. That warning is expected and recorded here; it does not block.

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
| GitLab remote | `git remote` | git CLI | R-01 and R-05 met |

## Test tiers (O-07)

| Tier | Home | Today |
|------|------|-------|
| unit | `scripts/Test-*.ps1` via `./test.ps1 -Tier unit`, plus Pester tests under `src/` | structural validators; no Pester tests yet |
| integration | `tests/integration/` | empty, planned in plan task E2 |
| e2e | `tests/e2e/` | empty, planned in plan task E2 |

R-17 (a feature-file executor) is unmet for this repository; the choice of executor is plan
task E1.
