# AA-SDLC SDK: Design

**Status:** working draft, under active brainstorming. Last updated 2026-09-21.

This document captures the design decisions made so far for the AA-SDLC SDK. It is deliberately
opinionated where a decision has been made and explicit where one has not. See
[Open questions](#12-open-questions) at the end.

## 1. What this is

AA-SDLC (Agent Assisted Software Development Life Cycle) started as a methodology published at
aasdlc.com. The SDK is the concrete implementation of that methodology as a set of agent skills
and commands. The methodology says *what* a well-run agent-assisted project produces at each step
and *why*. The SDK gives an agent the *how*.

The relationship is one-directional: the skills implement the methodology, the methodology does
not depend on the skills. The website pivots to lead with the SDK and keep the methodology as the
backing reference.

**Naming.** The brand is **AA-SDLC**, the npm package and repository are `aa-sdlc`, the CLI is
`aa`, and every in-agent command is `/aa-<code>-<step>`. The website domain stays aasdlc.com.

**Delivery.** The SDK ships as an npm package. Installing it globally provides the `aa` CLI,
which drives all framework tooling: installing skills and commands into a target, updating,
and managing plugins. `aa setup` bootstraps the machine and is the main verb; `aa init`
bootstraps a repository.

```
npm install -g aa-sdlc
aa setup                          # once per machine
cd c:\dev\myproject
aa init                           # once per repository

# or, without changing directory
aa init -path c:\dev\myproject
```

Health is deliberately not a CLI verb. It belongs to the agent alone, as `/aa-fw-health`.

Reference projects the SDK is deliberately similar to:

- **BMAD-METHOD** (bmad-code-org): whole-lifecycle coverage, installer, multi-IDE targeting,
  expansion packs.
- **superpowers** (obra): small, sharp behavioural skills, a meta skill that routes to them, and
  a plugin-style install.

## 2. Tenets and vocabulary

The principles that govern the SDK's design are the **tenets**, kept in [tenets.md](tenets.md)
and cited by ID (T-01 to T-11). The terms used throughout are defined in
[vocabulary.md](vocabulary.md). In one line: tenets govern everything; **disciplines** group
skills by kind of work; a **process** is an ordered set of **steps** toward a goal; each step is
delivered as a **skill** and invoked by a **command**; **guidance** is the specific advice
attached to a step or process; a **requirement** is what a step or its guidance needs in order
to be performed. Guidance not yet attached to a step is tracked in [guidance.md](guidance.md);
requirements are registered in [requirements.md](requirements.md) and defined authoritatively
as feature files under [`features/`](../features/).

The framework is opinionated, and its **opinions** are stated up front in
[opinions.md](opinions.md): requirements are Gherkin; every project uses source control, a
ticket manager, and a knowledge repository; every repository shares one folder structure and
has root scripts for initialize, build, test, and pack; every repository has unit, integration,
and end-to-end tests; and Development proves the requirement while Testing goes beyond it.

## 3. Architecture

### 3.1 Disciplines

Skills are grouped by discipline, the kind of work they perform. Current disciplines:

| Discipline | id | code | Kind of work |
|------------|----|------|--------------|
| Business Analysis | `business-analysis` | `ba` | discovering, capturing, and validating what the business needs; user acceptance |
| Product Management | `product-management` | `pd` | roadmap, prioritisation, feedback analysis, deciding what to build next |
| UX Design | `ux-design` | `ux` | user research, mockups, prototypes, interaction review |
| Technical Analysis | `technical-analysis` | `ta` | architecture, technology choices, decision records |
| Refinement | `refinement` | `rf` | turning requirements into a well-formed, prioritised backlog of tickets |
| Implementation Planning | `implementation-planning` | `ip` | planning how a single ticket will be built before building it |
| Development | `development` | `dev` | building, reviewing, and merging code, and proving each requirement is met with unit, integration, and happy-path end-to-end tests (O-08) |
| Testing | `testing` | `qa` | making the test suite as comprehensive as is reasonable: beyond the stated requirement, to find gaps in understanding and in user interaction (O-08) |
| Security | `security` | `sec` | threat modelling, security testing, dependency and secret hygiene, compliance maintenance |
| Documentation | `documentation` | `doc` | keeping the knowledge base and repo docs true |
| Release Management | `release-management` | `rel` | versioning, release notes, change coordination, go/no-go, deployment to production, rollback |
| Operations | `operations` | `ops` | infrastructure, pipelines, observability, production validation |
| Support | `support` | `sup` | incident triage, incident response, user-facing follow-up |
| Project Management | `project-management` | `pm` | coordination and retrospectives |

Every discipline has a short code, two characters where a natural one exists and three where
readability wins (`dev`, `sec`, `doc`, `rel`, `ops`, `sup`). The code is the middle segment of
every command in that discipline: `/aa-qa-generate-tests`, `/aa-dev-implement`,
`/aa-rel-release`. The framework itself has the code `fw`, so its own commands are
`/aa-fw-health`, `/aa-fw-init`, `/aa-fw-extend`, and the authoring commands `/aa-fw-new-*`: the rule has no exceptions. Plugins reuse
the code of the discipline they extend.

Fourteen is deliberately more than a small team has people for. A discipline is a kind of
work, not a headcount (T-13): a solo developer on a personal project and a fifteen-person team
with distinct roles run the same steps and produce the same artifacts, and differ only in who
performs which discipline. What matters is that every common kind of work has a named home, so
its steps and guidance have somewhere to live and `/aa-fw-health` has something to report coverage
against.

### 3.2 Processes and steps

A step is one self-contained unit of work in one discipline. It produces named artifacts with the
acceptance criteria from the methodology and records its outcome on the anchor ticket. Every step
has a skill and a command, and every step runs standalone (T-03).

A process is an ordered set of steps toward a goal, drawn from any disciplines. The methodology's
six phases are the core processes. Smaller processes ("deliver a ticket", "ship a release") are
expected, and plugins may add more. Processes are defined as data in `src/aa-sdlc/workflow/`.

### 3.3 Guidance

Guidance is the specific, actionable advice on how best to perform a step or process. It lives in
the skill for its step or in the process definition, is written against tool categories only
(T-01), and is cited by ID. Guidance replaces the earlier idea of separate "discipline skills"
for behaviour: the behaviour is attached where it applies rather than held in a parallel layer.

### 3.4 Meta skill

`aa-sdlc` (working name): explains the SDK to the agent, describes the disciplines and processes
at a glance, and routes to the right step for the task at hand. Modelled on superpowers'
`using-superpowers`.

### 3.5 Requirements

Guidance is written at the category level, so it can name a capability the project does not
have. Rather than leave the agent to discover that gap mid-step, anything that depends on a
capability declares it as a **requirement** (T-11). Requirements are registered in
[requirements.md](requirements.md) in four kinds:

| Kind | What it covers | Examples |
|------|----------------|----------|
| environment | what the agent can reach | source control, a ticket system, a knowledge base, code execution |
| project | what the repository contains | under source control with a remote, a documents folder, an AA-SDLC config |
| tooling | what the project supplies | a formatter per language, a build command, a test runner |
| coverage | what skills are in scope | every major technology in the stack has a skill in scope |

Each has a level (required, recommended, informational), a plain-language detection method, and
a remedy. Skills list their requirements in `SKILL.md` frontmatter; plugins add their own and may
name tools.

The framework's requirements are themselves feature files (T-12): `features/requirements/`
holds one scenario pair per requirement describing how `/aa-fw-health` detects it as met or unmet
and what the remedy is, and `features/cli/` and `features/agent/` describe each verb and
command. The registry tables index those files and defer to them.

### 3.5a Requirements as Gherkin, and the three-way link

Every project using the framework keeps its requirements as feature files in the repository,
and those files are the source of truth for what the software must do (T-12, O-01). Each
scenario is tagged with its anchor ticket, and each feature names its knowledge base page. The
tooling maintains the relationship in every direction:

| Change made in | The tooling |
|----------------|-------------|
| the feature file | updates the ticket's acceptance criteria and the knowledge base page, and records the change on the ticket |
| the ticket alone | reports a conflict with the feature file and lets the user decide; never rewrites either side |
| the knowledge base page alone | reports a conflict with the feature file and lets the user decide; never rewrites either side |

The steps that own this are `discover` and `refine-requirements` (write scenarios),
`plan-work` (link scenarios to tickets), `generate-tests` (scenarios become the business-facing
tests), and `maintain-docs` (keep the pages aligned). The ticket system stays the truth for
work state and the knowledge base for decisions; feature files are the truth for requirements.

### 3.6 Health and init

`/aa-fw-health` aggregates every requirement declared by the installed skills, plugins, and
processes, probes each one, and reports which are met, unmet, or not applicable, and what
depends on each. It also reports the install itself: scope, version, target, skills and
commands present, update available. It never blocks and never changes anything (T-10).

`/aa-fw-init` bootstraps a project. It runs health, then fixes the unmet requirements it can fix
(initialise the repository, create the documents folder, write the project config, set default
conventions) with the user's consent, lists the ones it cannot (a missing formatter, an
uncovered technology) with the available remedies, and re-runs health. It is the first thing
`aa init` tells the user to run in their agent. Helping a project get bootstrapped is a core job of the
framework, not an afterthought.

