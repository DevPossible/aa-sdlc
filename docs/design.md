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

## 2. Principles

1. **Opinionated, not enforced.** The workflow is described end to end, but every step has its
   own command that can be run standalone at any time, in any order. The SDK never refuses to run
   a step because an earlier one was skipped.
2. **The SDK owns no process state.** The ticket system is the state store, the wiki or notes
   system is the memory, and source control is the output. Every command anchors on a ticket ID,
   reads what it needs from the ticket and wiki, does its step, and writes results back.
3. **No wrapper skills for external systems.** If the agent already has an MCP server, connector,
   or CLI for the ticket system, wiki, or source control, the skills use it by describing intent
   in plain language ("update the ticket", "record the decision in the wiki", "open a merge
   request"). A skill that wraps an MCP server only restates what the agent can already see.
4. **Graceful degradation.** If a system is absent, a step still runs and produces its artifact
   locally. The `health` command is where the user learns something is missing, not a failure
   inside a step.
5. **Target-agnostic core.** The portable unit is the `SKILL.md` folder (the Agent Skills
   standard). Only slash commands, hooks, and subagent definitions differ per target.
6. **Not tech-stack or tool dependent.** Core skills describe outcomes. Tech-stack specifics
   (a .NET pack, a Node pack) and extra processes (a compliance pack) are plugins.
7. **Consistency is the product.** The point of being opinionated is that two teams using the SDK
   produce recognisably the same artifacts, in the same places, linked the same way.
8. **Extensibility is a requirement of every core skill.** The core roughs in the framework;
   plugins, project skills, and the user's existing tooling supply the specifics.

These principles govern the SDK's design. The practices the SDK teaches the agent and the user
at each step are the **tenets**, kept separately in [tenets.md](tenets.md) so skills can cite
them by ID.

## 3. Architecture

Three layers of skills plus one meta skill and one diagnostic command.

### 3.1 Phase skills

One skill per methodology step. Each produces that step's named artifact(s) with the acceptance
criteria from the methodology, and records the outcome against the anchoring ticket. Each has a
matching command.

### 3.2 Discipline skills

How the agent behaves inside any step. These are the superpowers-style layer and are referenced
by phase skills rather than restated in them. Candidate list, to be refined:

- `test-driven-development`
- `systematic-debugging`
- `verify-before-done`
- `plan-then-execute`

### 3.3 Meta skill

`aasdlc` (working name): explains the SDK to the agent, describes the workflow at a glance, and
routes to the right phase or discipline skill for the task at hand. Modelled on superpowers'
`using-superpowers`.

### 3.4 The health command

`aasdlc-health` is the single place the SDK's expectations are enumerated and checked. It
reports, and never blocks. It checks:

| Area | What it checks |
|------|----------------|
| SDK install | scope, version, target, which skills and commands are present, whether an update is available |
| Environment | which external capabilities are reachable: a ticket system, a knowledge base, source control, and via what (MCP, connector, CLI) |
| Current project (if one is in scope) | is it a git repo, is there an `aasdlc` config, is current work linked to tickets, which phase artifacts exist |

It is the first thing the installer tells the user to run.

## 4. Methodology to skill map

The methodology has six phases and 23 steps plus a quarterly meta-process (see the website's
workflow page, mirrored in `src/aasdlc/workflow/`). Skills are organised by what the agent does,
not by tier or team, so some steps merge and a few steps the methodology left implicit are added.

| Phase | Methodology step | Skill / command | Primary artifacts |
|-------|------------------|-----------------|-------------------|
| 1 Conception | 1.1 Initial Discovery Session | `discover` | Initial Requirements Document, Question Log |
| 1 Conception | 1.2 Requirement Refinement & Gap Analysis | `refine-requirements` | Refined Requirements Document, Technical Constraints Document |
| 1 Conception | 1.3 Design & Prototyping | `prototype` | UI/UX Mockups, Interactive Prototype |
| 1 Conception | 1.4 Architecture & Technical Planning | `architect` | System Architecture Diagram, Technology Stack Document, ADRs |
| 1 Conception | *(implicit in methodology)* Work breakdown | `plan-work` | Epics, stories, tasks in the ticket system |
| 2 Development | 2.1 Development Environment Setup | `setup-environment` | Repository Structure, Development Environment Configuration |
| 2 Development | 2.2 Backend, 2.3 Frontend, 2.4 Integration | `implement` | Application code, schema and migrations, integration code |
| 2 Development | *(implicit in methodology)* Code review | `review` | Review findings on the merge request |
| 2 Development | *(implicit in methodology)* Merge | `finish-branch` | Merge request linked to ticket, ticket transitioned |
| 3 Testing | 3.1 Automated Test Suite Generation | `generate-tests` | Gherkin Feature Files, Comprehensive Test Suite |
| 3 Testing | 3.2 Automated UI/E2E Testing | `e2e-tests` | E2E Test Suite, Visual Regression Test Suite |
| 3 Testing | 3.3 Performance & Load Testing | `performance-test` | Performance Test Suite, Performance Baseline Report |
| 3 Testing | 3.4 Security Testing | `security-test` | Security Test Results, Security Compliance Report |
| 4 Deployment | 4.1 Deployment Environment Setup | `setup-infrastructure` | Infrastructure Code, Deployment Runbooks |
| 4 Deployment | 4.2 Continuous Deployment Pipeline | `setup-pipeline` | Deployment Pipeline Configuration, Deployment Strategy Documentation |
| 4 Deployment | 4.3 Production Deployment | `release` | Release notes, Production Deployment Record, Deployment Verification Report |
| 5 Verification | 5.1 Monitoring & Observability Setup | `observability` | Monitoring Dashboards, Alert Configuration |
| 5 Verification | 5.2 User Acceptance Testing | `uat` | UAT Test Cases, UAT Results Report |
| 5 Verification | 5.3 Production Validation | `validate-production` | Production Validation Test Results, Production Metrics Report |
| 6 Maintenance | 6.1 Ongoing Monitoring & Support | `triage` | Incident Log entries, tickets raised |
| 6 Maintenance | 6.2 Performance Optimization | `optimize` | Performance Optimization Backlog, Optimization Implementation Report |
| 6 Maintenance | 6.3 Feature Iteration & Enhancement | `iterate` | Product Feedback Analysis, Feature Roadmap |
| 6 Maintenance | 6.4 Security & Compliance Maintenance | `maintain-security` | Security Patch Log, Compliance Audit Reports |
| 6 Maintenance | 6.5 Documentation Maintenance | `maintain-docs` | Up-to-Date Documentation, Documentation Health Report |
| Meta | Workflow Retrospective | `retrospective` | Workflow Health Report, Process Improvement Backlog |
| Cross-cutting | n/a | `health` | Health report |

Notes on the merges and additions:

- Backend, frontend, and integration development collapse into `implement` because the split is a
  tech-stack concern, which belongs in plugins.
- The methodology has no explicit work-breakdown, code-review, or merge step. Those are added as
  `plan-work`, `review`, and `finish-branch`, and the methodology should be updated to match.
- Human-only artifacts (meeting recordings, on-call schedules) are not skill outputs.

## 5. Commands

- One command per phase skill, plus `health`. Naming is `aasdlc:<skill>` on targets that support
  namespaces and `aasdlc-<skill>` where they do not.
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
    skills/             core skills, one folder each: SKILL.md, references/, templates/
    commands/           target-neutral command definitions
    workflow/           the methodology as data: phases, steps, artifacts, acceptance criteria
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
| 4 | 2026-09-21 | `aasdlc-health` is the only place expectations are enumerated; it reports and never blocks | Keeps steps simple and degradation graceful |
| 5 | 2026-09-21 | `SKILL.md` is the portable unit; per-target adapters only for commands, hooks, subagents | Most targets read the Agent Skills format, so the core needs no per-target generation |
| 6 | 2026-09-21 | Skills organised by what the agent does, not by tier or team | Backend/frontend split is a tech-stack concern, which belongs in plugins |
| 7 | 2026-09-21 | Standard devpossible repo layout with the SDK content under `src/aasdlc/` | House convention: every project is a `src/` subfolder with root PowerShell scripts |

## 12. Open questions

- **Installer language.** `npx aasdlc` is proposed for cross-platform reach and to match the
  reference projects. PowerShell would match the rest of the devpossible tooling but costs macOS
  and Linux reach. Not yet decided.
- **Repository name.** The GitLab project and folder are currently `aasldc-sdk`; the product is
  `aasdlc`. Rename before anything links to it.
- **Public hosting and licence.** Likely private GitLab mirrored to GitHub, matching existing
  mirror setup. Licence not chosen.
- **Exact skill and command names.** The names in section 4 are working names.
- **Discipline skill list.** Section 3.2 is a candidate list.
- **Workflow data format.** YAML, JSON, or Markdown with frontmatter for `src/aasdlc/workflow/`.
- **Whether `health` also offers to fix** what it finds (for example, initialise a project
  config) or stays strictly read-only.
- **Methodology updates** to add the implicit work-breakdown, review, and merge steps.
