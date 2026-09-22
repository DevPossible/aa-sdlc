# Requirements Registry

**Status:** working draft. Last updated 2026-09-21.

A requirement is a capability or condition that a step, process, or piece of guidance depends on
in order to be performed (see the [vocabulary](vocabulary.md)). Guidance is written at the
category level ("format changed files before committing"), so the framework must say what that
guidance needs ("a formatter that can run on a list of files") and check for it, rather than
leaving the agent to discover the gap the first time the step runs (tenet T-11).

**This document is an index.** Per T-12 and O-01, the authoritative definition of each
requirement is its scenarios in [`features/requirements/`](../features/requirements/). Where a
table row and a feature file disagree, the feature file wins and the row is corrected.

Requirements are declared where they arise (in guidance, in a skill's frontmatter, in a plugin,
in a process) and aggregated by `/aa-fw-health`, which probes each one and reports. `/aa-fw-init` brings
a project up to the requirements it can fix. Neither names a tool: a requirement names a
category, and the agent infers the concrete tool from the project (T-01). Plugins may declare
requirements that do name tools, because that is what plugins are for.

## Shape of a requirement

| Field | Meaning |
|-------|---------|
| ID | stable `R-nn` |
| Requirement | one sentence, category-level |
| Kind | `environment` (what the agent can reach), `project` (what the repo contains), `tooling` (what the project supplies), `coverage` (what skills are in scope) |
| Level | `required` (steps depending on it degrade), `recommended` (steps work but worse), `informational` (affects enforcement only) |
| Needed by | the guidance, steps, or tenets that depend on it |
| Detect | how `/aa-fw-health` establishes whether it is met, in plain language the agent can act on |
| Remedy | what `/aa-fw-init` can do, or what the user must do |

## Environment: what the agent can reach

| ID | Requirement | Level | Needed by | Detect | Remedy |
|----|-------------|-------|-----------|--------|--------|
| R-01 | A source control system the agent can commit to, branch on, and open merge requests against. | required | T-04, G-09, G-11, `finish-branch`, `review` | The agent has a CLI, MCP server, or connector for source control and can reach the project's remote. | User installs or authorises the connector. |
| R-02 | A ticket system the agent can read and update. | required | T-04, G-12, G-16, every step's anchor | The agent has a CLI, MCP server, or connector for a ticket system and can read a ticket by ID. | User installs or authorises the connector; until then steps produce local artifacts. |
| R-03 | A knowledge base the agent can read and write. | recommended | T-04, G-10, `architect`, `maintain-docs` | The agent has a CLI, MCP server, or connector for a wiki or notes system. | User installs or authorises the connector; until then decisions go in the repo docs folder (R-06). |
| R-04 | A way to execute code or a tool for calculation. | required | G-02 | The agent has a shell, code runner, or calculator tool available. | User enables a code execution tool for the agent. |

## Project: what the repository contains

| ID | Requirement | Level | Needed by | Detect | Remedy |
|----|-------------|-------|-----------|--------|--------|
| R-05 | The project is under source control with a configured remote. | required | T-04, G-11, all Development steps | A repository is initialised at the project root and has at least one remote. | `/aa-fw-init` initialises the repository; the user supplies the remote. |
| R-06 | A documents folder exists for repo-resident artifacts (decision records, runbooks, generated docs). | required | G-10, `architect`, `maintain-docs`, `setup-infrastructure` | A documents folder exists at the conventional location for the project, or the project config names one. | `/aa-fw-init` creates it. |
| R-07 | An AA-SDLC project configuration exists. | required | every step, scope merging, `/aa-fw-health` | The config file exists at the project root and parses. | `/aa-fw-init` creates it from the merged user, team, and enterprise scopes. |
| R-08 | Conventions for referencing the anchor ticket in branch names and commit messages are defined. | recommended | G-09, `finish-branch` | The project config, or the ticket system, defines a ticket reference pattern. | `aa init` writes a default pattern into the project config. |
| R-16 | A features folder exists for the project's Gherkin feature files. | required | T-12, O-01, G-07, G-18, `discover`, `refine-requirements`, `generate-tests` | A features folder exists at the conventional location, or the project config names one. | `aa init` or `/aa-fw-init` creates it. |
| R-22 | The project config names exactly one ticket system project (or group) for the repository, and every ticket the repository anchors on belongs to it. | required | O-09, O-03, G-22, G-27, every anchored step, `triage`, `plan-work` | The merged config has one `conventions.ticket.project` value, and a sample of tickets referenced in the repository's branches and commits resolve within that project. | `aa init` asks for the project and writes it; `/aa-fw-init` reports references to other projects for the user to relink. |
| R-18 | The repository follows the conventional folder structure: documents, features, scripts, source (one subfolder per project), tests, and root scripts. | required | O-05, `setup-environment`, `/aa-fw-init` | Each conventional folder exists at the root, or the project config maps its equivalent. | `aa init` creates the missing folders; `/aa-fw-init` proposes mappings for an existing layout. |