Health exists only inside the agent. The probes that matter most (can the agent actually reach
the ticket system, the knowledge base, and source control; which skills are in its scope) can
only be performed by the agent, so a CLI health verb would give a partial answer under the same
name as the real one. The CLI therefore has no `health` verb.

Init exists in both places with distinct jobs. `aa init` on the CLI lays down what needs no
agent: the project config, the documents folder, project-scope skills and commands. `/aa-fw-init`
inside the agent runs `/aa-fw-health`, then works through the unmet requirements that need
judgement, such as a language with no formatter or a technology with no skill in scope.

## 4. Methodology to step map

The methodology has six phases and 23 steps plus a quarterly meta-process (see the website's
workflow page, mirrored in `src/aa-sdlc/workflow/`). The phases become the core processes. Each
methodology step becomes an SDK step in one discipline. Some steps merge and a few the
methodology left implicit are added.

| Process (phase) | Methodology step | Discipline | Step / command | Primary artifacts |
|-----------------|------------------|------------|----------------|-------------------|
| 1 Conception | 1.1 Initial Discovery Session | Business Analysis | `discover` | Initial Requirements Document, Question Log |
| 1 Conception | 1.2 Requirement Refinement & Gap Analysis | Business Analysis | `refine-requirements` | Feature files (Gherkin scenarios, linked to tickets and pages), Technical Constraints Document |
| 1 Conception | 1.3 Design & Prototyping | UX Design | `prototype` | UI/UX Mockups, Interactive Prototype |
| 1 Conception | 1.4 Architecture & Technical Planning | Technical Analysis | `architect` | System Architecture Diagram, Technology Stack Document, decision records |
| 1 Conception | *(implicit)* Threat modelling | Security | `threat-model` | Threat model, security requirements as scenarios, mitigations on the backlog |
| 1 Conception | *(implicit)* Backlog refinement | Refinement | `plan-work` | Epics, stories, tasks with acceptance criteria in the ticket system |
| 2 Development | *(implicit)* Plan a ticket | Implementation Planning | `plan-implementation` | Implementation plan on the ticket |
| 2 Development | 2.1 Development Environment Setup | Development | `setup-environment` | Repository Structure, Development Environment Configuration |
| 2 Development | 2.2 Backend, 2.3 Frontend, 2.4 Integration | Development | `implement` | Application code, schema and migrations, integration code, and the tests that prove the requirement (happy paths, permutations, obvious negatives) at each tier touched |
| 2 Development | *(implicit)* Code review | Development | `review` | Review findings on the merge request |
| 2 Development | *(implicit)* Merge | Development | `finish-branch` | Merge request linked to ticket, ticket transitioned |
| 3 Testing | 3.1 Automated Test Suite Generation | Testing | `generate-tests` | Comprehensive Test Suite beyond the stated requirement, new scenarios for gaps found, questions on the ticket |
| 3 Testing | 3.2 Automated UI/E2E Testing | Testing | `e2e-tests` | E2E Test Suite, Visual Regression Test Suite |
| 3 Testing | 3.3 Performance & Load Testing | Testing | `performance-test` | Performance Test Suite, Performance Baseline Report |
| 3 Testing | 3.4 Security Testing | Security | `security-test` | Security Test Results, Security Compliance Report |
| 4 Deployment | 4.1 Deployment Environment Setup | Operations | `setup-infrastructure` | Infrastructure Code, Deployment Runbooks |
| 4 Deployment | 4.2 Continuous Deployment Pipeline | Operations | `setup-pipeline` | Deployment Pipeline Configuration, Deployment Strategy Documentation |
| 4 Deployment | *(implicit)* Prepare a release | Release Management | `prepare-release` | Version, release notes from tickets and commits, change record, go/no-go checklist |
| 4 Deployment | 4.3 Production Deployment | Release Management | `release` | Production Deployment Record, Deployment Verification Report |
| 4 Deployment | *(implicit)* Rollback | Release Management | `rollback` | Rollback executed and recorded, incident or ticket updated |
| 5 Verification | 5.1 Monitoring & Observability Setup | Operations | `observability` | Monitoring Dashboards, Alert Configuration |
| 5 Verification | 5.2 User Acceptance Testing | Business Analysis | `uat` | UAT Test Cases, UAT Results Report |
| 5 Verification | *(implicit)* Interaction review | UX Design | `review-ux` | Usability findings, tickets raised for interaction defects |
| 5 Verification | 5.3 Production Validation | Operations | `validate-production` | Production Validation Test Results, Production Metrics Report |
| 6 Maintenance | 6.1 Ongoing Monitoring & Support | Support | `triage` | Incident Log entries, tickets raised and prioritised |
| 6 Maintenance | *(implicit)* Incident response | Support | `respond-incident` | Incident timeline, mitigation, post-incident ticket |
| 6 Maintenance | 6.2 Performance Optimization | Development | `optimize` | Performance Optimization Backlog, Optimization Implementation Report |
| 6 Maintenance | 6.3 Feature Iteration & Enhancement | Product Management | `iterate` | Product Feedback Analysis, Feature Roadmap |
| 6 Maintenance | 6.4 Security & Compliance Maintenance | Security | `maintain-security` | Security Patch Log, Compliance Audit Reports |
| 6 Maintenance | 6.5 Documentation Maintenance | Documentation | `maintain-docs` | Up-to-Date Documentation, Documentation Health Report |
| Meta | Workflow Retrospective | Project Management | `retrospective` | Workflow Health Report, Process Improvement Backlog |
| Framework | n/a | Framework (`fw`) | `health` | Health report |
| Framework | n/a | Framework (`fw`) | `init` | Bootstrapped project: repository, documents folder, project config, conventions; health report |
| Framework | n/a | Framework (`fw`) | `new-opinion`, `new-tenet`, `new-discipline`, `new-process`, `new-step` | The item added with all of its plumbing: definition, commands, skill scaffold, scenarios, implied requirements and guidance, documents, decision log, regenerated review (aa-sdlc repository only) |
| Framework | n/a | Framework (`fw`) | `extend` | A valid, installable extension (tech-stack pack, process pack, project skill, target adapter, guidance, or requirement) with its manifest, declared requirements, and feature files |

