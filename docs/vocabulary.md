# AA-SDLC Vocabulary

**Status:** working draft. Last updated 2026-09-21.

These terms are used consistently across the design, the skills, the website, and the health
command. When a word here is used in a document, it means exactly this.

## Structural terms

**Tenet**
A principle governing how the SDK and its content are designed. Tenets are few, stable, and
framework-level. They shape every discipline, process, step, and piece of guidance. See
[tenets.md](tenets.md).

**Opinion**
A deliberate stance the framework takes where reasonable alternatives exist, so that every
project does it the same way. Tenets say how the framework is designed; opinions say which
defensible option it picks. Examples: requirements are Gherkin; every project uses source
control, a ticket manager, and a knowledge repository. See [opinions.md](opinions.md).

**Discipline**
A set of skills related to performing a specific kind of work. Disciplines group skills by the
nature of the work, not by when it happens. Fourteen disciplines: Business Analysis, Product
Management, UX Design, Technical Analysis, Refinement, Implementation Planning, Development,
Testing, Security, Documentation, Release Management, Operations, Support, and Project
Management. A discipline is a kind of work, not a headcount; one person or one agent session
may work in several.

**Process**
A series of steps needed to accomplish a goal. A process may draw steps from several
disciplines. The methodology's phases are processes; so is a smaller sequence such as "deliver a
ticket". Processes are described, not enforced: every step in a process can also be run alone.

**Step**
An individual, self-contained unit of work related to accomplishing a goal. A step belongs to one
discipline, produces one or more artifacts, and anchors on a ticket. A step is delivered to the
agent as a skill and invoked by a command.

**Guidance**
A detail on a step or process that indicates how best to perform it. Guidance is specific and
actionable, and is written against tool categories rather than tools. Example: "Always format the
code for the changed files before committing, but do not format files that were not changed."
Guidance lives inside the skill for its step, or in the process definition for its process.
See [guidance.md](guidance.md) for the backlog of guidance not yet attached.

**Requirement**
A capability or condition that a step, process, or piece of guidance depends on in order to be
performed. Requirements name categories, not tools: "a formatter that can run on a list of
files", "the project is under source control", "every major technology in the stack has a skill
in scope". They are declared where they arise, aggregated and checked by `/aa-fw-health`, and where
possible fixed by `/aa-fw-init`. See [requirements.md](requirements.md).

## Delivery terms

**Skill**
The unit delivered to an agent: a folder containing `SKILL.md` and optional references and
templates. One skill implements one step. Skills are grouped by discipline in the source tree and
ship unchanged to every target.

**Command**
The user-facing entry point that invokes a skill. Thin, target-neutral in source, rendered per
target by the installer. Named `/aa-<code>-<step>` on every target, where `<code>` is the
discipline's short code: `/aa-dev-implement`, `/aa-qa-generate-tests`. The framework's own
commands use the code `fw`: `/aa-fw-health`, `/aa-fw-init`, `/aa-fw-extend`.

**Discipline code**
A two or three character code for each discipline, used as the middle segment of its commands:
`ba`, `pd`, `ux`, `ta`, `rf`, `ip`, `dev`, `qa`, `sec`, `doc`, `rel`, `ops`, `sup`, `pm`, and
`fw` for the framework itself.

**Artifact**
A named deliverable a step produces, with acceptance criteria defined in the workflow. Same
artifact, same place, same name, every time.

**Feature file**
A Gherkin file in the project's features folder. The source of truth for requirements (T-12,
O-01). Each scenario is tagged with its anchor ticket; each feature names its knowledge base
page; the tooling keeps all three aligned. The framework's own requirements are feature files
under `features/` in this repository.

**Anchor ticket**
The ticket a step reads from and writes to. The ticket system is the state store; the SDK owns
no process state.