## Tooling: what the project supplies

| ID | Requirement | Level | Needed by | Detect | Remedy |
|----|-------------|-------|-----------|--------|--------|
| R-09 | A formatter for each language in the project that can be run on a list of files. | required | G-01 | For each language detected in the project, a formatter configuration or a format script exists and runs. | `/aa-fw-init` reports which languages have no formatter; the user, or a tech-stack plugin, supplies one. |
| R-10 | A root `build` script that builds every project in the repository from a fresh clone. | required | O-06, G-04, `implement`, `review` | A `build` script exists at the repository root and completes. | `aa init` creates a stub that names what it must do; the user, or a tech-stack plugin, fills it in. |
| R-11 | A root `test` script that runs the repository's tests and accepts a tier filter. | required | O-06, O-07, O-08, G-04, G-05, G-07, all Testing steps | A `test` script exists at the repository root, runs even against zero tests, and accepts a tier parameter (unit, integration, e2e). | `aa init` creates a stub; the user, or a tech-stack plugin, fills it in. |
| R-19 | A root `initialize` script that bootstraps the environment and seeds data as needed. | required | O-06, `setup-environment` | An `initialize` script exists at the repository root and completes on a fresh clone. | `aa init` creates a stub; the user fills it in. |
| R-20 | A root `pack` script that produces the repository's distributable artifacts. | required | O-06, `release` | A `pack` script exists at the repository root and completes after `build` and `test`. | `aa init` creates a stub; the user, or a tech-stack plugin, fills it in. |
| R-21 | Unit, integration, and end-to-end tests each have a home in the repository and are selectable by tier. | required | O-07, O-08, G-20, G-21, `implement`, `generate-tests`, `e2e-tests` | Unit tests exist with each project, integration and end-to-end tests exist in the tests folder, and the `test` script can run each tier alone. | `aa init` creates the tests folder with a subfolder per tier; the user, or a tech-stack plugin, supplies the runners. |
| R-12 | A linter or static analyser for each language in the project. | recommended | `review` | For each language detected, a linter configuration exists and runs. | `/aa-fw-init` reports which languages have none. |
| R-17 | A tool that can execute the project's feature files. | recommended | T-12, O-01, G-07, `generate-tests`, `uat` | A feature-file executor is configured and runs, even against zero scenarios. | `/aa-fw-init` reports it missing; the user, or a tech-stack plugin, supplies one. Feature files remain the source of truth without it. |

## Coverage: what skills are in scope

| ID | Requirement | Level | Needed by | Detect | Remedy |
|----|-------------|-------|-----------|--------|--------|
| R-13 | Every major technology in the project's stack has a skill in scope. | recommended | T-02, `implement`, `generate-tests`, `setup-pipeline` | Detect the stack from project files (language, framework, build system, database, infrastructure). For each, check whether an installed tech-stack plugin, a project skill, or a skill already in the agent's scope covers it. | `/aa-fw-init` lists uncovered technologies and the available tech-stack plugins; the user chooses. |
| R-14 | The target supports commands. | informational | all commands | The target has a command or slash-command concept. | None needed; the meta skill routes by intent instead. |
| R-15 | The target supports hooks. | informational | T-09, enforcement of G-01 and G-14 | The target has a hook concept. | None needed; the practice is guided rather than enforced. |

## How requirements flow

```
Guidance / Skill / Plugin / Process
        declares  ─────►  Requirement (R-nn)
                                │
                     aa-health  aggregates every declared requirement
                                probes each one (Detect)
                                reports met / unmet / not applicable, and what depends on each
                                │
                     aa-init    takes the unmet, fixable ones (Remedy)
                                fixes them with the user's consent
                                re-runs aa-health
```

- A requirement is declared once here and referenced by ID everywhere else.
- Guidance that depends on a requirement names it in its `Requires` column.
- A skill lists its requirements in `SKILL.md` frontmatter so `/aa-fw-health` can read them from
  the installed set rather than from this document.
- Plugins add requirements in their own numbered range and may name tools.
- Detection is written in plain language because `/aa-fw-health` is itself a skill: the agent performs
  the probe with whatever it has. Targets that support scripts may add mechanical probes in
  `targets/<target>/`.