The command for any discipline step is `/aa-<code>-<step>` using the code from section 3.1.

This table traces the methodology's original steps. The definitive list of disciplines, steps,
commands, artifacts, and guidance is the workflow data in `src/aa-sdlc/workflow/` and the
document generated from it, [discipline-review.md](discipline-review.md). The discipline review
(decision 35) added thirteen steps the methodology and this table did not have:

| Discipline | Added steps |
|------------|-------------|
| Product Management | `define-outcome`, `prioritise` |
| Technical Analysis | `decide`, `spike` |
| Refinement | `refine-ticket` |
| Project Management | `plan-iteration`, `status` |
| Implementation Planning | `breakdown-tasks` |
| Development | `fix-bug` |
| Testing | `test-strategy`, `explore` |
| Documentation | `document-feature` |
| Support | `postmortem` |

Notes on the merges and additions:

- Backend, frontend, and integration development collapse into `implement` because the split is a
  tech-stack concern, which belongs in plugins (T-02).
- The methodology has no explicit backlog-refinement, implementation-planning, code-review,
  merge, threat-modelling, release-preparation, rollback, interaction-review, or
  incident-response step. Those are added as `plan-work`, `plan-implementation`, `review`,
  `finish-branch`, `threat-model`, `prepare-release`, `rollback`, `review-ux`, and
  `respond-incident`, and the methodology should be updated to match.
