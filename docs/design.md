# AASDLC SDK: Design

**Status:** working draft, under active brainstorming. Last updated 2026-09-21.

This document captures the design decisions made so far for the AASDLC SDK. It is deliberately
opinionated where a decision has been made and explicit where one has not. See
[Open questions](#12-open-questions) at the end.

## 1. What this is

AASDLC (Agent Assisted Software Development Life Cycle) started as a methodology published at
aasdlc.com. The SDK is the concrete implementation of that methodology as a set of agent skills
and commands. The methodology says *what* a well-run agent-assisted project produces at each step
and *why*. The SDK gives an agent the *how*.

The relationship is one-directional: the skills implement the methodology, the methodology does
not depend on the skills. The website pivots to lead with the SDK and keep the methodology as the
backing reference.

Reference projects the SDK is deliberately similar to:

- **BMAD-METHOD** (bmad-code-org): whole-lifecycle coverage, installer, multi-IDE targeting,
  expansion packs.
- **superpowers** (obra): small, sharp behavioural skills, a meta skill that routes to them, and
  a plugin-style install.

## 2. Tenets and vocabulary

The principles that govern the SDK's design are the **tenets**, kept in [tenets.md](tenets.md)
and cited by ID (T-01 to T-10). The terms used throughout are defined in
[vocabulary.md](vocabulary.md). In one line: tenets govern everything; **disciplines** group
skills by kind of work; a **process** is an ordered set of **steps** toward a goal; each step is
delivered as a **skill** and invoked by a **command**; **guidance** is the specific advice
attached to a step or process. Guidance not yet attached to a step is tracked in
[guidance.md](guidance.md).

## 3. Architecture

### 3.1 Disciplines

Skills are grouped by discipline, the kind of work they perform. Current disciplines:

| Discipline | Kind of work |
|------------|--------------|
| Business Analysis | discovering, capturing, and validating what the business needs |
| Technical Analysis | architecture, technology choices, prototypes, decision records |
| Refinement | turning requirements into a well-formed, prioritised backlog |
| Implementation Planning | planning how a single ticket will be built before building it |
| Development | building, reviewing, and merging code |
| Testing | proving behaviour at every level |
| Documentation | keeping the knowledge base and repo docs true |
| Project Management | coordination, triage, retrospectives, health |
| Operations *(proposed)* | infrastructure, pipelines, releases, observability |

### 3.2 Processes and steps

A step is one self-contained unit of work in one discipline. It produces named artifacts with the
acceptance criteria from the methodology and records its outcome on the anchor ticket. Every step
has a skill and a command, and every step runs standalone (T-03).

A process is an ordered set of steps toward a goal, drawn from any disciplines. The methodology's
six phases are the core processes. Smaller processes ("deliver a ticket", "ship a release") are
expected, and plugins may add more. Processes are defined as data in `src/aasdlc/workflow/`.

### 3.3 Guidance

Guidance is the specific, actionable advice on how best to perform a step or process. It lives in
the skill for its step or in the process definition, is written against tool categories only
(T-01), and is cited by ID. Guidance replaces the earlier idea of separate "discipline skills"
for behaviour: the behaviour is attached where it applies rather than held in a parallel layer.

### 3.4 Meta skill

`aasdlc` (working name): explains the SDK to the agent, describes the disciplines and processes
at a glance, and routes to the right step for the task at hand. Modelled on superpowers'
`using-superpowers`.

### 3.5 The health command

`aa-health` is the single place the SDK's expectations are enumerated and checked. It
reports, and never blocks. It checks:

| Area | What it checks |
|------|----------------|
| SDK install | scope, version, target, which skills and commands are present, whether an update is available |
| Environment | which external capabilities are reachable: a ticket system, a knowledge base, source control, and via what (MCP, connector, CLI) |
| Current project (if one is in scope) | is it a git repo, is there an `aasdlc` config, is current work linked to tickets, which phase artifacts exist |

It is the first thing the installer tells the user to run.

## 4. Methodology to step map

The methodology has six phases and 23 steps plus a quarterly meta-process (see the website's
workflow page, mirrored in `src/aasdlc/workflow/`). The phases become the core processes. Each
methodology step becomes an SDK step in one discipline. Some steps merge and a few the
methodology left implicit are added.

| Process (phase) | Methodology step | Discipline | Step / command | Primary artifacts |
|-----------------|------------------|------------|----------------|-------------------|
| 1 Conception | 1.1 Initial Discovery Session | Business Analysis | `discover` | Initial Requirements Document, Question Log |
| 1 Conception | 1.2 Requirement Refinement & Gap Analysis | Business Analysis | `refine-requirements` | Refined Requirements Document, Technical Constraints Document |
| 1 Conception | 1.3 Design & Prototyping | Technical Analysis | `prototype` | UI/UX Mockups, Interactive Prototype |
| 1 Conception | 1.4 Architecture & Technical Planning | Technical Analysis | `architect` | System Architecture Diagram, Technology Stack Document, decision records |
| 1 Conception | *(implicit)* Backlog refinement | Refinement | `plan-work` | Epics, stories, tasks with acceptance criteria in the ticket system |
| 2 Development | *(implicit)* Plan a ticket | Implementation Planning | `plan-implementation` | Implementation plan on the ticket |
| 2 Development | 2.1 Development Environment Setup | Development | `setup-environment` | Repository Structure, Development Environment Configuration |
| 2 Development | 2.2 Backend, 2.3 Frontend, 2.4 Integration | Development | `implement` | Application code, schema and migrations, integration code |
| 2 Development | *(implicit)* Code review | Development | `review` | Review findings on the merge request |
| 2 Development | *(implicit)* Merge | Development | `finish-branch` | Merge request linked to ticket, ticket transitioned |
| 3 Testing | 3.1 Automated Test Suite Generation | Testing | `generate-tests` | Gherkin Feature Files, Comprehensive Test Suite |
| 3 Testing | 3.2 Automated UI/E2E Testing | Testing | `e2e-tests` | E2E Test Suite, Visual Regression Test Suite |
| 3 Testing | 3.3 Performance & Load Testing | Testing | `performance-test` | Performance Test Suite, Performance Baseline Report |
| 3 Testing | 3.4 Security Testing | Testing | `security-test` | Security Test Results, Security Compliance Report |
| 4 Deployment | 4.1 Deployment Environment Setup | Operations | `setup-infrastructure` | Infrastructure Code, Deployment Runbooks |
| 4 Deployment | 4.2 Continuous Deployment Pipeline | Operations | `setup-pipeline` | Deployment Pipeline Configuration, Deployment Strategy Documentation |
| 4 Deployment | 4.3 Production Deployment | Operations | `release` | Release notes, Production Deployment Record, Deployment Verification Report |
| 5 Verification | 5.1 Monitoring & Observability Setup | Operations | `observability` | Monitoring Dashboards, Alert Configuration |
| 5 Verification | 5.2 User Acceptance Testing | Business Analysis | `uat` | UAT Test Cases, UAT Results Report |
| 5 Verification | 5.3 Production Validation | Testing | `validate-production` | Production Validation Test Results, Production Metrics Report |
| 6 Maintenance | 6.1 Ongoing Monitoring & Support | Project Management | `triage` | Incident Log entries, tickets raised |
| 6 Maintenance | 6.2 Performance Optimization | Development | `optimize` | Performance Optimization Backlog, Optimization Implementation Report |
| 6 Maintenance | 6.3 Feature Iteration & Enhancement | Business Analysis | `iterate` | Product Feedback Analysis, Feature Roadmap |
| 6 Maintenance | 6.4 Security & Compliance Maintenance | Development | `maintain-security` | Security Patch Log, Compliance Audit Reports |
| 6 Maintenance | 6.5 Documentation Maintenance | Documentation | `maintain-docs` | Up-to-Date Documentation, Documentation Health Report |
| Meta | Workflow Retrospective | Project Management | `retrospective` | Workflow Health Report, Process Improvement Backlog |
| Cross-cutting | n/a | Project Management | `health` | Health report |

Notes on the merges and additions:

- Backend, frontend, and integration development collapse into `implement` because the split is a
  tech-stack concern, which belongs in plugins (T-02).
- The methodology has no explicit backlog-refinement, implementation-planning, code-review, or
  merge step. Those are added as `plan-work`, `plan-implementation`, `review`, and
  `finish-branch`, and the methodology should be updated to match.
- Human-only artifacts (meeting recordings, on-call schedules) are not step outputs.
- Discipline assignments are a first pass. Several steps could sit in two disciplines (for
  example `validate-production` in Testing or Operations).

## 5. Commands

- One command per step, plus `health`. Every command is prefixed `aa-`, so the step `health` is
  `aa-health` and `implement` is `aa-implement`, on every target.
- Every command accepts a ticket ID as its anchor. If none is given, the command asks for one or,
  when no ticket system is in scope, proceeds with a local artifact and says so.
- Commands are thin: they name the skill to load and the arguments. Behaviour lives in the skill.
- Commands are defined once, target-neutrally, in `src/aasdlc/commands/` and rendered per target
  by the installer.

## 6. Multi-target strategy

Targets in scope: Claude Code, Codex, Cursor, Hermes, OpenClaw, and others that read the
`SKILL.md` format.

- Skills ship unchanged to every target.
- `src/aasdlc/targets/<target>/` holds adapter templates for the parts that differ: where skills
  and commands are installed, how commands are declared, and hook or subagent definitions where a
  target supports them.
- A target with no command concept still gets the skills; the meta skill covers routing.

## 7. Deployment scopes and configuration

| Scope | Where files land | Typical user |
|-------|------------------|--------------|
| project | inside the repo, in the target's project-level skills location | a single repo adopting AASDLC |
| user | the user's home-level skills location | an individual across all their repos |
| team | a shared location or a team config repo layered on core | a team with shared plugins and conventions |
| enterprise | an org config repo the installer pulls, layering org plugins and settings on top of core | an organisation standardising on AASDLC |

A single `aasdlc` config file per scope records the active plugins and any conventions (ticket
prefix, branch naming, artifact locations). Scopes merge from enterprise down to project.

## 8. Plugins

Plugins add skills, commands, and workflow steps without changing core. Two kinds:

- **Tech-stack packs**: `.NET`, `Node`, `Android`, and so on. They add stack-specific guidance to
  `implement`, `generate-tests`, `setup-pipeline`, and the like.
- **Process packs**: extra steps or gates an organisation needs, such as a change-advisory step or
  a compliance review.

Plugins never wrap the ticket system, wiki, or source control (see principle 3).

## 9. Repository layout

```
aasdlc-sdk/
  .aitemp/              AI agent working files (gitignored)
  .build/               build outputs (gitignored)
  .dist/                distribution artifacts (gitignored)
  docs/                 this design and future specs
  scripts/              build and validation helpers
  src/aasdlc/           the SDK content package
    skills/             core skills grouped by discipline: <discipline>/<step>/SKILL.md
    commands/           target-neutral command definitions
    workflow/           processes as data: ordered steps, artifacts, acceptance criteria, process guidance
    plugins/            tech-stack and process packs
    targets/            per-target adapter templates
  tests/                integration tests for the package and installer
  build.ps1             validate skills and assemble the package into .build/
  test-smoke.ps1        fast structural validation
  test-full.ps1         smoke plus tests/
  package.ps1           version, build, test, and zip into .dist/
```

`src/aasdlc/workflow/` is the single source of truth for the methodology. The website's
methodology page should be generated from it, or at least checked against it, so the site and the
skills cannot drift.

The installer will live in its own folder under `src/` once its implementation language is
decided.

## 10. Website pivot

- The current landing page becomes a **Business Case** page. Content is kept and retitled.
- A new landing page is the **SDK project page**: what it is, the install one-liner, supported
  targets, the phase-to-skill map, the plugin model, and links to the methodology, business case,
  and repo.
- The workflow page becomes **Methodology**. Each step gets a callout naming its skill and
  command, linking to the repo.
- Navigation becomes Home, Methodology, Business Case, Repo.
- The site should say plainly that the methodology describes AI in meetings and similar roles,
  while the SDK implements the coding-agent slice of it.

## 11. Decision log

| # | Date | Decision | Why |
|---|------|----------|-----|
| 1 | 2026-09-21 | Pivot AASDLC to skills-first SDK with the methodology as backing reference | The skills are the concrete, adoptable form of the methodology |
| 2 | 2026-09-21 | Ticket system is the state store; the SDK owns no process state | Enterprises already have ticket, wiki, and SCM systems and will not adopt a fourth state store; ticket-anchored state lets any step run at any time |
| 3 | 2026-09-21 | No wrapper skills for ticket, wiki, or source control | An MCP server or CLI already gives the agent the tools; a wrapper only restates them and must be maintained |
| 4 | 2026-09-21 | `aa-health` is the only place expectations are enumerated; it reports and never blocks | Keeps steps simple and degradation graceful |
| 5 | 2026-09-21 | `SKILL.md` is the portable unit; per-target adapters only for commands, hooks, subagents | Most targets read the Agent Skills format, so the core needs no per-target generation |
| 6 | 2026-09-21 | Skills organised by what the agent does, not by tier or team | Backend/frontend split is a tech-stack concern, which belongs in plugins |
| 7 | 2026-09-21 | Standard devpossible repo layout with the SDK content under `src/aasdlc/` | House convention: every project is a `src/` subfolder with root PowerShell scripts |
| 8 | 2026-09-21 | Adopt the vocabulary Tenet, Discipline, Process, Step, Guidance | Shared words keep the design, skills, website, and health command consistent |
| 9 | 2026-09-21 | Tenets are framework-level principles only; step-level practices are guidance | The first draft of tenets was too low-level; guidance attaches where it applies, tenets govern everything |
| 10 | 2026-09-21 | Drop the separate "discipline skills" behaviour layer in favour of guidance on steps | Behaviour belongs with the step it applies to, not in a parallel layer; "discipline" now means a grouping of skills |
| 11 | 2026-09-21 | Skills grouped by discipline in the source tree, flattened on install | Source stays navigable by kind of work; targets expect flat skill folders |
| 12 | 2026-09-21 | Command prefix is `aa-` on every target (`aa-health`, `aa-implement`) | Short, unambiguous, and identical everywhere; avoids depending on target namespace support |

## 12. Open questions

- **Installer language.** `npx aasdlc` is proposed for cross-platform reach and to match the
  reference projects. PowerShell would match the rest of the devpossible tooling but costs macOS
  and Linux reach. Not yet decided.
- **Repository name.** The GitLab project and folder are currently `aasldc-sdk`; the product is
  `aasdlc`. Rename before anything links to it.
- **Public hosting and licence.** Likely private GitLab mirrored to GitHub, matching existing
  mirror setup. Licence not chosen.
- **Exact step and command names.** The names in section 4 are working names.
- **Operations as a discipline.** Infrastructure, pipelines, releases, and observability need a
  home; "Operations" is proposed, not confirmed.
- **Discipline assignments.** Section 4 is a first pass; some steps fit two disciplines.
- **Workflow data format.** YAML, JSON, or Markdown with frontmatter for `src/aasdlc/workflow/`.
- **Whether `health` also offers to fix** what it finds (for example, initialise a project
  config) or stays strictly read-only.
- **Methodology updates** to add the implicit backlog-refinement, implementation-planning,
  review, and merge steps.