**Guidance set**
A named list of guidance and requirement ids that many steps share, defined once in
`src/aa-sdlc/workflow/guidance-sets/` and cited by name from a step's `guidance_sets`. A step
lists only the ids its sets do not supply. The sets are `every-step`, `anchored-step`,
`repository-write`, `code-change`, `test-writing`, and `framework-authoring`.

**Decision record**
One screen recording a significant decision, technical, product, or process: its context, the
options considered, the decision, and its consequences. Numbered next in one sequence per
repository, dated, immutable once accepted, and superseded by a new record rather than edited
(O-18). Lives in the knowledge repository or the documents folder, whichever the project config
names.

**Definition of ready**
The condition a ticket meets before work starts on it: scenarios linked and complete,
acceptance criteria checkable, size recorded with the implementation thinking that grounds it
(O-10), dependencies clear, questions answered or owned, and the repository revision it was
checked against recorded (O-13).

**Currency check**
The comparison a step makes when it picks up a ticket: the repository at the revision the
ticket was refined and planned against, against the repository now, filtered to the feature
files the ticket links and the files its plan names. Its result is recorded on the ticket; a
conflict goes back to refinement (O-13).

**Environment file**
The place, per deployed environment, for the settings that differ between environments:
endpoints, connection strings, resource names, credentials. A committed template names every
key with placeholders for secrets; the values are supplied at deploy time. Functional settings
that are the same everywhere do not go here (O-25). The file format or platform mechanism is
the project's choice.

**Artifact identity**
The immutable identifier of a built release artifact, a digest or a version the pipeline never
reuses, tied to the commit it was built from. Every environment deploys the same identity, the
release records it, and validation confirms it is what is running (O-24).

**Plugin**
An optional pack that adds skills, steps, processes, or guidance without changing core. Two
kinds: tech-stack packs and process packs. Plugins supply specifics; core supplies the
framework.

**Extension**
Anything added outside core: a plugin (either kind), a project skill, a target adapter, added
guidance, or an added requirement. Every extension declares its requirements and carries its
own feature files. `/aa-fw-extend` is the framework skill that helps the user create, validate,
install, and share one.

**Target**
An agent environment the SDK installs into (Claude Code, Codex, Cursor, Hermes, OpenClaw, and
others). Only commands, hooks, and subagent definitions differ per target.

**Scope**
Where an install lands and whose configuration applies: project, user, team, or enterprise.

**Health**
The `/aa-fw-health` agent command. Aggregates every declared requirement, probes each one, and reports
which are met, unmet, or not applicable, and what depends on each. It never blocks and never
changes anything.

**Init**
Bootstrapping a repository, in two parts. `aa init` on the CLI lays down what needs no agent:
the project config, the documents folder, project-scope skills and commands. `/aa-fw-init` inside
the agent runs health, then fixes the unmet requirements that need judgement, with the user's
consent, and reports the rest.

**Setup**
The `aa setup` CLI verb. Bootstraps the machine: detects installed agent targets, installs skills
and commands for each at user scope, and writes the user config. The main CLI verb.

**CLI verb and agent command**
`aa <verb>` runs on the developer's machine without an agent and only bootstraps and maintains
the install. `/aa-<code>-<step>` runs inside the agent and does a discipline's work, with
`fw` as the code for the framework's own commands. Health is an agent command only; there is
no `aa health`.

## How the terms fit together

```
Tenets            govern everything below
Opinions          the stances the framework takes where alternatives exist
  Discipline      groups skills by kind of work
    Step          one unit of work, delivered as a Skill, invoked by a Command
      Guidance    how best to perform the step
      Artifact    what the step produces
      Requirement what the step or its guidance needs in order to be performed
  Process         an ordered set of Steps from any disciplines, toward a goal
      Guidance    how best to perform the process as a whole
Plugin            adds Steps, Processes, Guidance, or Requirements; never changes core
Health / Init     check every declared Requirement; bootstrap the ones that can be fixed
Target / Scope    where and for whom the above is installed
```