- Human-only artifacts (meeting recordings, on-call schedules) are not step outputs.
- Discipline assignments follow decision 32. `validate-production` sits in Operations because
  it is performed against the live environment; `uat` stays in Business Analysis because it
  validates the business need.

## 5. Commands

- One command per step. Agent commands are named `/aa-<code>-<step>` on every target, where
  `<code>` is the short code of the step's discipline: `implement` in Development is
  `/aa-dev-implement`, `generate-tests` in Testing is `/aa-qa-generate-tests`. Typing `/aa-qa-`
  lists everything Testing can do.
- The framework's own commands use the code `fw`: `/aa-fw-health`, `/aa-fw-init`,
  `/aa-fw-extend`. Typing `/aa-fw-` lists everything the framework does for itself.
- Every command accepts a ticket ID as its anchor. If none is given, the command asks for one or,
  when no ticket system is in scope, proceeds with a local artifact and says so.
- Commands are thin: they name the skill to load and the arguments. Behaviour lives in the skill.
- Commands are defined once, target-neutrally, in `src/aa-sdlc/commands/` and rendered per target
  by the installer.
- The `aa` CLI and the `/aa-` commands are kept distinct. `aa <verb>` runs on the developer's
  machine without an agent and only bootstraps and maintains the install; `/aa-<code>-<step>` runs
  inside the agent and does the work. CLI verbs avoid agent command names, with `init` the one
  deliberate overlap (see 3.6).

