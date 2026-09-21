# AA-SDLC Vocabulary

**Status:** working draft. Last updated 2026-09-21.

These terms are used consistently across the design, the skills, the website, and the health
command. When a word here is used in a document, it means exactly this.

## Structural terms

**Tenet**
A principle governing how the SDK and its content are designed. Tenets are few, stable, and
framework-level. They shape every discipline, process, step, and piece of guidance. See
[tenets.md](tenets.md).

**Discipline**
A set of skills related to performing a specific kind of work. Disciplines group skills by the
nature of the work, not by when it happens. Current disciplines: Business Analysis, Technical
Analysis, Refinement, Implementation Planning, Development, Testing, Documentation, Project
Management, and Operations (proposed, see design open questions).

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
in scope". They are declared where they arise, aggregated and checked by `aa-health`, and where
possible fixed by `aa-init`. See [requirements.md](requirements.md).

## Delivery terms

**Skill**
The unit delivered to an agent: a folder containing `SKILL.md` and optional references and
templates. One skill implements one step. Skills are grouped by discipline in the source tree and
ship unchanged to every target.

**Command**
The user-facing entry point that invokes a skill. Thin, target-neutral in source, rendered per
target by the installer. Named `aa-<step>` on every target, so the step `health` is invoked as
`aa-health`.

**Artifact**
A named deliverable a step produces, with acceptance criteria defined in the workflow. Same
artifact, same place, same name, every time.

**Anchor ticket**
The ticket a step reads from and writes to. The ticket system is the state store; the SDK owns
no process state.

**Plugin**
An optional pack that adds skills, steps, processes, or guidance without changing core. Two
kinds: tech-stack packs and process packs. Plugins supply specifics; core supplies the
framework.

**Target**
An agent environment the SDK installs into (Claude Code, Codex, Cursor, Hermes, OpenClaw, and
others). Only commands, hooks, and subagent definitions differ per target.

**Scope**
Where an install lands and whose configuration applies: project, user, team, or enterprise.

**Health**
The `aa-health` command. Aggregates every declared requirement, probes each one, and reports
which are met, unmet, or not applicable, and what depends on each. It never blocks and never
changes anything.

**Init**
The `aa-init` command. Bootstraps a project: runs health, then fixes the unmet requirements it
can fix, with the user's consent, and reports the rest.

## How the terms fit together

```
Tenets            govern everything below
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