## 6. Multi-target strategy

Targets in scope: Claude Code, Codex, Cursor, Hermes, OpenClaw, and others that read the
`SKILL.md` format.

- Skills ship unchanged to every target.
- `src/aa-sdlc/targets/<target>/` holds adapter templates for the parts that differ: where skills
  and commands are installed, how commands are declared, and hook or subagent definitions where a
  target supports them.
- A target with no command concept still gets the skills; the meta skill covers routing.

## 7. Deployment scopes and configuration

| Scope | Where files land | Typical user |
|-------|------------------|--------------|
| project | inside the repo, in the target's project-level skills location | a single repo adopting AA-SDLC |
| user | the user's home-level skills location | an individual across all their repos |
| team | a shared location or a team config repo layered on core | a team with shared plugins and conventions |
| enterprise | an org config repo the installer pulls, layering org plugins and settings on top of core | an organisation standardising on AA-SDLC |

A single `aa.config.yaml` per scope records the targets, active plugins, conventions (ticket
reference pattern, branch and commit patterns), and folder mappings for repositories that predate
the convention. Scopes merge from enterprise down to project; the format and merge rules are in
[formats.md](formats.md).

### 7.1 Installation

The primary delivery method is npm. `npm install -g aa-sdlc` provides the `aa` CLI and carries
the SDK content inside the same package, so the CLI and the skills it installs always version
together. The CLI then places skills and rendered commands into the chosen target and scope:

| Verb | Does |
|------|------|
| `aa setup` | bootstrap the machine: detect the agent targets installed, install skills and commands for each at user scope, write the user config, and connect a team or enterprise config repository if one is given. The main verb. |
| `aa init [-path <dir>]` | bootstrap a repository: write the project config, create the documents folder, install project-scope skills and commands, then point the user at `/aa-fw-init` and `/aa-fw-health` in their agent |
| `aa update` | update everything `setup` and `init` installed to the package version |
| `aa plugin add / remove / list` | manage plugins at a scope |

There is no `health` verb and no separate `install` verb: `setup` and `init` are the two ways
things get installed, at machine and repository level respectively.

Enterprise and team scopes point the CLI at a config repository whose plugins and settings are
layered on top of core. Flags are working names.

## 8. Plugins

Plugins add skills, commands, and workflow steps without changing core. Two kinds:

- **Tech-stack packs**: `.NET`, `Node`, `Android`, and so on. They add stack-specific guidance to
  `implement`, `generate-tests`, `setup-pipeline`, and the like.
- **Process packs**: extra steps or gates an organisation needs, such as a change-advisory step or
  a compliance review.

Plugins never wrap the ticket system, wiki, or source control (T-05).

### 8.1 Extensions and `/aa-fw-extend`

"Extension" is the umbrella for everything added outside core: the two plugin kinds above, a
project skill (specific to one repository, project scope only), a target adapter (support for an
agent the framework does not yet know), added guidance, and an added requirement. Every extension
declares its requirements in its own numbered range and carries its own feature files (T-11,
T-12).

`/aa-fw-extend` is the framework skill that helps the user create one. It asks what the extension
is for, picks the kind, scaffolds it, validates it against the tenets (an extension cannot change
core; core-level guidance cannot name a tool), and installs it at the chosen scope only when
validation passes. It can also share a valid extension through the organisation config repository
and add to an existing pack rather than creating a duplicate. Its behaviour is specified in
[`features/framework/extensibility.feature`](../features/framework/extensibility.feature).

## 9. Repository layout

```
aa-sdlc/
  .aitemp/              AI agent working files (gitignored)
  .build/               build outputs (gitignored)
  .dist/                distribution artifacts (gitignored)
  docs/                 design, tenets, opinions, vocabulary, guidance, requirements index
  features/             the framework's own requirements as Gherkin (source of truth, T-12)
    framework/          how the framework itself behaves
    cli/                one feature per aa verb
    agent/              one feature per agent-only command
    requirements/       the requirements registry as scenarios, one file per kind
  scripts/              build and validation helpers
  src/aa-sdlc/          the npm package: CLI plus SDK content
    package.json        package name aa-sdlc, bin aa
    cli/                the aa CLI source
    skills/             core skills grouped by discipline: <discipline>/<step>/SKILL.md
    commands/           target-neutral command definitions
    workflow/           processes as data: ordered steps, artifacts, acceptance criteria, process guidance
    plugins/            tech-stack and process packs
    targets/            per-target adapter templates
  tests/
    integration/        integration tests for the package and CLI
    e2e/                end-to-end tests driving aa and the agent commands
  initialize.ps1        bootstrap a fresh clone: tools, folders (O-06)
  build.ps1             validate skills and feature files, build the CLI, assemble the package into .build/
  test.ps1              run tests by tier: -Tier unit|integration|e2e|all, -Filter (O-06, O-07)
  pack.ps1              version, build, test, and produce the npm tarball in .dist/
```

Unit tests live with each project under `src/`; the unit tier also runs the structural
validators. This is the O-05 and O-06 layout applied to the framework's own repository
(decision 28).

`src/aa-sdlc/workflow/` is the single source of truth for the methodology. The website's
methodology page should be generated from it, or at least checked against it, so the site and the
skills cannot drift.

The CLI and the content live in one package so they cannot drift from each other. `pack.ps1`
produces the npm tarball; publishing to npm is a release step.

## 10. Website pivot

- The current landing page becomes a **Business Case** page. Content is kept and retitled.
- A new landing page is the **SDK project page**: what it is, the install one-liner, supported
  targets, the phase-to-skill map, the plugin model, and links to the methodology, business case,
  and repo. One message it must carry: the same framework serves a solo developer and a
  fifteen-person team (T-13). Fourteen disciplines are kinds of work, not people, and the site
  should show the solo path and the team path side by side so neither audience thinks it is
  for the other.
- The workflow page becomes **Methodology**. Each step gets a callout naming its skill and
  command, linking to the repo.
- Navigation becomes Home, Methodology, Business Case, Repo.
- The site should say plainly that the methodology describes AI in meetings and similar roles,
  while the SDK implements the coding-agent slice of it.

## 11. Decision log

| # | Date | Decision | Why |
|---|------|----------|-----|
| 1 | 2026-09-21 | Pivot AA-SDLC to skills-first SDK with the methodology as backing reference | The skills are the concrete, adoptable form of the methodology |
| 2 | 2026-09-21 | Ticket system is the state store; the SDK owns no process state | Enterprises already have ticket, wiki, and SCM systems and will not adopt a fourth state store; ticket-anchored state lets any step run at any time |
| 3 | 2026-09-21 | No wrapper skills for ticket, wiki, or source control | An MCP server or CLI already gives the agent the tools; a wrapper only restates them and must be maintained |
| 4 | 2026-09-21 | `/aa-fw-health` is the only place expectations are enumerated; it reports and never blocks | Keeps steps simple and degradation graceful |
| 5 | 2026-09-21 | `SKILL.md` is the portable unit; per-target adapters only for commands, hooks, subagents | Most targets read the Agent Skills format, so the core needs no per-target generation |
| 6 | 2026-09-21 | Skills organised by what the agent does, not by tier or team | Backend/frontend split is a tech-stack concern, which belongs in plugins |
| 7 | 2026-09-21 | Standard devpossible repo layout with the SDK content under `src/aa-sdlc/` | House convention: every project is a `src/` subfolder with root PowerShell scripts |
| 8 | 2026-09-21 | Adopt the vocabulary Tenet, Discipline, Process, Step, Guidance | Shared words keep the design, skills, website, and health command consistent |
| 9 | 2026-09-21 | Tenets are framework-level principles only; step-level practices are guidance | The first draft of tenets was too low-level; guidance attaches where it applies, tenets govern everything |
| 10 | 2026-09-21 | Drop the separate "discipline skills" behaviour layer in favour of guidance on steps | Behaviour belongs with the step it applies to, not in a parallel layer; "discipline" now means a grouping of skills |
| 11 | 2026-09-21 | Skills grouped by discipline in the source tree, flattened on install | Source stays navigable by kind of work; targets expect flat skill folders |
| 12 | 2026-09-21 | Command prefix is `aa-` on every target (`/aa-fw-health`, `/aa-dev-implement`) | Short, unambiguous, and identical everywhere; avoids depending on target namespace support |
| 13 | 2026-09-21 | Requirements are a first-class concept: declared where they arise, registered by ID, checked by health | Category-level guidance creates gaps the agent would otherwise hit mid-step; the framework owns the check (T-11) |
| 14 | 2026-09-21 | `/aa-fw-health` reports only; `/aa-fw-init` bootstraps | Keeps health side-effect free (T-10) while making bootstrapping a core job of the framework |
| 15 | 2026-09-21 | Rebrand to AA-SDLC; package and repo `aa-sdlc`; CLI `aa`; commands `/aa-<code>-<step>` | One short stem names the brand, the package, the CLI, and every command consistently |
| 16 | 2026-09-21 | Primary delivery is npm: `npm install -g aa-sdlc` provides `aa`, which drives all framework tooling | Cross-platform reach, matches the reference projects, and versions the CLI with the content it installs |
| 17 | 2026-09-21 | CLI verbs are `setup` (machine, the main verb), `init` (repository), `update`, `plugin`; no `install` verb | Two bootstrap levels cover every install; fewer verbs to learn |
| 18 | 2026-09-21 | No `health` CLI verb; health is agent-only as `/aa-fw-health` | A CLI health would collide with the agent command and could only give a partial answer, since the key probes need the agent |
| 19 | 2026-09-21 | Agent commands are written and invoked as `/aa-<code>-<step>` | Makes agent commands visibly distinct from `aa <verb>` CLI usage |
| 20 | 2026-09-21 | Requirements are Gherkin feature files in the repository and are the source of truth for them; the tooling maintains the feature-ticket-page link (T-12, O-01) | Structured natural language serves stakeholders, agents, and tests with one artifact; the repository gives it history and review |
| 21 | 2026-09-21 | The framework dogfoods T-12: its own requirements live in `features/` and the registry tables index them | If the rule is good enough for consumers it is good enough for the framework; it also makes `/aa-fw-health` a spec-driven command |
| 22 | 2026-09-21 | Opinions are a first-class, up-front document: Gherkin requirements, source control, a ticket manager, a knowledge repository | Being opinionated only works if the opinions are stated before adoption, with what they reject and what would change them |
| 23 | 2026-09-21 | One folder structure for every repository regardless of content (O-05) | Agents, people, and tooling find things without reading; stack layout lives inside each project's subfolder |
| 24 | 2026-09-21 | Root scripts `initialize`, `build`, `test`, `pack` in every repository, with general filter and switch parameters (O-06) | One contract between a repository and everything that runs it; makes R-10 and R-11 true everywhere |
| 25 | 2026-09-21 | Every repository has unit, integration, and end-to-end tiers, selectable from the root test script (O-07) | Each tier catches a class of defect the others cannot |
| 26 | 2026-09-21 | Development writes the tests that prove the requirement; Testing extends the suite beyond it and turns gaps into scenarios (O-08) | Gives each discipline a job the other cannot do and keeps "done" honest |
| 27 | 2026-09-21 | `/aa-fw-extend` is a core framework skill that scaffolds, validates, installs, and shares extensions | T-02 makes extensibility a requirement of every core skill; a skill that makes extensions easy is how the framework keeps that promise |
| 28 | 2026-09-21 | This repository adopts O-05, O-06, O-07 for itself: `initialize`, `build`, `test -Tier`, `pack`, and `tests/integration`, `tests/e2e`; the prior devpossible house convention is expected to convert to this model | The framework is forging the new path; the house convention follows it rather than the reverse |
| 29 | 2026-09-21 | Workflow data is YAML: `workflow/processes/<process>.yaml` and `workflow/steps/<step>.yaml` (see formats.md) | Human-editable with comments, read by both the CLI and the site generator |
| 30 | 2026-09-21 | The config file is `aa.config.yaml`, one per scope, merged enterprise to project, validated against a published schema | Hand-edited more than tool-edited, so comments matter; schema validation catches mistakes before merge |
| 31 | 2026-09-21 | Skills declare `aa.requires: [R-nn]` in frontmatter; definitions live once in feature files; plugins use namespaced ids and a `plugin.yaml` manifest | No duplication, cheap to declare, and `/aa-fw-health` resolves ids against the installed set |
| 32 | 2026-09-21 | Fourteen disciplines: add Product Management, UX Design, Security, Release Management, and Support; confirm Operations; move triage to Support, release to Release Management, prototype to UX Design, security steps to Security, iterate to Product Management | Common roles must have a named home; a discipline is a kind of work, not a headcount |
| 33 | 2026-09-21 | Tenet T-13: one person or fifteen, the same framework; the website leads with it | The framework must never assume a team size, a hand-off, or a large-organisation role; a solo developer and a full team are both first-class audiences |
| 34 | 2026-09-21 | Every discipline has a 2 or 3 character code; discipline commands are `/aa-<code>-<step>`; framework commands use the code `fw` (`/aa-fw-health`, `/aa-fw-init`, `/aa-fw-extend`) | Commands group by discipline in the agent's command list, and the rule has no exceptions |
| 35 | 2026-09-21 | All fifteen disciplines defined as workflow data (`disciplines/<id>.yaml`) with bounded responsibilities, 47 steps with artifacts and guidance, six processes; `docs/discipline-review.md` is generated from them and validated in the unit tier | The workflow data is the source of truth; a generated review document keeps it readable without letting it drift |
| 36 | 2026-09-21 | Framework authoring commands `/aa-fw-new-opinion`, `-tenet`, `-discipline`, `-process`, `-step`, each responsible for all the plumbing of the item it adds | Adding to the framework by hand misses pieces; a command that owns the whole checklist keeps the framework consistent with itself |

## 12. Open questions

- **CLI flags and target detection.** The verb set is decided (section 7.1); flags, and how
  `aa setup` detects installed targets, are not.
- **CLI implementation.** Plain Node or TypeScript; the package must work on Node LTS without a
  build step for consumers.
- **Public hosting and licence.** Likely private GitLab mirrored to GitHub, matching existing
  mirror setup. Licence not chosen.
- **Exact step and command names.** The names in section 4 are working names.
- **Feature files for the 44 discipline steps.** Only the framework's own commands have
  scenarios; every discipline step now has workflow YAML but no feature file.
- **Review of the generated discipline definitions.** `docs/discipline-review.md` is a first
  draft awaiting the user's adjustments (see `plan-discipline-review.md`).
- **Schema files** for workflow data and `aa.config.yaml`, to be written alongside the CLI
  (formats are decided in [formats.md](formats.md)).
- **Stack detection for R-13.** How `/aa-fw-health` identifies the major technologies in a project
  and matches them to skills in scope, without naming tools in core.
- **Methodology updates** to add the implicit backlog-refinement, implementation-planning,
  review, and merge steps.
- **Feature-ticket-page link mechanics.** Tag format for the ticket, where the page link lives,
  how conflicts are detected (hashes, timestamps, or content diff), and which steps run the sync.
- **Executable feature files for the framework.** Whether and when `features/` gets step
  definitions that drive the CLI and agent tests, or stays a readable contract.
- **Exact conventional folder names** for O-05 (`docs` versus `documents`, `tests` layout per
  tier) and how the project config maps an existing repository's equivalents.
